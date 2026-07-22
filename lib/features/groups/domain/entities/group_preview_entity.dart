import 'package:equatable/equatable.dart';

class GroupPreviewEntity extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int memberCount;

  const GroupPreviewEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.lastMessage,
    this.lastMessageTime,
    this.memberCount = 0,
  });

  @override
  List<Object?> get props =>
      [id, name, avatarUrl, lastMessage, lastMessageTime, memberCount];
}
