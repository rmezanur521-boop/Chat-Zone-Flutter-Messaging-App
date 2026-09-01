import '../../domain/entities/app_user_entity.dart';
import '../../domain/entities/friend_request_entity.dart';
import '../../domain/entities/outgoing_friend_request_entity.dart';
import '../../domain/repositories/friends_repository.dart';
import '../datasources/friends_remote_datasource.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsRemoteDataSource _remoteDataSource;

  FriendsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<AppUserEntity>> getFriends() => _remoteDataSource.getFriends();

  @override
  Future<List<FriendRequestEntity>> getRequests() =>
      _remoteDataSource.getRequests();

  @override
  Future<List<AppUserEntity>> searchUsers(String query) =>
      _remoteDataSource.searchUsers(query);

  @override
  Future<AppUserEntity> getUserProfile(String userId) =>
      _remoteDataSource.getUserProfile(userId);

  @override
  Future<List<AppUserEntity>> getSuggestedFriends() =>
      _remoteDataSource.getSuggestedFriends();

  @override
  Future<OutgoingFriendRequestEntity?> checkRequestStatus(String userId) =>
      _remoteDataSource.checkRequestStatus(userId);

  @override
  Future<void> sendRequest(String userId) =>
      _remoteDataSource.sendRequest(userId);

  @override
  Future<void> acceptRequest(String requestId) =>
      _remoteDataSource.acceptRequest(requestId);

  @override
  Future<void> rejectRequest(String requestId) =>
      _remoteDataSource.rejectRequest(requestId);

  @override
  Future<void> removeFriend(String friendId) =>
      _remoteDataSource.removeFriend(friendId);
}
