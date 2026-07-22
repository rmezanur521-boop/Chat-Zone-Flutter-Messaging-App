import '../../../../core/error/failures.dart';
import '../../domain/entities/conversation_preview_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/messages_repository.dart';
import '../datasources/messages_remote_datasource.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesRemoteDataSource _remote;
  MessagesRepositoryImpl(this._remote);

  @override
  Future<List<ConversationPreviewEntity>> getPreviews() async {
    try {
      return await _remote.getPreviews();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<List<MessageEntity>> getConversation(String userId) async {
    try {
      return await _remote.getConversation(userId);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<MessageEntity> sendMessage(
      {required String receiverId, required String content}) async {
    try {
      return await _remote.sendMessage(
          receiverId: receiverId, content: content);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<MessageEntity> editMessage(
      {required String messageId, required String content}) async {
    try {
      return await _remote.editMessage(messageId: messageId, content: content);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    try {
      await _remote.deleteMessage(messageId);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }
}
