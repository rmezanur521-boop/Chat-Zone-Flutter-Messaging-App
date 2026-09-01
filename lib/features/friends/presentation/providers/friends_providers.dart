import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/friends_remote_datasource.dart';
import '../../data/repositories/friends_repository_impl.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/entities/friend_request_entity.dart';
import '../../domain/entities/outgoing_friend_request_entity.dart';
import '../../domain/repositories/friends_repository.dart';

final friendsRemoteDataSourceProvider =
    Provider<FriendsRemoteDataSource>((ref) {
  return FriendsRemoteDataSource(ref.watch(apiClientProvider));
});

final friendsRepositoryProvider = Provider<FriendsRepository>((ref) {
  return FriendsRepositoryImpl(ref.watch(friendsRemoteDataSourceProvider));
});

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

class FriendDetailsNotifier extends StateNotifier<AsyncValue<AppUserEntity>> {
  final Ref _ref;
  final String userId;

  FriendDetailsNotifier(this._ref, this.userId)
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final user =
          await _ref.read(friendsRepositoryProvider).getUserProfile(userId);
      state = AsyncValue.data(user);
    } on Failure catch (f, st) {
      state = AsyncValue.error(f.message, st);
    }
  }
}

final friendDetailsProvider = StateNotifierProvider.family<
    FriendDetailsNotifier, AsyncValue<AppUserEntity>, String>(
  (ref, userId) => FriendDetailsNotifier(ref, userId),
);

class RequestStatusNotifier
    extends StateNotifier<AsyncValue<OutgoingFriendRequestEntity?>> {
  final Ref _ref;
  final String userId;

  RequestStatusNotifier(this._ref, this.userId)
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final status =
          await _ref.read(friendsRepositoryProvider).checkRequestStatus(userId);
      state = AsyncValue.data(status);
    } on Failure catch (f, st) {
      state = AsyncValue.error(f.message, st);
    }
  }

  Future<void> sendRequest() async {
    try {
      await _ref.read(friendsRepositoryProvider).sendRequest(userId);
      final status =
          OutgoingFriendRequestEntity(userId: userId, status: 'pending');
      state = AsyncValue.data(status);
    } on Failure catch (f, st) {
      state = AsyncValue.error(f.message, st);
    }
  }
}

final requestStatusProvider = StateNotifierProvider.family<
    RequestStatusNotifier,
    AsyncValue<OutgoingFriendRequestEntity?>,
    String>((ref, userId) => RequestStatusNotifier(ref, userId));

class SuggestedFriendsNotifier
    extends StateNotifier<AsyncValue<List<AppUserEntity>>> {
  final Ref _ref;

  SuggestedFriendsNotifier(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final suggested =
          await _ref.read(friendsRepositoryProvider).getSuggestedFriends();
      state = AsyncValue.data(suggested);
    } on Failure catch (f, st) {
      state = AsyncValue.error(f.message, st);
    }
  }
}

final suggestedFriendsProvider = StateNotifierProvider<SuggestedFriendsNotifier,
    AsyncValue<List<AppUserEntity>>>((ref) {
  return SuggestedFriendsNotifier(ref);
});

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

      final friends = await _ref.read(friendsRepositoryProvider).getFriends();
      final friendIds = friends.map((f) => f.id).toSet();

      final filtered =
          results.where((user) => !friendIds.contains(user.id)).toList();
      state = AsyncValue.data(filtered);
    } on Failure catch (f, st) {
      state = AsyncValue.error(f.message, st);
    }
  }

  Future<void> sendRequest(String userId) async {
    try {
      await _ref.read(friendsRepositoryProvider).sendRequest(userId);
    } on Failure catch (f, st) {
      state = AsyncValue.error(f.message, st);
    }
  }
}

final userSearchProvider =
    StateNotifierProvider<UserSearchNotifier, AsyncValue<List<AppUserEntity>>>(
        (ref) {
  return UserSearchNotifier(ref);
});
