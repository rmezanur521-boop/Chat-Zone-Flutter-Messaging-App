import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/friends/presentation/pages/friend_details_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/messages/presentation/pages/chat_page.dart';
import '../../features/profile/presentation/pages/other_user_profile_page.dart';

class AppRoutes {
  AppRoutes._();
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const chat = '/chat';
  static const otherProfile = '/user';
  static const friendDetails = '/friend';
}

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authNotifierProvider.select((s) => s.status), (_, __) {
      notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authStatus = ref.read(authNotifierProvider).status;
      final path = state.matchedLocation;

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
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
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
      GoRoute(
        path: '${AppRoutes.friendDetails}/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          final extra = state.extra as Map<String, dynamic>?;
          final isFriend = extra?['isFriend'] as bool? ?? false;
          return FriendDetailsPage(
            userId: userId,
            isFriend: isFriend,
          );
        },
      ),
    ],
  );
});
