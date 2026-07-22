import '../../domain/entities/conversation_preview_entity.dart';

class ConversationPreviewModel extends ConversationPreviewEntity {
  const ConversationPreviewModel({
    required super.userId,
    required super.userName,
    super.avatarUrl,
    required super.lastMessage,
    required super.lastMessageTime,
    super.unreadCount,
    super.isOnline,
  });

  // ⚠️ Verify these keys against the actual /api/messages/previews response.
  factory ConversationPreviewModel.fromJson(Map<String, dynamic> json) {
    return ConversationPreviewModel(
      userId: (json['userId'] ?? json['id'] ?? '').toString(),
      userName: json['userName']?.toString() ?? '',
      avatarUrl: json['profilePictureUrl']?.toString() ??
          json['avatarUrl']?.toString(),
      lastMessage: json['lastMessage']?.toString() ?? '',
      lastMessageTime:
          DateTime.tryParse(json['lastMessageTime']?.toString() ?? '') ??
              DateTime.now(),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isOnline: json['isOnline'] == true,
    );
  }
}
