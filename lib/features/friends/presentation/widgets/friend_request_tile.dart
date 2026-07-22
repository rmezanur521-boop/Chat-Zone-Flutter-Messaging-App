import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/friend_request_entity.dart';

class FriendRequestTile extends StatelessWidget {
  final FriendRequestEntity request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const FriendRequestTile({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AppAvatar(
        imageUrl: request.fromUser.avatarUrl,
        name: request.fromUser.userName,
        radius: 24,
      ),
      title: Text(request.fromUser.userName,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: const Text('Sent you a friend request'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onAccept,
            icon: const Icon(Icons.check_circle, color: AppColors.primaryTeal),
          ),
          IconButton(
            onPressed: onReject,
            icon: const Icon(Icons.cancel, color: AppColors.errorRed),
          ),
        ],
      ),
    );
  }
}
