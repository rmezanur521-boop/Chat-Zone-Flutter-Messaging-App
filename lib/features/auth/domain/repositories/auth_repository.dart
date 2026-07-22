import '../entities/user_entity.dart';

/// Contract for authentication operations. Implemented in the data layer.
abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<UserEntity> getCurrentUser();

  Future<void> logout();
}
