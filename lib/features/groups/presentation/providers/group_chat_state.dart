import 'package:equatable/equatable.dart';
import '../../domain/entities/group_member_entity.dart';
import '../../domain/entities/group_message_entity.dart';

class GroupChatState extends Equatable {
  final String groupName;
  final bool currentUserIsAdmin;
  final List<GroupMemberEntity> members;
  final List<GroupMessageEntity> messages;
  final bool isLoading;
  final bool isSending;
  final bool groupDeleted;
  final String? errorMessage;

  const GroupChatState({
    this.groupName = '',
    this.currentUserIsAdmin = false,
    this.members = const [],
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.groupDeleted = false,
    this.errorMessage,
  });

  GroupChatState copyWith({
    String? groupName,
    bool? currentUserIsAdmin,
    List<GroupMemberEntity>? members,
    List<GroupMessageEntity>? messages,
    bool? isLoading,
    bool? isSending,
    bool? groupDeleted,
    String? errorMessage,
  }) {
    return GroupChatState(
      groupName: groupName ?? this.groupName,
      currentUserIsAdmin: currentUserIsAdmin ?? this.currentUserIsAdmin,
      members: members ?? this.members,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      groupDeleted: groupDeleted ?? this.groupDeleted,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        groupName,
        currentUserIsAdmin,
        members,
        messages,
        isLoading,
        isSending,
        groupDeleted,
        errorMessage,
      ];
}
