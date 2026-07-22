import 'package:equatable/equatable.dart';
import '../../../friends/domain/entities/app_user_entity.dart';
import '../../domain/entities/group_message_entity.dart';

class GroupChatState extends Equatable {
  final String groupName;
  final List<AppUserEntity> members;
  final List<GroupMessageEntity> messages;
  final bool isLoading;
  final bool isSending;
  final String? errorMessage;

  const GroupChatState({
    this.groupName = '',
    this.members = const [],
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.errorMessage,
  });

  GroupChatState copyWith({
    String? groupName,
    List<AppUserEntity>? members,
    List<GroupMessageEntity>? messages,
    bool? isLoading,
    bool? isSending,
    String? errorMessage,
  }) {
    return GroupChatState(
      groupName: groupName ?? this.groupName,
      members: members ?? this.members,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [groupName, members, messages, isLoading, isSending, errorMessage];
}
