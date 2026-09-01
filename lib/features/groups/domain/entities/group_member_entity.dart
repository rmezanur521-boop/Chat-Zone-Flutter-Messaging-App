import 'package:equatable/equatable.dart';

class GroupMemberEntity extends Equatable {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final bool isAdmin;

  const GroupMemberEntity({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    this.isAdmin = false,
  });

  @override
  List<Object?> get props => [id, fullName, avatarUrl, isAdmin];
}
