import '../../../../core/error/failures.dart';
import '../../domain/entities/group_detail_entity.dart';
import '../../domain/entities/group_message_entity.dart';
import '../../domain/entities/group_preview_entity.dart';
import '../../domain/repositories/groups_repository.dart';
import '../datasources/groups_remote_datasource.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final GroupsRemoteDataSource _remote;
  GroupsRepositoryImpl(this._remote);

  @override
  Future<List<GroupPreviewEntity>> getPreviews() async {
    try {
      return await _remote.getPreviews();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<GroupDetailEntity> getGroupDetail(String groupId) async {
    try {
      return await _remote.getGroupDetail(groupId);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<String> createGroup(
      {required String name, required List<String> memberIds}) async {
    try {
      return await _remote.createGroup(name: name, memberIds: memberIds);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<GroupMessageEntity> sendMessage(
      {required String groupId, required String content}) async {
    try {
      return await _remote.sendMessage(groupId: groupId, content: content);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<GroupMessageEntity> editMessage({
    required String groupId,
    required String messageId,
    required String content,
  }) async {
    try {
      return await _remote.editMessage(
          groupId: groupId, messageId: messageId, content: content);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> deleteMessage(
      {required String groupId, required String messageId}) async {
    try {
      await _remote.deleteMessage(groupId: groupId, messageId: messageId);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> addMember(
      {required String groupId, required String userId}) async {
    try {
      await _remote.addMember(groupId: groupId, userId: userId);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> removeMember(
      {required String groupId, required String userId}) async {
    try {
      await _remote.removeMember(groupId: groupId, userId: userId);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<GroupLeaveResultEntity> leaveGroup({required String groupId}) async {
    try {
      final data = await _remote.leaveGroup(groupId: groupId);
      return GroupLeaveResultEntity(
        groupDeleted: data['groupDeleted'] == true,
        newAdminId: data['newAdminId']?.toString(),
      );
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> deleteGroup({required String groupId}) async {
    try {
      await _remote.deleteGroup(groupId: groupId);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }
}
