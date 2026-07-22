import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/entities/friend_request_entity.dart';
import '../../domain/repositories/friends_repository.dart';
import '../datasources/friends_remote_datasource.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsRemoteDataSource _remote;
  FriendsRepositoryImpl(this._remote);

  @override
  Future<List<AppUserEntity>> getFriends() async {
    try {
      return await _remote.getFriends();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<List<FriendRequestEntity>> getRequests() async {
    try {
      return await _remote.getRequests();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<List<AppUserEntity>> searchUsers(String query) async {
    try {
      return await _remote.searchUsers(query);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> sendRequest(String receiverId) async {
    try {
      await _remote.sendRequest(receiverId);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> acceptRequest(String requestId) async {
    try {
      await _remote.acceptRequest(requestId);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    try {
      await _remote.rejectRequest(requestId);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> removeFriend(String friendId) async {
    try {
      await _remote.removeFriend(friendId);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }
}
