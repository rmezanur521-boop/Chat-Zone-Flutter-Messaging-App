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

  Future<ProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    String? bio,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    final json = await _client.put(
      ApiConstants.updateProfile,
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'bio': bio,
        'gender': gender,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth.toIso8601String(),
      },
    );
    return ProfileModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<String> uploadProfilePicture(List<int> bytes, String fileName) async {
    final json = await _client.uploadFile(
      ApiConstants.uploadProfilePicture,
      fieldName: 'file',
      bytes: bytes,
      fileName: fileName,
    );
    final data = json['data'] as Map<String, dynamic>?;
    return data?['profilePicture']?.toString() ?? '';
  }
}
