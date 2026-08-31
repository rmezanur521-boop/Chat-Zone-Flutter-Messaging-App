import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/group_detail_model.dart';
import '../models/group_message_model.dart';
import '../models/group_preview_model.dart';

class GroupsRemoteDataSource {
  final ApiClient _client;
  GroupsRemoteDataSource(this._client);

  Future<List<GroupPreviewModel>> getPreviews() async {
    final json = await _client.get(ApiConstants.groupPreviews);
    final list = json['data'] as List? ?? [];
    return list
        .map((e) => GroupPreviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<GroupDetailModel> getGroupDetail(String groupId) async {
    final json = await _client.get(ApiConstants.groupDetail(groupId));
    return GroupDetailModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<String> createGroup(
      {required String name, required List<String> memberIds}) async {
    final json = await _client.post(
      ApiConstants.createGroup,
      body: {'name': name, 'memberIds': memberIds},
    );
    final data = json['data'] as Map<String, dynamic>?;
    return (data?['groupId'] ?? '').toString();
  }

  Future<GroupMessageModel> sendMessage(
      {required String groupId, required String content}) async {
    final json = await _client.post(
      ApiConstants.sendGroupMessage(groupId),
      body: {'content': content},
    );
    return GroupMessageModel.fromJson(json['data'] as Map<String, dynamic>,
        groupId: groupId);
  }

  Future<GroupMessageModel> editMessage({
    required String groupId,
    required String messageId,
    required String content,
  }) async {
    final json = await _client.put(
      ApiConstants.editGroupMessage(groupId, messageId),
      body: {'newContent': content},
    );
    return GroupMessageModel.fromJson(json['data'] as Map<String, dynamic>,
        groupId: groupId);
  }

  Future<void> deleteMessage(
      {required String groupId, required String messageId}) async {
    await _client.delete(ApiConstants.deleteGroupMessage(groupId, messageId));
  }

  Future<void> addMember(
      {required String groupId, required String userId}) async {
    await _client.post(ApiConstants.addGroupMember(groupId, userId));
  }

  Future<void> removeMember(
      {required String groupId, required String userId}) async {
    await _client.delete(ApiConstants.removeGroupMember(groupId, userId));
  }
}
