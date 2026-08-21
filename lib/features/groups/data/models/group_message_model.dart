import '../../domain/entities/group_message_entity.dart';

class GroupMessageModel extends GroupMessageEntity {
  const GroupMessageModel({
    required super.id,
    required super.groupId,
    required super.senderId,
    required super.senderName,
    super.senderAvatar,
    required super.content,
    required super.sentAt,
    super.editedAt,
    super.isDeleted,
  });

  factory GroupMessageModel.fromJson(Map<String, dynamic> json,
      {required String groupId}) {
    return GroupMessageModel(
      id: (json['id'] ?? '').toString(),
      groupId: groupId,
      senderId: (json['senderId'] ?? '').toString(),
      senderName: json['senderName']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      sentAt:
          DateTime.tryParse(json['sentAt']?.toString() ?? '') ?? DateTime.now(),
      editedAt: json['editedAt'] != null
          ? DateTime.tryParse(json['editedAt'].toString())
          : null,
      isDeleted: json['isDeleted'] == true,
    );
  }
}
