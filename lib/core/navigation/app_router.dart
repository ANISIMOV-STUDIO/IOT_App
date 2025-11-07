/// App Router Configuration
///
/// GoRouter-based navigation for web-friendly deep linking and URL management
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/pages/login_screen.dart';
import '../../presentation/pages/home_screen.dart';
import '../../presentation/pages/unit_detail_screen.dart';
import '../../presentation/pages/room_detail_screen.dart';
import '../../presentation/pages/schedule_screen.dart';
import '../../presentation/pages/settings_screen.dart';
import '../../presentation/pages/device_management_screen.dart';
import '../../presentation/pages/device_search_screen.dart';
import '../../presentation/pages/qr_scanner_screen.dart';
import '../../presentation/pages/onboarding_screen.dart';

/// App route names
class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String unitDetail = '/unit/:id';
  static const String roomDetail = '/room/:id';
  static const String analytics = '/analytics';
  static const String schedule = '/schedule/:unitId';
  static const String settings = '/settings';
  static const String deviceManagement = '/devices';
  static const String deviceSearch = '/devices/search';
  static const String qrScanner = '/qr-scanner';
  static const String onboarding = '/onboarding';
}

/// Global router configuration
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// GoRouter refresh notifier based on Stream
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (AuthState _) {
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Creates the GoRouter instance
GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.home,

    // Listen to auth state changes
    refreshListenable: _GoRouterRefreshStream(authBloc.stream),

    // Redirect logic based on authentication state
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final isAuthenticating =
          authState is AuthLoading || authState is AuthInitial;
      final isAuthenticated = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;

      // Show loading screen while checking auth
      if (isAuthenticating) {
        return null; // Stay on current route, will show loading state
      }

      // Redirect to login if not authenticated (except onboarding)
      if (!isAuthenticated && !isLoggingIn && !isOnboarding) {
        return AppRoutes.login;
      }

      // Redirect to home if already authenticated and on login/onboarding page
      if (isAuthenticated && (isLoggingIn || isOnboarding)) {
        return AppRoutes.home;
      }

      return null; // No redirect needed
    },

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.matchedLocation}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),

    routes: [
      // Login route
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Onboarding route
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Home route
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // Unit detail route with ID parameter
      GoRoute(
        path: AppRoutes.unitDetail,
        builder: (context, state) {
          final unitId = state.pathParameters['id'];
          if (unitId == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid unit ID')),
            );
          }
          return UnitDetailScreen(unitId: unitId);
        },
      ),

      // Room detail route with ID parameter
      GoRoute(
        path: AppRoutes.roomDetail,
        builder: (context, state) {
          final roomId = state.pathParameters['id'];
          if (roomId == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid room ID')),
            );
          }
          return RoomDetailScreen(unitId: roomId);
        },
      ),

      // Analytics route
      GoRoute(
        path: AppRoutes.analytics,
        builder: (context, state) {
          // Analytics screen shows data for all units, no specific unit needed
          // For now, we'll pass a dummy unit or refactor AnalyticsScreen to not require unit
          return const Scaffold(
            body: Center(child: Text('Analytics - Coming Soon')),
          );
        },
      ),

      // Schedule route with unit ID parameter
      GoRoute(
        path: AppRoutes.schedule,
        builder: (context, state) {
          final unitId = state.pathParameters['unitId'];
          if (unitId == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid unit ID')),
            );
          }
          return ScheduleScreen(unitId: unitId);
        },
      ),

      // Settings route
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Device management route
      GoRoute(
        path: AppRoutes.deviceManagement,
        builder: (context, state) => const DeviceManagementScreen(),
      ),

      // Device search route
      GoRoute(
        path: AppRoutes.deviceSearch,
        builder: (context, state) => const DeviceSearchScreen(),
      ),

      // QR Scanner route
      GoRoute(
        path: AppRoutes.qrScanner,
        builder: (context, state) => const QrScannerScreen(),
      ),
    ],
  );
}

/// GoRouter extensions for easier navigation
extension GoRouterExtensions on BuildContext {
  /// Navigate to unit detail page
  void goToUnitDetail(String unitId) {
    go('/unit/$unitId');
  }

  /// Navigate to room detail page
  void goToRoomDetail(String roomId) {
    go('/room/$roomId');
  }

  /// Navigate to schedule page
  void goToSchedule(String unitId) {
    go('/schedule/$unitId');
  }

  /// Navigate to analytics page
  void goToAnalytics() {
    go(AppRoutes.analytics);
  }

  /// Navigate to settings page
  void goToSettings() {
    go(AppRoutes.settings);
  }

  /// Navigate to device management page
  void goToDeviceManagement() {
    go(AppRoutes.deviceManagement);
  }

  /// Navigate to device search page
  void goToDeviceSearch() {
    go(AppRoutes.deviceSearch);
  }

  /// Navigate to QR scanner page
  void goToQrScanner() {
    go(AppRoutes.qrScanner);
  }

  /// Navigate to home page
  void goToHome() {
    go(AppRoutes.home);
  }

  /// Navigate to login page
  void goToLogin() {
    go(AppRoutes.login);
  }
}
