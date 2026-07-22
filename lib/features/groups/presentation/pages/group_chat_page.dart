import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../friends/presentation/providers/friends_providers.dart';
import '../../../messages/presentation/widgets/chat_input_bar.dart';
import '../providers/groups_providers.dart';
import '../widgets/group_message_bubble.dart';

class GroupChatPage extends ConsumerStatefulWidget {
  final String groupId;
  const GroupChatPage({super.key, required this.groupId});

  @override
  ConsumerState<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends ConsumerState<GroupChatPage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;
    ref
        .read(groupChatNotifierProvider(widget.groupId).notifier)
        .sendMessage(text);
    _messageController.clear();
  }

  void _showMembersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _MembersSheet(groupId: widget.groupId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(groupChatNotifierProvider(widget.groupId));
    final currentUserId = ref.watch(authNotifierProvider).user?.id;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(chatState.groupName.isEmpty ? 'Group' : chatState.groupName),
        actions: [
          IconButton(
              icon: const Icon(Icons.group_outlined),
              onPressed: _showMembersSheet),
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
                          );
                        },
                      ),
          ),
          ChatInputBar(
            controller: _messageController,
            isSending: chatState.isSending,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

class _MembersSheet extends ConsumerWidget {
  final String groupId;
  const _MembersSheet({required this.groupId});

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
                  return ListTile(
                    title: Text(member.userName),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => ref
                          .read(groupChatNotifierProvider(groupId).notifier)
                          .removeMember(member.id),
                    ),
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
