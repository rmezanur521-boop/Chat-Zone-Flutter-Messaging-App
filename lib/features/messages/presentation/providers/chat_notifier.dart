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
      final belongsToThisChat = (message.senderId == otherUserId &&
              message.receiverId == currentUserId) ||
          (message.senderId == currentUserId &&
              message.receiverId == otherUserId);
      if (belongsToThisChat) {
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
