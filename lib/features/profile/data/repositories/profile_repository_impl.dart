import '../../../../core/error/failures.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remote;
  ProfileRepositoryImpl(this._remote);

  @override
  Future<ProfileEntity> getMyProfile() async {
    try {
      return await _remote.getMyProfile();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<ProfileEntity> getUserProfile(String userId) async {
    try {
      return await _remote.getUserProfile(userId);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<ProfileEntity> updateProfile({
    required String firstName,
    required String lastName,
    String? bio,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    try {
      return await _remote.updateProfile(
        firstName: firstName,
        lastName: lastName,
        bio: bio,
        gender: gender,
        dateOfBirth: dateOfBirth,
      );
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<String> uploadProfilePicture(String filePath) async {
    try {
      return await _remote.uploadProfilePicture(filePath);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }
}
