import '../providers/auth_state.dart';

extension AuthStateX on AuthState {
  bool get isLoading => status == AuthStatus.loading;
}
