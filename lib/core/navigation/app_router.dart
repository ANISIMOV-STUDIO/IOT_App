/// App Router Configuration
///
/// GoRouter-based navigation for the dashboard
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/auth/auth_screen.dart';
import '../../presentation/screens/auth/verify_email_screen.dart';
import '../../presentation/bloc/dashboard/dashboard_bloc.dart';
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

/// Экспортируем для использования в navigation без context
GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

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

      final isGoingToAuth = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      // Если не авторизован и пытается зайти на защищенную страницу
      if (!isAuthenticated && !isGoingToAuth && state.matchedLocation != AppRoutes.verifyEmail) {
        return AppRoutes.login;
      }

      // Если авторизован и пытается зайти на страницы auth (но не verifyEmail)
      if (isAuthenticated && isGoingToAuth) {
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
        builder: (context, state) => const AuthScreen(
          key: ValueKey('login'),
          isRegister: false,
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const AuthScreen(
          key: ValueKey('register'),
          isRegister: true,
        ),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final password = state.extra as String? ?? '';
          return VerifyEmailScreen(
            email: email,
            password: password,
          );
        },
      ),

      // Protected routes
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<DashboardBloc>()..add(const DashboardStarted()),
          child: const DashboardScreen(),
        ),
      ),
    ],
  );
}

/// GoRouter extensions for easier navigation
extension GoRouterExtensions on BuildContext {
  void goToHome() => go(AppRoutes.home);
  void goToLogin() => go(AppRoutes.login);
  void goToRegister() => go(AppRoutes.register);
  void goToVerifyEmail(String email, {String? password}) =>
      go('${AppRoutes.verifyEmail}?email=$email', extra: password);
}
