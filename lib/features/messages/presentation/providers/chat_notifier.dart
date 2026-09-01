import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/messages_socket_datasource.dart';
import '../../domain/repositories/messages_repository.dart';
import 'chat_state.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  final MessagesRepository _repository;
  final MessagesSocketDataSource _socket;
  final String currentUserId;
  final String otherUserId;
  StreamSubscription? _subscription;

  ChatNotifier({
    required MessagesRepository repository,
    required MessagesSocketDataSource socket,
    required this.currentUserId,
    required this.otherUserId,
  })  : _repository = repository,
        _socket = socket,
        super(const ChatState()) {
    _listenIncoming();
    loadConversation();
  }

  void _listenIncoming() {
    _subscription = _socket.incomingMessages.listen((message) {
      final isFromOtherParty = message.senderId == otherUserId;
      final alreadyPresent = state.messages.any((m) => m.id == message.id);
      if (isFromOtherParty && !alreadyPresent) {
        state = state.copyWith(messages: [...state.messages, message]);
      }
    });
  }

  Future<void> loadConversation() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final messages = await _repository.getConversation(otherUserId);
      state = state.copyWith(isLoading: false, messages: messages);
    } on Failure catch (f) {
      state = state.copyWith(isLoading: false, errorMessage: f.message);
    }
  }

  Future<void> sendMessage(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    state = state.copyWith(isSending: true, errorMessage: null);
    try {
      final message = await _repository.sendMessage(
          receiverId: otherUserId, content: trimmed);
      state = state
          .copyWith(isSending: false, messages: [...state.messages, message]);
    } on Failure catch (f) {
      state = state.copyWith(isSending: false, errorMessage: f.message);
    }
  }

  Future<void> editMessage(String messageId, String newContent) async {
    final trimmed = newContent.trim();
    if (trimmed.isEmpty) return;
    state = state.copyWith(isSending: true, errorMessage: null);
    try {
      final updated =
          await _repository.editMessage(messageId: messageId, content: trimmed);
      state = state.copyWith(
        isSending: false,
        messages: [
          for (final m in state.messages) m.id == messageId ? updated : m,
        ],
      );
    } on Failure catch (f) {
      state = state.copyWith(isSending: false, errorMessage: f.message);
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await _repository.deleteMessage(messageId);
      state = state.copyWith(
        messages: [
          for (final m in state.messages)
            m.id == messageId
                ? m.copyWith(isDeleted: true, deletedAt: DateTime.now())
                : m,
        ],
      );
    } on Failure catch (f) {
      state = state.copyWith(errorMessage: f.message);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
