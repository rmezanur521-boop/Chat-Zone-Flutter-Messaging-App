import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getMyProfile();
  Future<ProfileEntity> getUserProfile(String userId);
  Future<ProfileEntity> updateProfile({required String userName, String? bio});
  Future<String> uploadProfilePicture(String filePath);
}
