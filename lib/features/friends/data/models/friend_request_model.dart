import 'app_user_model.dart';
import '../../domain/entities/friend_request_entity.dart';

class FriendRequestModel extends FriendRequestEntity {
  const FriendRequestModel({
    required super.requestId,
    required super.fromUser,
    required super.sentAt,
  });

  // ⚠️ Verify these keys against the actual /api/friends/requests response.
  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      requestId: (json['requestId'] ?? json['id'] ?? '').toString(),
      fromUser: AppUserModel.fromJson(
          (json['fromUser'] ?? json['sender'] ?? json) as Map<String, dynamic>),
      sentAt:
          DateTime.tryParse(json['sentAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
