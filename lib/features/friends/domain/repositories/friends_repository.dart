import '../entities/app_user_entity.dart';
import '../entities/friend_request_entity.dart';

abstract class FriendsRepository {
  Future<List<AppUserEntity>> getFriends();
  Future<List<FriendRequestEntity>> getRequests();
  Future<List<AppUserEntity>> searchUsers(String query);
  Future<void> sendRequest(String receiverId);
  Future<void> acceptRequest(String requestId);
  Future<void> rejectRequest(String requestId);
  Future<void> removeFriend(String friendId);
}
