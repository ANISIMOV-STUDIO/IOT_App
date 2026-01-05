/// App Router Configuration
///
/// GoRouter с правильным auth flow:
/// - refreshListenable слушает AuthBloc.stream
/// - redirect проверяет AuthBloc.state (не storage напрямую)
/// - Никаких side effects в builder
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/main_screen.dart';
import '../../presentation/screens/auth/auth_screen.dart';
import '../../presentation/screens/auth/verify_email_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/notifications/notifications_screen.dart';
import '../../presentation/screens/schedule/schedule_screen.dart';
import '../../presentation/screens/alarms/alarm_history_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/auth/auth_state.dart';
import 'router_refresh_stream.dart';

/// Названия маршрутов
class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String notifications = '/notifications';
  static const String schedule = '/schedule';
  static const String alarmHistory = '/alarm-history';
}

/// Global navigator key
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// Экспортируем для использования в navigation без context
GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

/// Создаёт GoRouter с правильным auth flow
///
/// Требует AuthBloc для:
/// - refreshListenable: перепроверяет routes при изменении auth state
/// - redirect: решает куда направить пользователя
GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,

    // Начинаем со splash - пока AuthBloc не определит состояние
    initialLocation: AppRoutes.splash,

    // Автоматически перепроверяем routes при изменении auth state
    refreshListenable: RouterRefreshStream(authBloc.stream),

    // Централизованная логика навигации
    redirect: (context, state) {
      final authState = authBloc.state;
      final currentPath = state.matchedLocation;

      // 1. Если AuthBloc ещё загружается - показываем splash
      if (authState is AuthInitial || authState is AuthLoading) {
        // Разрешаем оставаться на splash или переходить на verify-email
        if (currentPath == AppRoutes.splash ||
            currentPath == AppRoutes.verifyEmail) {
          return null;
        }
        return AppRoutes.splash;
      }

      // 2. Если пользователь НЕ авторизован
      if (authState is AuthUnauthenticated || authState is AuthError) {
        // Разрешаем: login, register, verify-email, forgot-password
        final allowedPaths = [
          AppRoutes.login,
          AppRoutes.register,
          AppRoutes.verifyEmail,
          AppRoutes.forgotPassword,
        ];
        if (allowedPaths.contains(currentPath)) {
          return null;
        }
        return AppRoutes.login;
      }

      // 3. Если пользователь зарегистрировался - нужно подтвердить email
      if (authState is AuthRegistered) {
        if (currentPath == AppRoutes.verifyEmail) {
          return null;
        }
        return '${AppRoutes.verifyEmail}?email=${authState.email}';
      }

      // 4. Если пользователь авторизован
      if (authState is AuthAuthenticated) {
        // Не пускаем на auth страницы
        final authPaths = [
          AppRoutes.splash,
          AppRoutes.login,
          AppRoutes.register,
        ];
        if (authPaths.contains(currentPath)) {
          return AppRoutes.home;
        }
        return null;
      }

      // 5. Email подтверждён - редирект на login
      if (authState is AuthEmailVerified) {
        return AppRoutes.login;
      }

      return null;
    },

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Страница не найдена: ${state.matchedLocation}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    ),

    routes: [
      // Splash - показывается пока проверяется auth
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

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
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'];
          return ForgotPasswordScreen(initialEmail: email);
        },
      ),

      // Protected routes - пользователь уже авторизован (проверено в redirect)
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainScreen(),
      ),

      // Notifications
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Schedule
      GoRoute(
        path: AppRoutes.schedule,
        builder: (context, state) {
          final deviceId = state.uri.queryParameters['deviceId'] ?? '';
          final deviceName = state.uri.queryParameters['deviceName'] ?? 'Устройство';
          return ScheduleScreen(
            deviceId: deviceId,
            deviceName: deviceName,
          );
        },
      ),

      // Alarm History
      GoRoute(
        path: AppRoutes.alarmHistory,
        builder: (context, state) {
          final deviceId = state.uri.queryParameters['deviceId'] ?? '';
          final deviceName = state.uri.queryParameters['deviceName'] ?? 'Устройство';
          return AlarmHistoryScreen(
            deviceId: deviceId,
            deviceName: deviceName,
          );
        },
      ),
    ],
  );
}

/// Расширения для удобной навигации
extension GoRouterExtensions on BuildContext {
  void goToHome() => go(AppRoutes.home);
  void goToLogin() => go(AppRoutes.login);
  void goToRegister() => go(AppRoutes.register);
  void goToNotifications() => go(AppRoutes.notifications);
  void goToVerifyEmail(String email, {String? password}) =>
      go('${AppRoutes.verifyEmail}?email=$email', extra: password);
  void goToSchedule(String deviceId, String deviceName) =>
      go('${AppRoutes.schedule}?deviceId=$deviceId&deviceName=${Uri.encodeComponent(deviceName)}');
  void goToAlarmHistory(String deviceId, String deviceName) =>
      go('${AppRoutes.alarmHistory}?deviceId=$deviceId&deviceName=${Uri.encodeComponent(deviceName)}');
}
