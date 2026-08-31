import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/conversation_preview_model.dart';
import '../models/message_model.dart';

class MessagesRemoteDataSource {
  final ApiClient _client;
  MessagesRemoteDataSource(this._client);

  Future<List<ConversationPreviewModel>> getPreviews() async {
    final json = await _client.get(ApiConstants.messagePreviews);
    final list = json['data'] as List? ?? [];
    return list
        .map(
            (e) => ConversationPreviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MessageModel>> getConversation(String userId) async {
    final json = await _client.get(ApiConstants.conversation(userId));
    final list = json['data'] as List? ?? [];
    return list
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MessageModel> sendMessage({
    required String receiverId,
    required String content,
  }) async {
    final json = await _client.post(
      ApiConstants.sendMessage,
      body: {'receiverId': receiverId, 'content': content},
    );
    return MessageModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<MessageModel> editMessage({
    required String messageId,
    required String content,
  }) async {
    final json = await _client.put(
      ApiConstants.editMessage(messageId),
      body: {'newContent': content},
    );
    return MessageModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<void> deleteMessage(String messageId) async {
    await _client.delete(ApiConstants.deleteMessage(messageId));
  }
}
