import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/signalr_client.dart';
import '../../data/models/group_message_model.dart';
import '../../domain/repositories/groups_repository.dart';
import 'group_chat_state.dart';

class GroupChatNotifier extends StateNotifier<GroupChatState> {
  final GroupsRepository _repository;
  final SignalRClient _socket;
  final String groupId;
  StreamSubscription? _socketSubscription;

  GroupChatNotifier({
    required GroupsRepository repository,
    required SignalRClient socket,
    required this.groupId,
  })  : _repository = repository,
        _socket = socket,
        super(const GroupChatState()) {
    _listenIncoming();
    loadDetail();
  }

  void _listenIncoming() {
    // ⚠️ Verify event name 'ReceiveGroupMessage' against the actual hub.
    _socket.on('ReceiveGroupMessage', (args) {
      if (args == null || args.isEmpty) return;
      final data = args[0] as Map<String, dynamic>;
      final message = GroupMessageModel.fromJson(data, groupId: groupId);
      if (message.groupId == groupId) {
        state = state.copyWith(messages: [...state.messages, message]);
      }
    });
  }

  Future<void> loadDetail() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final detail = await _repository.getGroupDetail(groupId);
      state = state.copyWith(
        isLoading: false,
        groupName: detail.name,
        members: detail.members,
        messages: detail.messages,
      );
    } on Failure catch (f) {
      state = state.copyWith(isLoading: false, errorMessage: f.message);
    }
  }

  Future<void> sendMessage(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    state = state.copyWith(isSending: true, errorMessage: null);
    try {
      final message =
          await _repository.sendMessage(groupId: groupId, content: trimmed);
      state = state
          .copyWith(isSending: false, messages: [...state.messages, message]);
    } on Failure catch (f) {
      state = state.copyWith(isSending: false, errorMessage: f.message);
    }
  }

  Future<bool> addMember(String userId) async {
    try {
      await _repository.addMember(groupId: groupId, userId: userId);
      await loadDetail();
      return true;
    } on Failure catch (f) {
      state = state.copyWith(errorMessage: f.message);
      return false;
    }
  }

  Future<bool> removeMember(String userId) async {
    try {
      await _repository.removeMember(groupId: groupId, userId: userId);
      await loadDetail();
      return true;
    } on Failure catch (f) {
      state = state.copyWith(errorMessage: f.message);
      return false;
    }
  }

  @override
  void dispose() {
    _socket.off('ReceiveGroupMessage');
    _socketSubscription?.cancel();
    super.dispose();
  }
}
