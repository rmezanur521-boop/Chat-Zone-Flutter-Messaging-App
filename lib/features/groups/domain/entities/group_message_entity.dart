import 'package:equatable/equatable.dart';

class GroupMessageEntity extends Equatable {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final DateTime sentAt;
  final DateTime? editedAt;
  final bool isDeleted;
  final bool isEdited;

  const GroupMessageEntity({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    required this.sentAt,
    this.editedAt,
    this.isDeleted = false,
  }) : isEdited = editedAt != null;

  @override
  List<Object?> get props => [
        id,
        groupId,
        senderId,
        senderName,
        senderAvatar,
        content,
        sentAt,
        editedAt,
        isDeleted,
      ];
}
