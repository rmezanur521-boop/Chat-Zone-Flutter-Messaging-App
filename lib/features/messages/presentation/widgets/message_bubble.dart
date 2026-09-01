import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;
  final ValueChanged<MessageEntity>? onEdit;
  final ValueChanged<MessageEntity>? onDelete;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.onEdit,
    this.onDelete,
  });

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit message'),
              onTap: () {
                Navigator.pop(ctx);
                onEdit?.call(message);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: AppColors.errorRed),
              title: const Text('Delete message',
                  style: TextStyle(color: AppColors.errorRed)),
              onTap: () {
                Navigator.pop(ctx);
                onDelete?.call(message);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bubbleColor = isMe
        ? (isDark ? AppColors.bubbleSentDark : AppColors.bubbleSentLight)
        : (isDark
            ? AppColors.bubbleReceivedDark
            : AppColors.bubbleReceivedLight);
    final textColor =
        isMe ? Colors.white : (isDark ? Colors.white : AppColors.navyDeep);
    final footerColor = textColor.withValues(alpha: 0.6);
    final canModify =
        isMe && !message.isDeleted && (onEdit != null || onDelete != null);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: canModify ? () => _showOptions(context) : null,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.isDeleted
                    ? 'This message was deleted'
                    : message.content,
                style: TextStyle(
                  color: message.isDeleted ? footerColor : textColor,
                  fontSize: 15,
                  fontStyle:
                      message.isDeleted ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.isDeleted
                    ? 'Deleted • ${DateFormatter.chatTimestamp(message.deletedAt ?? message.sentAt)}'
                    : message.isEdited
                        ? 'Edited • ${DateFormatter.chatTimestamp(message.editedAt!)}'
                        : DateFormatter.chatTimestamp(message.sentAt),
                style: TextStyle(color: footerColor, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
