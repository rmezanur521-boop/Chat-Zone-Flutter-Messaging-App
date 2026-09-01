import 'package:flutter/material.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/app_user_entity.dart';

class UserListTile extends StatelessWidget {
  final AppUserEntity user;
  final VoidCallback? onTap;
  final Widget? trailing;

  const UserListTile({
    super.key,
    required this.user,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: AppAvatar(
        imageUrl: user.avatarUrl,
        name: user.fullName,
        radius: 24,
        isOnline: user.isOnline,
      ),
      title: Text(
        user.fullName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: user.email != null ? Text(user.email!) : null,
      trailing: trailing,
    );
  }
}
