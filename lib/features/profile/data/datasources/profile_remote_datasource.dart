import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  final ApiClient _client;
  ProfileRemoteDataSource(this._client);

  Future<ProfileModel> getMyProfile() async {
    final json = await _client.get(ApiConstants.myProfile);
    return ProfileModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<ProfileModel> getUserProfile(String userId) async {
    final json = await _client.get(ApiConstants.userProfile(userId));
    return ProfileModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<ProfileModel> updateProfile(
      {required String userName, String? bio}) async {
    final json = await _client.put(
      ApiConstants.updateProfile,
      body: {'userName': userName, if (bio != null) 'bio': bio},
    );
    return ProfileModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<String> uploadProfilePicture(String filePath) async {
    final json = await _client.uploadFile(
      ApiConstants.uploadProfilePicture,
      fieldName: 'file',
      filePath: filePath,
    );
    final data = json['data'] as Map<String, dynamic>?;
    return data?['profilePictureUrl']?.toString() ??
        data?['avatarUrl']?.toString() ??
        '';
  }
}
