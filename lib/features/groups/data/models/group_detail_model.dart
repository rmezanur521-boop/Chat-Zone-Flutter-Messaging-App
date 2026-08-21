import '../../../friends/data/models/app_user_model.dart';
import '../../domain/entities/group_detail_entity.dart';
import 'group_message_model.dart';

class GroupDetailModel extends GroupDetailEntity {
  const GroupDetailModel({
    required super.id,
    required super.name,
    required super.members,
    required super.messages,
  });

  factory GroupDetailModel.fromJson(Map<String, dynamic> json) {
    final id = (json['groupId'] ?? '').toString();
    final membersJson = json['members'] as List? ?? [];
    final messagesJson = json['messages'] as List? ?? [];
    return GroupDetailModel(
      id: id,
      name: json['groupName']?.toString() ?? '',
      members: membersJson
          .map((e) => AppUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      messages: messagesJson
          .map((e) => GroupMessageModel.fromJson(e as Map<String, dynamic>,
              groupId: id))
          .toList(),
    );
  }
}
