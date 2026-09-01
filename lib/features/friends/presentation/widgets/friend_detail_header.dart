import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/app_user_entity.dart';

class FriendDetailHeader extends StatelessWidget {
  final AppUserEntity user;

  const FriendDetailHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          AppAvatar(
            imageUrl: user.avatarUrl,
            name: user.fullName,
            radius: 56,
            isOnline: user.isOnline,
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (user.isOnline)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Online',
                style: TextStyle(
                  color: AppColors.onlineGreen,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
