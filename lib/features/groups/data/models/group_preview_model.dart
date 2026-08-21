import '../../domain/entities/group_preview_entity.dart';

class GroupPreviewModel extends GroupPreviewEntity {
  const GroupPreviewModel({
    required super.id,
    required super.name,
    super.avatarUrl,
    super.lastMessage,
    super.lastMessageTime,
    super.memberCount,
  });

  factory GroupPreviewModel.fromJson(Map<String, dynamic> json) {
    return GroupPreviewModel(
      id: (json['groupId'] ?? '').toString(),
      name: json['groupName']?.toString() ?? '',
      avatarUrl: null,
      lastMessage: json['lastMessage']?.toString(),
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.tryParse(json['lastMessageTime'].toString())
          : null,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
    );
  }
}
