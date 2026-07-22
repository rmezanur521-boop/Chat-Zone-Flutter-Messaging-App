class ApiConstants {
  ApiConstants._();

  // ⚠️ Change this to your deployed backend URL for production.
  // For Android Emulator use: https://10.0.2.2:7001
  // For iOS Simulator / physical device on same network, use your machine's IP.
  static const String baseUrl = 'https://192.168.88.5:7001';
  static const String apiUrl = '$baseUrl/api';
  static const String hubUrl = '$baseUrl/chatHub';

  // Auth
  static const String login = '$apiUrl/auth/login';
  static const String register = '$apiUrl/auth/register';
  static const String me = '$apiUrl/auth/me';

  // Messages
  static const String messagePreviews = '$apiUrl/messages/previews';
  static String conversation(String userId) =>
      '$apiUrl/messages/conversation/$userId';
  static const String sendMessage = '$apiUrl/messages/send';
  static String editMessage(String messageId) =>
      '$apiUrl/messages/edit/$messageId';
  static String deleteMessage(String messageId) =>
      '$apiUrl/messages/delete/$messageId';

  // Friends
  static const String friends = '$apiUrl/friends';
  static const String friendRequests = '$apiUrl/friends/requests';
  static String searchUsers(String query) =>
      '$apiUrl/friends/search?query=$query';
  static String sendFriendRequest(String receiverId) =>
      '$apiUrl/friends/request/$receiverId';
  static String acceptFriendRequest(String requestId) =>
      '$apiUrl/friends/accept/$requestId';
  static String rejectFriendRequest(String requestId) =>
      '$apiUrl/friends/reject/$requestId';
  static String removeFriend(String friendId) =>
      '$apiUrl/friends/remove/$friendId';

  // Groups
  static const String groupPreviews = '$apiUrl/groups/previews';
  static String groupDetail(String groupId) => '$apiUrl/groups/$groupId';
  static const String createGroup = '$apiUrl/groups/create';
  static String sendGroupMessage(String groupId) =>
      '$apiUrl/groups/$groupId/messages/send';
  static String editGroupMessage(String groupId, String msgId) =>
      '$apiUrl/groups/$groupId/messages/edit/$msgId';
  static String deleteGroupMessage(String groupId, String msgId) =>
      '$apiUrl/groups/$groupId/messages/delete/$msgId';
  static String addGroupMember(String groupId, String userId) =>
      '$apiUrl/groups/$groupId/members/add/$userId';
  static String removeGroupMember(String groupId, String userId) =>
      '$apiUrl/groups/$groupId/members/remove/$userId';

  // Profile
  static const String myProfile = '$apiUrl/profile';
  static String userProfile(String userId) => '$apiUrl/profile/$userId';
  static const String updateProfile = '$apiUrl/profile/update';
  static const String uploadProfilePicture = '$apiUrl/profile/picture';
}
