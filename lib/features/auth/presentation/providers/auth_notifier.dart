import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  AuthNotifier(this._repository) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (_) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
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

  Future<bool> register(
      String firstName, String lastName, String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user =
          await _repository.register(firstName, lastName, email, password);
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
