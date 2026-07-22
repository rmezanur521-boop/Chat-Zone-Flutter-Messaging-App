import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/friends_remote_datasource.dart';
import '../../data/repositories/friends_repository_impl.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/entities/friend_request_entity.dart';
import '../../domain/repositories/friends_repository.dart';

final friendsRemoteDataSourceProvider =
    Provider<FriendsRemoteDataSource>((ref) {
  return FriendsRemoteDataSource(ref.watch(apiClientProvider));
});

final friendsRepositoryProvider = Provider<FriendsRepository>((ref) {
  return FriendsRepositoryImpl(ref.watch(friendsRemoteDataSourceProvider));
});

// --- Friends list ---
class FriendsListNotifier
    extends StateNotifier<AsyncValue<List<AppUserEntity>>> {
  final Ref _ref;
  FriendsListNotifier(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final friends = await _ref.read(friendsRepositoryProvider).getFriends();
      state = AsyncValue.data(friends);
    } on Failure catch (f, st) {
      state = AsyncValue.error(f.message, st);
    }
  }

  Future<void> removeFriend(String friendId) async {
    await _ref.read(friendsRepositoryProvider).removeFriend(friendId);
    await load();
  }
}

final friendsListProvider =
    StateNotifierProvider<FriendsListNotifier, AsyncValue<List<AppUserEntity>>>(
        (ref) {
  return FriendsListNotifier(ref);
});

// --- Friend requests ---
class FriendRequestsNotifier
    extends StateNotifier<AsyncValue<List<FriendRequestEntity>>> {
  final Ref _ref;
  FriendRequestsNotifier(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final requests = await _ref.read(friendsRepositoryProvider).getRequests();
      state = AsyncValue.data(requests);
    } on Failure catch (f, st) {
      state = AsyncValue.error(f.message, st);
    }
  }

  Future<void> accept(String requestId) async {
    await _ref.read(friendsRepositoryProvider).acceptRequest(requestId);
    await load();
    _ref.read(friendsListProvider.notifier).load();
  }

  Future<void> reject(String requestId) async {
    await _ref.read(friendsRepositoryProvider).rejectRequest(requestId);
    await load();
  }
}

final friendRequestsProvider = StateNotifierProvider<FriendRequestsNotifier,
    AsyncValue<List<FriendRequestEntity>>>((ref) {
  return FriendRequestsNotifier(ref);
});

// --- Search ---
class UserSearchNotifier
    extends StateNotifier<AsyncValue<List<AppUserEntity>>> {
  final Ref _ref;
  UserSearchNotifier(this._ref) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final results =
          await _ref.read(friendsRepositoryProvider).searchUsers(query.trim());
      state = AsyncValue.data(results);
    } on Failure catch (f, st) {
      state = AsyncValue.error(f.message, st);
    }
  }

  Future<void> sendRequest(String userId) async {
    await _ref.read(friendsRepositoryProvider).sendRequest(userId);
  }
}

final userSearchProvider =
    StateNotifierProvider<UserSearchNotifier, AsyncValue<List<AppUserEntity>>>(
        (ref) {
  return UserSearchNotifier(ref);
});
