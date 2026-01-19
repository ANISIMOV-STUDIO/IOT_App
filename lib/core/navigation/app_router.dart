/// App Router Configuration
///
/// GoRouter с правильным auth flow:
/// - refreshListenable слушает AuthBloc.stream
/// - redirect проверяет AuthBloc.state (не storage напрямую)
/// - Поддержка deep links через кастомную схему и Universal Links
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hvac_control/core/navigation/app_routes.dart';
import 'package:hvac_control/core/navigation/router_refresh_stream.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_bloc.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_state.dart';
import 'package:hvac_control/presentation/screens/alarms/alarm_history_screen.dart';
import 'package:hvac_control/presentation/screens/auth/auth_screen.dart';
import 'package:hvac_control/presentation/screens/auth/forgot_password_screen.dart';
import 'package:hvac_control/presentation/screens/auth/verify_email_screen.dart';
import 'package:hvac_control/presentation/screens/main_screen.dart';
import 'package:hvac_control/presentation/screens/notifications/notifications_screen.dart';
import 'package:hvac_control/presentation/screens/profile/event_logs_screen.dart';
import 'package:hvac_control/presentation/screens/profile/profile_screen.dart';
import 'package:hvac_control/presentation/screens/schedule/schedule_screen.dart';
import 'package:hvac_control/presentation/screens/splash/splash_screen.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

// Реэкспорт для обратной совместимости
export 'app_routes.dart';

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
GoRouter createRouter(AuthBloc authBloc) => GoRouter(
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
        return AppPaths.verifyEmail(authState.email);
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
            const SizedBox(height: AppSpacing.md),
            Text('Страница не найдена: ${state.matchedLocation}'),
            const SizedBox(height: AppSpacing.lgx),
            BreezButton(
              onTap: () => context.go(AppRoutes.home),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    ),

    routes: [
      // ============ Splash ============
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // ============ Auth Routes ============
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const AuthScreen(
          key: ValueKey('login'),
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
          final email = state.uri.queryParameters[RouteParams.email] ?? '';
          return VerifyEmailScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) {
          final email = state.uri.queryParameters[RouteParams.email];
          return ForgotPasswordScreen(initialEmail: email);
        },
      ),

      // ============ Main App ============
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          final tabName = state.uri.queryParameters['tab'];
          final tab = MainTab.fromName(tabName);
          return MainScreen(initialTab: tab?.tabIndex);
        },
      ),

      // ============ Notifications ============
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // ============ Profile ============
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),

      // ============ Service Routes ============
      GoRoute(
        path: AppRoutes.eventLogs,
        builder: (context, state) => const EventLogsScreen(),
      ),

      // ============ Device Routes ============
      // /device/:deviceId - редирект на главную (TODO: выбрать устройство)
      GoRoute(
        path: '/device/:${RouteParams.deviceId}',
        redirect: (context, state) => AppRoutes.home,
        routes: [
          // /device/:deviceId/schedule
          GoRoute(
            path: 'schedule',
            builder: (context, state) {
              final deviceId = state.pathParameters[RouteParams.deviceId] ?? '';
              final deviceName = state.uri.queryParameters[RouteParams.deviceName] ?? 'Устройство';
              return ScheduleScreen(
                deviceId: deviceId,
                deviceName: deviceName,
              );
            },
          ),
          // /device/:deviceId/analytics - редирект на главную аналитику
          GoRoute(
            path: 'analytics',
            redirect: (context, state) => AppRoutes.home,
          ),
          // /device/:deviceId/alarms
          GoRoute(
            path: 'alarms',
            builder: (context, state) {
              final deviceId = state.pathParameters[RouteParams.deviceId] ?? '';
              final deviceName = state.uri.queryParameters[RouteParams.deviceName] ?? 'Устройство';
              return AlarmHistoryScreen(
                deviceId: deviceId,
                deviceName: deviceName,
              );
            },
          ),
        ],
      ),

      // ============ Legacy Routes (обратная совместимость) ============
      GoRoute(
        path: AppRoutes.schedule,
        builder: (context, state) {
          final deviceId = state.uri.queryParameters[RouteParams.deviceId] ?? '';
          final deviceName = state.uri.queryParameters[RouteParams.deviceName] ?? 'Устройство';
          return ScheduleScreen(
            deviceId: deviceId,
            deviceName: deviceName,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.alarmHistory,
        builder: (context, state) {
          final deviceId = state.uri.queryParameters[RouteParams.deviceId] ?? '';
          final deviceName = state.uri.queryParameters[RouteParams.deviceName] ?? 'Устройство';
          return AlarmHistoryScreen(
            deviceId: deviceId,
            deviceName: deviceName,
          );
        },
      ),
    ],
  );

/// Расширения для удобной навигации
extension GoRouterNavigation on BuildContext {
  // ============ Auth Navigation ============
  void goToHome() => go(AppRoutes.home);
  void goToLogin() => go(AppRoutes.login);
  void goToRegister() => go(AppRoutes.register);
  void goToVerifyEmail(String email) => go(AppPaths.verifyEmail(email));
  void goToForgotPassword({String? email}) =>
      go(AppPaths.forgotPassword(email: email));

  // ============ Main Navigation ============
  void goToNotifications() => go(AppRoutes.notifications);
  void goToProfile() => go(AppRoutes.profile);
  void goToHomeTab(MainTab tab) => go('${AppRoutes.home}?tab=${tab.name}');
  void goToEventLogs() => go(AppRoutes.eventLogs);

  // ============ Device Navigation ============
  void goToDevice(String deviceId, {String? deviceName}) {
    final path = AppPaths.device(deviceId);
    final query = deviceName != null
        ? '?${RouteParams.deviceName}=${Uri.encodeComponent(deviceName)}'
        : '';
    go('$path$query');
  }

  void goToDeviceSchedule(String deviceId, {String? deviceName}) {
    final path = AppPaths.deviceSchedule(deviceId);
    final query = deviceName != null
        ? '?${RouteParams.deviceName}=${Uri.encodeComponent(deviceName)}'
        : '';
    go('$path$query');
  }

  void goToDeviceAnalytics(String deviceId, {String? deviceName}) {
    final path = AppPaths.deviceAnalytics(deviceId);
    final query = deviceName != null
        ? '?${RouteParams.deviceName}=${Uri.encodeComponent(deviceName)}'
        : '';
    go('$path$query');
  }

  void goToDeviceAlarms(String deviceId, {String? deviceName}) {
    final path = AppPaths.deviceAlarms(deviceId);
    final query = deviceName != null
        ? '?${RouteParams.deviceName}=${Uri.encodeComponent(deviceName)}'
        : '';
    go('$path$query');
  }

  // ============ Legacy (для обратной совместимости) ============
  void goToSchedule(String deviceId, String deviceName) =>
      goToDeviceSchedule(deviceId, deviceName: deviceName);
  void goToAlarmHistory(String deviceId, String deviceName) =>
      goToDeviceAlarms(deviceId, deviceName: deviceName);
}
