import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  AuthNotifier(this._repository) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);
    final user = await _repository.getCurrentUser();
    state = state.copyWith(status: AuthStatus.authenticated, user: user);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repository.login(email, password);
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
      return true;
    } on Failure catch (f) {
      state = state.copyWith(
          status: AuthStatus.unauthenticated, errorMessage: f.message);
      return false;
    }
  }

  Future<bool> register(String userName, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repository.register(userName, email, password);
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
      return true;
    } on Failure catch (f) {
      state = state.copyWith(
          status: AuthStatus.unauthenticated, errorMessage: f.message);
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
