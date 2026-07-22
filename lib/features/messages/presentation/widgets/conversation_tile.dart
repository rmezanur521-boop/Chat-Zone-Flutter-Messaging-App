import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/conversation_preview_entity.dart';

class ConversationTile extends StatelessWidget {
  final ConversationPreviewEntity preview;
  final VoidCallback onTap;

  const ConversationTile(
      {super.key, required this.preview, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasUnread = preview.unreadCount > 0;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: AppAvatar(
        imageUrl: preview.avatarUrl,
        name: preview.userName,
        radius: 26,
        isOnline: preview.isOnline,
      ),
      title: Text(
        preview.userName,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        preview.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: hasUnread ? null : AppColors.slate,
          fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            DateFormatter.chatTimestamp(preview.lastMessageTime),
            style: TextStyle(fontSize: 12, color: AppColors.slate),
          ),
          const SizedBox(height: 6),
          if (hasUnread)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                preview.unreadCount > 99 ? '99+' : '${preview.unreadCount}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }
}
