import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/group_preview_entity.dart';

class GroupTile extends StatelessWidget {
  final GroupPreviewEntity group;
  final VoidCallback onTap;

  const GroupTile({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
        backgroundImage:
            group.avatarUrl != null ? NetworkImage(group.avatarUrl!) : null,
        child: group.avatarUrl == null
            ? const Icon(Icons.groups_rounded, color: AppColors.primaryTealDark)
            : null,
      ),
      title:
          Text(group.name, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(
        group.lastMessage ?? '${group.memberCount} members',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: group.lastMessageTime != null
          ? Text(
              DateFormatter.chatTimestamp(group.lastMessageTime!),
              style: const TextStyle(fontSize: 12, color: AppColors.slate),
            )
          : null,
    );
  }
}
