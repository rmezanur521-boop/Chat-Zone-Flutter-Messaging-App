import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../friends/presentation/providers/friends_providers.dart';
import '../../../messages/presentation/widgets/chat_input_bar.dart';
import '../../domain/entities/group_message_entity.dart';
import '../providers/groups_providers.dart';
import '../widgets/group_member_tile.dart';
import '../widgets/group_message_bubble.dart';

class GroupChatPage extends ConsumerStatefulWidget {
  final String groupId;
  const GroupChatPage({super.key, required this.groupId});

  @override
  ConsumerState<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends ConsumerState<GroupChatPage> {
  final _messageController = TextEditingController();
  GroupMessageEntity? _editingMessage;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;
    if (_editingMessage != null) {
      ref
          .read(groupChatNotifierProvider(widget.groupId).notifier)
          .editMessage(_editingMessage!.id, text);
      setState(() => _editingMessage = null);
    } else {
      ref
          .read(groupChatNotifierProvider(widget.groupId).notifier)
          .sendMessage(text);
    }
    _messageController.clear();
  }

  void _startEdit(GroupMessageEntity message) {
    setState(() {
      _editingMessage = message;
      _messageController.text = message.content;
      _messageController.selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController.text.length));
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingMessage = null;
      _messageController.clear();
    });
  }

  Future<void> _confirmDeleteMessage(GroupMessageEntity message) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete message'),
        content: const Text('This message will be deleted for everyone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      ref
          .read(groupChatNotifierProvider(widget.groupId).notifier)
          .deleteMessage(message.id);
    }
  }

  void _openProfile(String userId) {
    final friends = ref.read(friendsListProvider).asData?.value ?? [];
    final isFriend = friends.any((f) => f.id == userId);
    context.push(
      '${AppRoutes.friendDetails}/$userId',
      extra: {'isFriend': isFriend},
    );
  }

  void _showMembersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _MembersSheet(
        groupId: widget.groupId,
        onOpenProfile: _openProfile,
      ),
    );
  }

  Future<void> _confirmLeaveGroup() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave group'),
        content: const Text('Are you sure you want to leave this group?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Leave')),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref
        .read(groupChatNotifierProvider(widget.groupId).notifier)
        .leaveGroup();
  }

  Future<void> _confirmDeleteGroup() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete group'),
        content:
            const Text('This will permanently delete the group for everyone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref
        .read(groupChatNotifierProvider(widget.groupId).notifier)
        .deleteGroup();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(groupChatNotifierProvider(widget.groupId));
    final currentUserId = ref.watch(authNotifierProvider).user?.id;

    ref.listen(groupChatNotifierProvider(widget.groupId), (previous, next) {
      final wasDeleted = previous?.groupDeleted ?? false;
      if (next.groupDeleted && !wasDeleted && mounted) {
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title:
            Text(chatState.groupName.isEmpty ? 'Group' : chatState.groupName),
        actions: [
          IconButton(
              icon: const Icon(Icons.group_outlined),
              onPressed: _showMembersSheet),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'leave') _confirmLeaveGroup();
              if (value == 'delete') _confirmDeleteGroup();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'leave', child: Text('Leave group')),
              if (chatState.currentUserIsAdmin)
                const PopupMenuItem(
                    value: 'delete', child: Text('Delete group')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.isLoading && chatState.messages.isEmpty
                ? const AppLoader()
                : chatState.errorMessage != null && chatState.messages.isEmpty
                    ? Center(child: Text(chatState.errorMessage!))
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: chatState.messages.length,
                        itemBuilder: (context, index) {
                          final reversedIndex =
                              chatState.messages.length - 1 - index;
                          final message = chatState.messages[reversedIndex];
                          return GroupMessageBubble(
                            message: message,
                            isMe: message.senderId == currentUserId,
                            onEdit: _startEdit,
                            onDelete: _confirmDeleteMessage,
                            onTapSender: () => _openProfile(message.senderId),
                          );
                        },
                      ),
          ),
          ChatInputBar(
            controller: _messageController,
            isSending: chatState.isSending,
            onSend: _send,
            isEditing: _editingMessage != null,
            onCancelEdit: _cancelEdit,
          ),
        ],
      ),
    );
  }
}

class _MembersSheet extends ConsumerWidget {
  final String groupId;
  final ValueChanged<String> onOpenProfile;
  const _MembersSheet({required this.groupId, required this.onOpenProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(groupChatNotifierProvider(groupId));
    final friendsState = ref.watch(friendsListProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Members',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                if (chatState.currentUserIsAdmin)
                  TextButton.icon(
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                    label: const Text('Add'),
                    onPressed: () {
                      final currentMemberIds =
                          chatState.members.map((m) => m.id).toSet();
                      final candidates = friendsState.asData?.value
                              .where((f) => !currentMemberIds.contains(f.id))
                              .toList() ??
                          [];
                      showDialog(
                        context: context,
                        builder: (ctx) => SimpleDialog(
                          title: const Text('Add member'),
                          children: candidates.isEmpty
                              ? [
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                          'All your friends are already in this group.'))
                                ]
                              : candidates
                                  .map((f) => SimpleDialogOption(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          ref
                                              .read(groupChatNotifierProvider(
                                                      groupId)
                                                  .notifier)
                                              .addMember(f.id);
                                        },
                                        child: Text(f.userName),
                                      ))
                                  .toList(),
                        ),
                      );
                    },
                  ),
              ],
            ),
            const Divider(),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: chatState.members.length,
                itemBuilder: (context, i) {
                  final member = chatState.members[i];
                  return GroupMemberTile(
                    member: member,
                    canRemove: chatState.currentUserIsAdmin,
                    onTap: () {
                      Navigator.pop(context);
                      onOpenProfile(member.id);
                    },
                    onRemove: () => ref
                        .read(groupChatNotifierProvider(groupId).notifier)
                        .removeMember(member.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
