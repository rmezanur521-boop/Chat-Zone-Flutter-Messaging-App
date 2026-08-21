import 'app_user_model.dart';
import '../../domain/entities/friend_request_entity.dart';

class FriendRequestModel extends FriendRequestEntity {
  const FriendRequestModel({
    required super.requestId,
    required super.fromUser,
    required super.sentAt,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      requestId: (json['id'] ?? '').toString(),
      fromUser: AppUserModel(
        id: (json['senderId'] ?? '').toString(),
        userName: json['senderName']?.toString() ?? '',
        avatarUrl: json['senderProfilePicture']?.toString(),
      ),
      sentAt:
          DateTime.tryParse(json['sentAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
