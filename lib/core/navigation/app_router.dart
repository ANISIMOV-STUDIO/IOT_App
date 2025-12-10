/// App Router Configuration
///
/// GoRouter-based navigation for web-friendly deep linking and URL management
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/pages/login_screen.dart';
import '../../presentation/screens/neumorphic_dashboard_screen.dart';
import '../../presentation/pages/device_management_screen.dart';
import '../../presentation/pages/device_search_screen.dart';
import '../../presentation/pages/qr_scanner_screen.dart';
import '../../presentation/pages/onboarding_screen.dart';

/// App route names
class AppRoutes {
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  static const String home = '/';
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
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
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
    refreshListenable: _GoRouterRefreshStream(authBloc.stream),

    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final isAuthenticating = authState is AuthLoading || authState is AuthInitial;
      final isAuthenticated = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;

      if (isAuthenticating) return null;
      if (!isAuthenticated && !isLoggingIn && !isOnboarding) return AppRoutes.login;
      if (isAuthenticated && (isLoggingIn || isOnboarding)) return AppRoutes.home;
      return null;
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
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),

    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const NeumorphicDashboardScreen(),
      ),
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
  );
}

/// GoRouter extensions for easier navigation
extension GoRouterExtensions on BuildContext {
  void goToHome() => go(AppRoutes.home);
  void goToLogin() => go(AppRoutes.login);
  void goToDeviceManagement() => go(AppRoutes.deviceManagement);
  void goToDeviceSearch() => go(AppRoutes.deviceSearch);
  void goToQrScanner() => go(AppRoutes.qrScanner);
}
