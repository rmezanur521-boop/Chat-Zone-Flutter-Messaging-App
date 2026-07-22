import 'package:flutter/material.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/app_user_entity.dart';

/// Generic user row used across Friends list, Search results,
/// and the "add member" picker.
class UserListTile extends StatelessWidget {
  final AppUserEntity user;
  final VoidCallback? onTap;
  final Widget? trailing;

  const UserListTile(
      {super.key, required this.user, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: AppAvatar(
          imageUrl: user.avatarUrl,
          name: user.userName,
          radius: 24,
          isOnline: user.isOnline),
      title: Text(user.userName,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: user.email != null ? Text(user.email!) : null,
      trailing: trailing,
    );
  }
}
