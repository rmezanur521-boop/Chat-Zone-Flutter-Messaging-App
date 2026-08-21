import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getMyProfile();
  Future<ProfileEntity> getUserProfile(String userId);
  Future<ProfileEntity> updateProfile({
    required String firstName,
    required String lastName,
    String? bio,
    String? gender,
    DateTime? dateOfBirth,
  });
  Future<String> uploadProfilePicture(String filePath);
}
