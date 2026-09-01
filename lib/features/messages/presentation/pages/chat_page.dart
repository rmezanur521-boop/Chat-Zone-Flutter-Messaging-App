import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../domain/entities/message_entity.dart';
import '../providers/messages_providers.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/message_bubble.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;

  const ChatPage({
    super.key,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  MessageEntity? _editingMessage;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;
    if (_editingMessage != null) {
      ref
          .read(chatNotifierProvider(widget.otherUserId).notifier)
          .editMessage(_editingMessage!.id, text);
      setState(() => _editingMessage = null);
    } else {
      ref
          .read(chatNotifierProvider(widget.otherUserId).notifier)
          .sendMessage(text);
    }
    _messageController.clear();
  }

  void _startEdit(MessageEntity message) {
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

  Future<void> _confirmDelete(MessageEntity message) async {
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
          .read(chatNotifierProvider(widget.otherUserId).notifier)
          .deleteMessage(message.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider(widget.otherUserId));
    final currentUserId = ref.watch(authNotifierProvider).user?.id;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            AppAvatar(
                imageUrl: widget.otherUserAvatar,
                name: widget.otherUserName,
                radius: 18),
            const SizedBox(width: 10),
            Expanded(
              child:
                  Text(widget.otherUserName, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
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
                          return MessageBubble(
                            message: message,
                            isMe: message.senderId == currentUserId,
                            onEdit: _startEdit,
                            onDelete: _confirmDelete,
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
