import 'package:equatable/equatable.dart';
import '../../../friends/domain/entities/app_user_entity.dart';
import 'group_message_entity.dart';

class GroupDetailEntity extends Equatable {
  final String id;
  final String name;
  final List<AppUserEntity> members;
  final List<GroupMessageEntity> messages;

  const GroupDetailEntity({
    required this.id,
    required this.name,
    required this.members,
    required this.messages,
  });

  @override
  List<Object?> get props => [id, name, members, messages];
}
