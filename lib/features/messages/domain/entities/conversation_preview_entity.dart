import 'package:equatable/equatable.dart';

class ConversationPreviewEntity extends Equatable {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  const ConversationPreviewEntity({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [
        userId,
        userName,
        avatarUrl,
        lastMessage,
        lastMessageTime,
        unreadCount,
        isOnline,
      ];
}
