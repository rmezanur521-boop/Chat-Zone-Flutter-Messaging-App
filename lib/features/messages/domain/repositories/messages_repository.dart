import '../entities/conversation_preview_entity.dart';
import '../entities/message_entity.dart';

abstract class MessagesRepository {
  Future<List<ConversationPreviewEntity>> getPreviews();
  Future<List<MessageEntity>> getConversation(String userId);
  Future<MessageEntity> sendMessage(
      {required String receiverId, required String content});
  Future<MessageEntity> editMessage(
      {required String messageId, required String content});
  Future<void> deleteMessage(String messageId);
}
