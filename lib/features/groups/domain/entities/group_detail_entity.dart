import 'package:equatable/equatable.dart';
import 'group_member_entity.dart';
import 'group_message_entity.dart';

class GroupDetailEntity extends Equatable {
  final String id;
  final String name;
  final bool currentUserIsAdmin;
  final List<GroupMemberEntity> members;
  final List<GroupMessageEntity> messages;

  const GroupDetailEntity({
    required this.id,
    required this.name,
    this.currentUserIsAdmin = false,
    required this.members,
    required this.messages,
  });

  @override
  List<Object?> get props => [id, name, currentUserIsAdmin, members, messages];
}
