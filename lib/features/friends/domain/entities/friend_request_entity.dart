import 'package:equatable/equatable.dart';
import 'app_user_entity.dart';

class FriendRequestEntity extends Equatable {
  final String requestId;
  final AppUserEntity fromUser;
  final DateTime sentAt;

  const FriendRequestEntity({
    required this.requestId,
    required this.fromUser,
    required this.sentAt,
  });

  @override
  List<Object?> get props => [requestId, fromUser, sentAt];
}
