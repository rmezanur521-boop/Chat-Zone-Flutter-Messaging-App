import '../entities/user_entity.dart';

/// Contract for authentication operations. Implemented in the data layer.
abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);

  Future<UserEntity> register(
      String firstName, String lastName, String email, String password);

  Future<UserEntity?> getCurrentUser();

  Future<void> logout();
}
