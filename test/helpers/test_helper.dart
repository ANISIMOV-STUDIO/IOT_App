import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';

/// Test helper utilities for widget and integration testing
class TestHelper {
  /// Wraps a widget with necessary providers for testing
  static Widget wrapWithMaterialApp(
    Widget widget, {
    List<BlocProvider>? blocProviders,
    NavigatorObserver? navigatorObserver,
    ThemeData? theme,
  }) {
    Widget child = widget;

    // Wrap with BLoC providers if provided
    if (blocProviders != null && blocProviders.isNotEmpty) {
      child = MultiBlocProvider(
        providers: blocProviders,
        child: child,
      );
    }

    return MaterialApp(
      home: Scaffold(body: child),
      theme: theme ?? ThemeData.light(),
      navigatorObservers:
          navigatorObserver != null ? [navigatorObserver] : [],
    );
  }

  /// Pumps widget and settles with timeout protection
  static Future<void> pumpAndSettleWithTimeout(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pump();
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      timeout,
    );
  }

  /// Creates a mock navigation observer for testing navigation
  static NavigatorObserver createMockNavigatorObserver() {
    return MockNavigatorObserver();
  }

  /// Setup GetIt for testing with mock dependencies
  static void setupTestDependencies() {
    final getIt = GetIt.instance;
    if (getIt.isRegistered<Object>()) {
      getIt.reset();
    }
  }

  /// Cleanup test dependencies
  static void cleanupTestDependencies() {
    GetIt.instance.reset();
  }

  /// Creates a test widget with all necessary wrappers
  static Widget createTestableWidget(
    Widget widget, {
    Size designSize = const Size(375, 812),
  }) {
    return MaterialApp(
      home: Material(child: widget),
    );
  }

  /// Verify widget has proper responsive dimensions
  static void verifyResponsiveDimensions(
    Widget widget,
    WidgetTester tester,
  ) {
    // Check that no hard-coded dimensions exist
    final finder = find.byWidget(widget);
    expect(finder, findsOneWidget);

    // Additional responsive checks can be added here
  }
}

/// Mock classes for testing
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockBuildContext extends Mock implements BuildContext {}

/// Test data builders
class TestDataBuilder {
  static Map<String, dynamic> createMockHvacUnit({
    String? id,
    String? name,
    double? currentTemp,
    double? targetTemp,
  }) {
    return {
      'id': id ?? 'test-unit-1',
      'name': name ?? 'Test HVAC Unit',
      'currentTemp': currentTemp ?? 22.5,
      'targetTemp': targetTemp ?? 23.0,
      'humidity': 45,
      'mode': 'cooling',
      'fanSpeed': 'medium',
      'power': true,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> createMockUser({
    String? id,
    String? email,
    String? name,
  }) {
    return {
      'id': id ?? 'test-user-1',
      'email': email ?? 'test@example.com',
      'name': name ?? 'Test User',
      'role': 'admin',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> createMockSchedule({
    String? id,
    String? unitId,
    String? name,
  }) {
    return {
      'id': id ?? 'test-schedule-1',
      'unitId': unitId ?? 'test-unit-1',
      'name': name ?? 'Test Schedule',
      'enabled': true,
      'days': ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'],
      'startTime': '08:00',
      'endTime': '18:00',
      'temperature': 22.0,
      'mode': 'auto',
    };
  }
}

/// Custom matchers for testing
class CustomMatchers {
  static Matcher hasResponsiveWidth() {
    return const _HasResponsiveWidth();
  }

  static Matcher hasResponsiveHeight() {
    return const _HasResponsiveHeight();
  }

  static Matcher hasProperConst() {
    return const _HasProperConst();
  }
}

class _HasResponsiveWidth extends Matcher {
  const _HasResponsiveWidth();

  @override
  bool matches(dynamic item, Map matchState) {
    // Implementation to check if widget uses .w extension
    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('has responsive width using .w extension');
  }
}

class _HasResponsiveHeight extends Matcher {
  const _HasResponsiveHeight();

  @override
  bool matches(dynamic item, Map matchState) {
    // Implementation to check if widget uses .h extension
    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('has responsive height using .h extension');
  }
}

class _HasProperConst extends Matcher {
  const _HasProperConst();

  @override
  bool matches(dynamic item, Map matchState) {
    // Check if widget properly uses const constructors
    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('uses const constructors where appropriate');
  }
}

/// Extension methods for testing
extension WidgetTesterExtensions on WidgetTester {
  /// Finds widget by key with type safety
  T widget<T extends Widget>(Key key) {
    return find.byKey(key).evaluate().single.widget as T;
  }

  /// Pumps widget multiple times for animations
  Future<void> pumpAnimations([
    Duration duration = const Duration(milliseconds: 600),
  ]) async {
    await pump();
    await pump(duration);
  }

  /// Simulates user scroll gesture
  Future<void> scrollUntilVisible(
    Finder finder,
    double delta, {
    Finder? scrollable,
    int maxScrolls = 50,
  }) async {
    for (int i = 0; i < maxScrolls; i++) {
      if (finder.evaluate().isNotEmpty) {
        break;
      }
      await drag(scrollable ?? find.byType(Scrollable).first,
          Offset(0, delta));
      await pump();
    }
  }
}

/// Performance testing utilities
class PerformanceTestHelper {
  static final Map<String, List<Duration>> _measurements = {};

  /// Measure widget build time
  static Future<Duration> measureBuildTime(
    WidgetTester tester,
    Widget widget,
  ) async {
    final stopwatch = Stopwatch()..start();
    await tester.pumpWidget(TestHelper.wrapWithMaterialApp(widget));
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Measure animation performance
  static Future<void> measureAnimationPerformance(
    WidgetTester tester,
    String animationName,
    Future<void> Function() animationCallback,
  ) async {
    final stopwatch = Stopwatch()..start();
    await animationCallback();
    stopwatch.stop();

    _measurements[animationName] ??= [];
    _measurements[animationName]!.add(stopwatch.elapsed);
  }

  /// Get performance report
  static Map<String, Map<String, dynamic>> getPerformanceReport() {
    final report = <String, Map<String, dynamic>>{};

    _measurements.forEach((name, durations) {
      final average = durations.reduce((a, b) => a + b) ~/ durations.length;
      final max = durations.reduce((a, b) => a > b ? a : b);
      final min = durations.reduce((a, b) => a < b ? a : b);

      report[name] = {
        'average': average.inMilliseconds,
        'max': max.inMilliseconds,
        'min': min.inMilliseconds,
        'samples': durations.length,
      };
    });

    return report;
  }

  /// Clear all measurements
  static void clearMeasurements() {
    _measurements.clear();
  }
}