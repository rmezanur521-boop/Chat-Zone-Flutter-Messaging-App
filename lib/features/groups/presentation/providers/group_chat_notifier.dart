import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/signalr_client.dart';
import '../../data/models/group_detail_model.dart';
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
    _joinGroup();
    loadDetail();
  }

  Future<void> _joinGroup() async {
    final id = int.tryParse(groupId);
    if (id == null) return;
    await _socket.invoke('JoinGroup', args: [id]);
  }

  void _listenIncoming() {
    _socket.on('ReceiveGroupMessage', (args) {
      if (args == null || args.isEmpty) return;
      final data = args[0] as Map<String, dynamic>;
      final message = GroupMessageModel.fromJson(data, groupId: groupId);
      final alreadyPresent = state.messages.any((m) => m.id == message.id);
      if (!alreadyPresent) {
        state = state.copyWith(messages: [...state.messages, message]);
      }
    });

    _socket.on('GroupMessageEdited', (args) {
      if (args == null || args.isEmpty) return;
      final data = args[0] as Map<String, dynamic>;
      final updated = GroupMessageModel.fromJson(data, groupId: groupId);
      state = state.copyWith(
        messages: [
          for (final m in state.messages) m.id == updated.id ? updated : m,
        ],
      );
    });

    _socket.on('GroupMessageDeleted', (args) {
      if (args == null || args.isEmpty) return;
      final deletedId = args[0].toString();
      state = state.copyWith(
        messages: [
          for (final m in state.messages)
            m.id == deletedId ? m.copyWith(isDeleted: true) : m,
        ],
      );
    });

    _socket.on('MemberLeft', (args) {
      if (args == null || args.isEmpty) return;
      final data = args[0] as Map<String, dynamic>;
      if ((data['groupId'] ?? '').toString() != groupId) return;
      final leftUserId = (data['userId'] ?? '').toString();
      state = state.copyWith(
        members: state.members.where((m) => m.id != leftUserId).toList(),
      );
    });

    _socket.on('AdminChanged', (args) {
      if (args == null || args.isEmpty) return;
      final data = args[0] as Map<String, dynamic>;
      if ((data['groupId'] ?? '').toString() != groupId) return;
      final newAdminId = (data['newAdminId'] ?? '').toString();
      state = state.copyWith(
        members: state.members
            .map((m) => GroupMemberModel(
                  id: m.id,
                  fullName: m.fullName,
                  avatarUrl: m.avatarUrl,
                  isAdmin: m.id == newAdminId,
                ))
            .toList(),
      );
    });

    _socket.on('GroupDeleted', (args) {
      if (args == null || args.isEmpty) return;
      final deletedGroupId = args[0].toString();
      if (deletedGroupId != groupId) return;
      state = state.copyWith(groupDeleted: true);
    });
  }

  Future<void> loadDetail() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final detail = await _repository.getGroupDetail(groupId);
      state = state.copyWith(
        isLoading: false,
        groupName: detail.name,
        currentUserIsAdmin: detail.currentUserIsAdmin,
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
      final alreadyPresent = state.messages.any((m) => m.id == message.id);
      state = state.copyWith(
        isSending: false,
        messages:
            alreadyPresent ? state.messages : [...state.messages, message],
      );
    } on Failure catch (f) {
      state = state.copyWith(isSending: false, errorMessage: f.message);
    }
  }

  Future<void> editMessage(String messageId, String newContent) async {
    final trimmed = newContent.trim();
    if (trimmed.isEmpty) return;
    state = state.copyWith(isSending: true, errorMessage: null);
    try {
      final updated = await _repository.editMessage(
          groupId: groupId, messageId: messageId, content: trimmed);
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
      await _repository.deleteMessage(groupId: groupId, messageId: messageId);
      state = state.copyWith(
        messages: [
          for (final m in state.messages)
            m.id == messageId ? m.copyWith(isDeleted: true) : m,
        ],
      );
    } on Failure catch (f) {
      state = state.copyWith(errorMessage: f.message);
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

  Future<bool> leaveGroup() async {
    try {
      await _repository.leaveGroup(groupId: groupId);
      final id = int.tryParse(groupId);
      if (id != null) {
        await _socket.invoke('LeaveGroupConnection', args: [id]);
      }
      state = state.copyWith(groupDeleted: true);
      return true;
    } on Failure catch (f) {
      state = state.copyWith(errorMessage: f.message);
      return false;
    }
  }

  Future<bool> deleteGroup() async {
    try {
      await _repository.deleteGroup(groupId: groupId);
      state = state.copyWith(groupDeleted: true);
      return true;
    } on Failure catch (f) {
      state = state.copyWith(errorMessage: f.message);
      return false;
    }
  }

  @override
  void dispose() {
    _socket.off('ReceiveGroupMessage');
    _socket.off('GroupMessageEdited');
    _socket.off('GroupMessageDeleted');
    _socket.off('MemberLeft');
    _socket.off('AdminChanged');
    _socket.off('GroupDeleted');
    _socketSubscription?.cancel();
    super.dispose();
  }
}
