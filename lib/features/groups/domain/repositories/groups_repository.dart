import '../entities/group_detail_entity.dart';
import '../entities/group_message_entity.dart';
import '../entities/group_preview_entity.dart';

abstract class GroupsRepository {
  Future<List<GroupPreviewEntity>> getPreviews();
  Future<GroupDetailEntity> getGroupDetail(String groupId);
  Future<String> createGroup(
      {required String name, required List<String> memberIds});
  Future<GroupMessageEntity> sendMessage(
      {required String groupId, required String content});
  Future<GroupMessageEntity> editMessage(
      {required String groupId,
      required String messageId,
      required String content});
  Future<void> deleteMessage(
      {required String groupId, required String messageId});
  Future<void> addMember({required String groupId, required String userId});
  Future<void> removeMember({required String groupId, required String userId});
}
