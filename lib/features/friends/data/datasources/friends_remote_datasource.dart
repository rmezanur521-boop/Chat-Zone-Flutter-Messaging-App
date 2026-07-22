import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/app_user_model.dart';
import '../models/friend_request_model.dart';

class FriendsRemoteDataSource {
  final ApiClient _client;
  FriendsRemoteDataSource(this._client);

  Future<List<AppUserModel>> getFriends() async {
    final json = await _client.get(ApiConstants.friends);
    final list = json['data'] as List? ?? [];
    return list
        .map((e) => AppUserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FriendRequestModel>> getRequests() async {
    final json = await _client.get(ApiConstants.friendRequests);
    final list = json['data'] as List? ?? [];
    return list
        .map((e) => FriendRequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<AppUserModel>> searchUsers(String query) async {
    final json = await _client.get(ApiConstants.searchUsers(query));
    final list = json['data'] as List? ?? [];
    return list
        .map((e) => AppUserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> sendRequest(String receiverId) async {
    await _client.post(ApiConstants.sendFriendRequest(receiverId));
  }

  Future<void> acceptRequest(String requestId) async {
    await _client.put(ApiConstants.acceptFriendRequest(requestId));
  }

  Future<void> rejectRequest(String requestId) async {
    await _client.put(ApiConstants.rejectFriendRequest(requestId));
  }

  Future<void> removeFriend(String friendId) async {
    await _client.delete(ApiConstants.removeFriend(friendId));
  }
}
