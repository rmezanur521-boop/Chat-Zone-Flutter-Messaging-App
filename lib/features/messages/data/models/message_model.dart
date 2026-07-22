import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.content,
    required super.sentAt,
    super.isEdited,
  });

  // ⚠️ Verify these keys against the actual backend JSON (Swagger)
  // and adjust if field names differ.
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: (json['id'] ?? json['messageId'] ?? '').toString(),
      senderId: (json['senderId'] ?? '').toString(),
      receiverId: (json['receiverId'] ?? '').toString(),
      content: json['content']?.toString() ?? '',
      sentAt: DateTime.tryParse(json['sentAt']?.toString() ??
              json['createdAt']?.toString() ??
              '') ??
          DateTime.now(),
      isEdited: json['isEdited'] == true,
    );
  }
}
