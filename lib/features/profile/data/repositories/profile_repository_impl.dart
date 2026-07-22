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
  Future<ProfileEntity> updateProfile(
      {required String userName, String? bio}) async {
    try {
      return await _remote.updateProfile(userName: userName, bio: bio);
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
