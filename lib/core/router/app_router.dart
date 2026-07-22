import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/providers/auth_state.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/messages/presentation/pages/chat_page.dart';
import '../../features/profile/presentation/pages/other_profile_page.dart';

class AppRoutes {
  AppRoutes._();
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const chat = '/chat';
  static const otherProfile = '/user';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authNotifierProvider.select((s) => s.status));

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final path = state.matchedLocation;

      // Splash handles its own navigation after checking the session.
      if (path == AppRoutes.splash) return null;

      final isAuthRoute = path == AppRoutes.login || path == AppRoutes.register;

      if (authStatus == AuthStatus.unauthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }
      if (authStatus == AuthStatus.authenticated && isAuthRoute) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashPage()),
      GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginPage()),
      GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterPage()),
      GoRoute(
          path: AppRoutes.home, builder: (context, state) => const HomePage()),
      GoRoute(
        path: '${AppRoutes.chat}/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          final extra = state.extra as Map<String, dynamic>?;
          return ChatPage(
            otherUserId: userId,
            otherUserName: extra?['userName'] as String? ?? 'Chat',
            otherUserAvatar: extra?['avatarUrl'] as String?,
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.otherProfile}/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return OtherProfilePage(userId: userId);
        },
      ),
    ],
  );
});
