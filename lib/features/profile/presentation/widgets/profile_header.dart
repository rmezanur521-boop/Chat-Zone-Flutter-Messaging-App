import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? bio;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;
  final bool isUploading;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.bio,
    this.avatarUrl,
    this.onAvatarTap,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            AppAvatar(imageUrl: avatarUrl, name: name, radius: 48),
            if (isUploading)
              Positioned.fill(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.black.withValues(alpha: 0.4),
                  child: const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                ),
              ),
            if (onAvatarTap != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: onAvatarTap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                        size: 16, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Text(name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(email, style: const TextStyle(color: AppColors.slate)),
        if (bio != null && bio!.isNotEmpty) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(bio!, textAlign: TextAlign.center),
          ),
        ],
      ],
    );
  }
}
