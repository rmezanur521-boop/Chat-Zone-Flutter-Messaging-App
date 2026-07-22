import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/groups_remote_datasource.dart';
import '../../data/repositories/groups_repository_impl.dart';
import '../../domain/entities/group_preview_entity.dart';
import '../../domain/repositories/groups_repository.dart';

import '../../../messages/presentation/providers/messages_providers.dart'
    show signalRClientProvider;
import 'group_chat_notifier.dart';
import 'group_chat_state.dart';

final groupsRemoteDataSourceProvider = Provider<GroupsRemoteDataSource>((ref) {
  return GroupsRemoteDataSource(ref.watch(apiClientProvider));
});

final groupsRepositoryProvider = Provider<GroupsRepository>((ref) {
  return GroupsRepositoryImpl(ref.watch(groupsRemoteDataSourceProvider));
});

class GroupPreviewsNotifier
    extends StateNotifier<AsyncValue<List<GroupPreviewEntity>>> {
  final Ref _ref;
  GroupPreviewsNotifier(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final previews = await _ref.read(groupsRepositoryProvider).getPreviews();
      state = AsyncValue.data(previews);
    } on Failure catch (f, st) {
      state = AsyncValue.error(f.message, st);
    }
  }
}

final groupPreviewsProvider = StateNotifierProvider<GroupPreviewsNotifier,
    AsyncValue<List<GroupPreviewEntity>>>((ref) {
  return GroupPreviewsNotifier(ref);
});

final groupChatNotifierProvider =
    StateNotifierProvider.family<GroupChatNotifier, GroupChatState, String>(
        (ref, groupId) {
  return GroupChatNotifier(
    repository: ref.watch(groupsRepositoryProvider),
    socket: ref.watch(signalRClientProvider),
    groupId: groupId,
  );
});
