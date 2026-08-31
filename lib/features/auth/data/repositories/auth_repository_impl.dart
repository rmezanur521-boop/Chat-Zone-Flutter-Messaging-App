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
        refreshToken: response.refreshToken,
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
      String firstName, String lastName, String email, String password) async {
    try {
      final response =
          await _remote.register(firstName, lastName, email, password);
      await _secureStorage.saveSession(
        token: response.token,
        refreshToken: response.refreshToken,
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
    final refreshToken = await _secureStorage.getRefreshToken();
    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await _remote.logout(refreshToken);
      } catch (_) {
        // Server call failed (offline, already revoked, etc.) — local
        // session is cleared below regardless so the user can still log out.
      }
    }
    await _secureStorage.clearSession();
  }
}
