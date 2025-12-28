/// App Router Configuration
///
/// GoRouter-based navigation for the dashboard
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/verify_email_screen.dart';
import '../../core/services/auth_storage_service.dart';
import '../../core/di/injection_container.dart' as di;

/// App route names
class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
}

/// Global router configuration
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// Creates the GoRouter instance
GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.login,

    // Route guard - проверка авторизации
    redirect: (context, state) async {
      final authStorage = di.sl<AuthStorageService>();
      final isAuthenticated = await authStorage.hasToken();
      final isSkipped = await authStorage.hasSkipped();

      final isGoingToAuth = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.verifyEmail;

      // Если не авторизован и не пропущено и пытается зайти на защищенную страницу
      if (!isAuthenticated && !isSkipped && !isGoingToAuth) {
        return AppRoutes.login;
      }

      // Если авторизован или пропущено и пытается зайти на страницы auth
      if ((isAuthenticated || isSkipped) && isGoingToAuth) {
        return AppRoutes.home;
      }

      return null; // Продолжить навигацию
    },

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found: ${state.matchedLocation}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),

    routes: [
      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return VerifyEmailScreen(email: email);
        },
      ),

      // Protected routes
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}

/// GoRouter extensions for easier navigation
extension GoRouterExtensions on BuildContext {
  void goToHome() => go(AppRoutes.home);
  void goToLogin() => go(AppRoutes.login);
  void goToRegister() => go(AppRoutes.register);
  void goToVerifyEmail(String email) =>
      go('${AppRoutes.verifyEmail}?email=$email');
}
