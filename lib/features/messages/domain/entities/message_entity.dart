import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime sentAt;
  final DateTime? editedAt;
  final DateTime? deletedAt;
  final bool isDeleted;
  final bool isEdited;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.sentAt,
    this.editedAt,
    this.deletedAt,
    this.isDeleted = false,
  }) : isEdited = editedAt != null;

  MessageEntity copyWith({
    String? content,
    DateTime? editedAt,
    DateTime? deletedAt,
    bool? isDeleted,
  }) {
    return MessageEntity(
      id: id,
      senderId: senderId,
      senderName: senderName,
      content: content ?? this.content,
      sentAt: sentAt,
      editedAt: editedAt ?? this.editedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        senderId,
        senderName,
        content,
        sentAt,
        editedAt,
        deletedAt,
        isDeleted
      ];
}
