import '../../domain/entities/outgoing_friend_request_entity.dart';

class OutgoingFriendRequestModel extends OutgoingFriendRequestEntity {
  const OutgoingFriendRequestModel({
    required super.userId,
    required super.status,
  });

  factory OutgoingFriendRequestModel.fromJson(Map<String, dynamic> json) {
    return OutgoingFriendRequestModel(
      userId: (json['userId'] ?? '').toString(),
      status: json['status']?.toString() ?? '',
    );
  }
}
