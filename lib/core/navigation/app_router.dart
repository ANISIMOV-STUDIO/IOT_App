/// App Router Configuration
///
/// GoRouter-based navigation for web-friendly deep linking and URL management
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/pages/login_screen.dart';
import '../../presentation/screens/zilon_dashboard_screen.dart';
import '../../presentation/pages/unit_detail_screen.dart';
import '../../presentation/pages/room_detail_screen.dart';
import '../../presentation/pages/schedule_screen.dart';
import '../../presentation/pages/settings_screen.dart';
import '../../presentation/pages/device_management_screen.dart';
import '../../presentation/pages/device_search_screen.dart';
import '../../presentation/pages/qr_scanner_screen.dart';
import '../../presentation/pages/onboarding_screen.dart';
import '../../presentation/screens/zilon_controls_screen.dart';
import '../../presentation/screens/zilon_schedule_screen.dart';
import '../../presentation/screens/zilon_statistics_screen.dart';
import '../../presentation/screens/zilon_settings_screen.dart';
import '../../presentation/widgets/zilon_shell.dart';

/// App route names
class AppRoutes {
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  
  // Shell Routes
  static const String home = '/';
  static const String controls = '/controls';
  static const String schedule = '/schedule';
  static const String statistics = '/statistics';
  static const String settings = '/settings';

  // Detail Routes (kept for backward compat or deep linking)
  static const String unitDetail = '/unit/:id';
  static const String roomDetail = '/room/:id';
  static const String deviceManagement = '/devices';
  static const String deviceSearch = '/devices/search';
  static const String qrScanner = '/qr-scanner';
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
            HvacPrimaryButton(
              label: 'Go to Home',
              onPressed: () => context.go(AppRoutes.home),
            ),
          ],
        ),
      ),
    ),

    routes: [
      // Login & Onboarding (Standalone)
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ZILON Shell (Sidebar Navigation)
      ShellRoute(
        builder: (context, state, child) => ZilonShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const ZilonDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.controls,
            builder: (context, state) => const ZilonControlsScreen(),
          ),
          GoRoute(
            path: AppRoutes.schedule,
            builder: (context, state) => const ZilonScheduleScreen(), 
            // Note: Use global schedule for now, or adapt to handle unitId if needed later
          ),
          GoRoute(
            path: AppRoutes.statistics,
            builder: (context, state) => const ZilonStatisticsScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const ZilonSettingsScreen(),
          ),
          // Keep these under Shell if you want them to have sidebar, 
          // or move out if they should be full screen. 
          // For now, let's keep them accessible but maybe refactor later.
          GoRoute(
            path: AppRoutes.deviceManagement,
            builder: (context, state) => const DeviceManagementScreen(),
          ),
          GoRoute(
            path: AppRoutes.deviceSearch,
            builder: (context, state) => const DeviceSearchScreen(),
          ),
          GoRoute(
            path: AppRoutes.qrScanner,
            builder: (context, state) => const QrScannerScreen(),
          ),
        ],
      ),
      
      // Detail routes (can be outside shell or inside)
      // For ZILON style, details usually overlay or replace content.
      GoRoute(
        path: AppRoutes.unitDetail,
        builder: (context, state) {
           final unitId = state.pathParameters['id'];
           return UnitDetailScreen(unitId: unitId ?? '');
        }
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
    // go('/schedule/$unitId'); // Old
    go(AppRoutes.schedule); // New global schedule
  }

  /// Navigate to analytics page
  void goToAnalytics() {
    go(AppRoutes.statistics);
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
