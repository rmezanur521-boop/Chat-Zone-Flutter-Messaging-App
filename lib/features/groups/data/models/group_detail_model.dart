import '../../domain/entities/group_detail_entity.dart';
import '../../domain/entities/group_member_entity.dart';
import 'group_message_model.dart';

class GroupMemberModel extends GroupMemberEntity {
  const GroupMemberModel({
    required super.id,
    required super.fullName,
    super.avatarUrl,
    super.isAdmin,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    return GroupMemberModel(
      id: (json['userId'] ?? json['id'] ?? '').toString(),
      fullName: json['fullName']?.toString() ?? '',
      avatarUrl: json['profilePicture']?.toString(),
      isAdmin: (json['role']?.toString() ?? '') == 'Admin',
    );
  }
}

class GroupDetailModel extends GroupDetailEntity {
  const GroupDetailModel({
    required super.id,
    required super.name,
    super.currentUserIsAdmin,
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
      currentUserIsAdmin: json['isAdmin'] == true,
      members: membersJson
          .map((e) => GroupMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      messages: messagesJson
          .map((e) => GroupMessageModel.fromJson(e as Map<String, dynamic>,
              groupId: id))
          .toList(),
    );
  }
}
