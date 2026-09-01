import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/group_member_entity.dart';

class GroupMemberTile extends StatelessWidget {
  final GroupMemberEntity member;
  final bool canRemove;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const GroupMemberTile({
    super.key,
    required this.member,
    this.canRemove = false,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: AppAvatar(
          imageUrl: member.avatarUrl, name: member.fullName, radius: 22),
      title: Text(member.fullName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (member.isAdmin)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Admin',
                style: TextStyle(
                  color: AppColors.primaryTealDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          if (canRemove && !member.isAdmin)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline,
                  color: AppColors.errorRed),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
