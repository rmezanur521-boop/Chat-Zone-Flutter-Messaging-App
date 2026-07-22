import '../../../../core/error/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl(this._remote, this._secureStorage);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final response = await _remote.login(email, password);
      await _secureStorage.saveSession(
        token: response.token,
        userId: response.user.id,
        userName: response.user.userName,
        email: response.user.email,
      );
      return response.user;
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<UserEntity> register(
      String userName, String email, String password) async {
    try {
      await _remote.register(userName, email, password);
      // Register endpoint doesn't return a token per the docs,
      // so we log in right after a successful signup.
      return await login(email, password);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final hasSession = await _secureStorage.hasValidSession();
    if (!hasSession) return null;
    try {
      return await _remote.getMe();
    } catch (_) {
      await _secureStorage.clearSession();
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.clearSession();
  }
}
