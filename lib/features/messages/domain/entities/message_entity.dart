import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime sentAt;
  final DateTime? editedAt;
  final bool isDeleted;
  final bool isEdited;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.sentAt,
    this.editedAt,
    this.isDeleted = false,
  }) : isEdited = editedAt != null;

  @override
  List<Object?> get props =>
      [id, senderId, senderName, content, sentAt, editedAt, isDeleted];
}
