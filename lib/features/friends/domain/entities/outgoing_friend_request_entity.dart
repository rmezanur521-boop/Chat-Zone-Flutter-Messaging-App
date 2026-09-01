import 'package:equatable/equatable.dart';

class OutgoingFriendRequestEntity extends Equatable {
  final String userId;
  final String status;

  const OutgoingFriendRequestEntity({
    required this.userId,
    required this.status,
  });

  @override
  List<Object?> get props => [userId, status];
}
