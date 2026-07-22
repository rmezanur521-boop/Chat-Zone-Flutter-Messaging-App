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
    super.isEdited,
  });

  // ⚠️ Verify these keys against the actual backend JSON.
  factory GroupMessageModel.fromJson(Map<String, dynamic> json,
      {String? groupId}) {
    return GroupMessageModel(
      id: (json['id'] ?? json['messageId'] ?? '').toString(),
      groupId: (json['groupId'] ?? groupId ?? '').toString(),
      senderId: (json['senderId'] ?? '').toString(),
      senderName: json['senderName']?.toString() ?? '',
      senderAvatar: json['senderAvatarUrl']?.toString(),
      content: json['content']?.toString() ?? '',
      sentAt: DateTime.tryParse(json['sentAt']?.toString() ??
              json['createdAt']?.toString() ??
              '') ??
          DateTime.now(),
      isEdited: json['isEdited'] == true,
    );
  }
}
