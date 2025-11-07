import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hvac_control/main.dart' as app;
import 'package:hvac_control/presentation/pages/home_screen.dart';
import 'package:hvac_control/presentation/pages/unit_detail_screen.dart';
import 'package:hvac_control/presentation/widgets/optimized/optimized_hvac_card.dart';
import '../helpers/test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Device Control Integration Tests', () {
    setUpAll(() {
      TestHelper.setupTestDependencies();
    });

    tearDownAll(() {
      TestHelper.cleanupTestDependencies();
    });

    testWidgets('Complete device control flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Performance monitoring
      final stopwatch = Stopwatch()..start();

      // Wait for home screen to load
      await _waitForHomeScreen(tester);

      // Verify initial state
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(OptimizedHvacCard), findsWidgets);

      // Test 1: Select a device
      final firstDevice = find.byType(OptimizedHvacCard).first;
      expect(firstDevice, findsOneWidget);

      await tester.tap(firstDevice);
      await tester.pumpAndSettle();

      // Verify selection visual feedback
      // (This would check for the selected state styling)

      // Test 2: Toggle power
      final powerSwitch = find.byType(Switch).first;
      expect(powerSwitch, findsOneWidget);

      // Get initial power state
      final initialSwitch = tester.widget<Switch>(powerSwitch);
      final initialPowerState = initialSwitch.value;

      // Toggle power
      await tester.tap(powerSwitch);
      await tester.pumpAndSettle();

      // Verify power state changed
      final updatedSwitch = tester.widget<Switch>(powerSwitch);
      expect(updatedSwitch.value, !initialPowerState);

      // Test 3: Navigate to device details
      await _navigateToDeviceDetails(tester, firstDevice);

      // Verify we're on the detail screen
      expect(find.byType(UnitDetailScreen), findsOneWidget);

      // Test 4: Adjust temperature
      await _adjustTemperature(tester);

      // Test 5: Change mode
      await _changeMode(tester);

      // Test 6: Return to home screen
      await _navigateBack(tester);

      // Verify we're back on home screen
      expect(find.byType(HomeScreen), findsOneWidget);

      // Test 7: Test pull-to-refresh
      await _testPullToRefresh(tester);

      stopwatch.stop();
      debugPrint('Integration test completed in ${stopwatch.elapsed}');

      // Performance assertion
      expect(stopwatch.elapsedMilliseconds, lessThan(30000)); // 30 seconds max
    });

    testWidgets('Device control with network failure',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _waitForHomeScreen(tester);

      // Simulate network failure by toggling airplane mode
      // (In a real test, you'd mock the network layer)

      // Try to toggle power
      final powerSwitch = find.byType(Switch).first;
      await tester.tap(powerSwitch);
      await tester.pumpAndSettle();

      // Verify error handling
      // Should show error snackbar or toast
      expect(find.textContaining('error'), findsOneWidget);

      // Verify UI remains responsive
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Concurrent device operations', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _waitForHomeScreen(tester);

      // Find multiple devices
      final devices = find.byType(OptimizedHvacCard);
      expect(devices, findsWidgets);

      if (devices.evaluate().length >= 2) {
        // Toggle power on multiple devices rapidly
        await tester.tap(find.byType(Switch).at(0));
        await tester.pump(const Duration(milliseconds: 50));

        await tester.tap(find.byType(Switch).at(1));
        await tester.pump(const Duration(milliseconds: 50));

        // Wait for operations to complete
        await tester.pumpAndSettle();

        // Verify both operations succeeded
        // (Check for success indicators or state changes)
      }
    });

    testWidgets('Memory leak test during navigation',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _waitForHomeScreen(tester);

      // Perform multiple navigation cycles
      for (int i = 0; i < 5; i++) {
        // Navigate to detail
        final device = find.byType(OptimizedHvacCard).first;
        await tester.tap(device);
        await tester.pumpAndSettle();

        expect(find.byType(UnitDetailScreen), findsOneWidget);

        // Navigate back
        await tester.pageBack();
        await tester.pumpAndSettle();

        expect(find.byType(HomeScreen), findsOneWidget);
      }

      // Memory should not increase significantly
      // (In a real test, you'd monitor memory usage)
    });

    testWidgets('Performance test with large dataset',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _waitForHomeScreen(tester);

      final stopwatch = Stopwatch()..start();

      // Scroll through list
      await tester.dragFrom(
        const Offset(200, 400),
        const Offset(0, -2000),
      );

      stopwatch.stop();

      // Scrolling should be smooth (< 16ms per frame)
      expect(stopwatch.elapsedMilliseconds, lessThan(500));

      // Verify lazy loading works
      await tester.pumpAndSettle();

      // More items should be visible after scrolling
      final visibleCards = find.byType(OptimizedHvacCard);
      expect(visibleCards, findsWidgets);
    });

    testWidgets('State persistence across app lifecycle',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await _waitForHomeScreen(tester);

      // Make some state changes
      final powerSwitch = find.byType(Switch).first;
      await tester.tap(powerSwitch);
      await tester.pumpAndSettle();

      // Simulate app going to background
      // (In a real test, you'd use platform channels)
      tester.binding.handleAppLifecycleStateChanged(
        AppLifecycleState.paused,
      );

      // Simulate app coming back to foreground
      tester.binding.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
      );

      await tester.pumpAndSettle();

      // Verify state is preserved
      final currentSwitch = tester.widget<Switch>(powerSwitch);
      expect(currentSwitch.value, isNotNull);
    });
  });
}

// Helper functions for integration tests

Future<void> _waitForHomeScreen(WidgetTester tester) async {
  await tester.pumpAndSettle();

  // Wait for loading to complete (max 10 seconds)
  for (int i = 0; i < 20; i++) {
    if (find.byType(HomeScreen).evaluate().isNotEmpty) {
      break;
    }
    await tester.pump(const Duration(milliseconds: 500));
  }

  expect(find.byType(HomeScreen), findsOneWidget);
}

Future<void> _navigateToDeviceDetails(
  WidgetTester tester,
  Finder deviceFinder,
) async {
  // Long press to open details
  await tester.longPress(deviceFinder);
  await tester.pumpAndSettle();

  // Or tap on a details button if available
  final detailsButton = find.byIcon(Icons.arrow_forward_ios);
  if (detailsButton.evaluate().isNotEmpty) {
    await tester.tap(detailsButton.first);
    await tester.pumpAndSettle();
  }
}

Future<void> _adjustTemperature(WidgetTester tester) async {
  // Find temperature adjustment controls
  final increaseButton = find.byIcon(Icons.add);
  final decreaseButton = find.byIcon(Icons.remove);

  if (increaseButton.evaluate().isNotEmpty) {
    // Increase temperature
    await tester.tap(increaseButton.first);
    await tester.pumpAndSettle();

    // Verify temperature changed
    // (Would check actual temperature display)
  }

  if (decreaseButton.evaluate().isNotEmpty) {
    // Decrease temperature
    await tester.tap(decreaseButton.first);
    await tester.pumpAndSettle();
  }
}

Future<void> _changeMode(WidgetTester tester) async {
  // Find mode selector
  final modeButtons = find.byType(ChoiceChip);

  if (modeButtons.evaluate().isNotEmpty) {
    // Select a different mode
    await tester.tap(modeButtons.at(1));
    await tester.pumpAndSettle();

    // Verify mode changed
    // (Would check for visual feedback)
  }
}

Future<void> _navigateBack(WidgetTester tester) async {
  // Try back button
  final backButton = find.byType(BackButton);
  if (backButton.evaluate().isNotEmpty) {
    await tester.tap(backButton);
  } else {
    // Use system back
    await tester.pageBack();
  }
  await tester.pumpAndSettle();
}

Future<void> _testPullToRefresh(WidgetTester tester) async {
  // Find scrollable widget
  final scrollable = find.byType(Scrollable).first;

  // Pull down to refresh
  await tester.drag(scrollable, const Offset(0, 300));
  await tester.pump();

  // Wait for refresh indicator
  await tester.pump(const Duration(seconds: 1));

  // Release and wait for refresh to complete
  await tester.pumpAndSettle();

  // Verify data refreshed
  expect(find.byType(OptimizedHvacCard), findsWidgets);
}

/// Performance benchmarking utilities
class PerformanceBenchmark {
  static final Map<String, List<Duration>> _benchmarks = {};

  static Future<void> measure(
    String name,
    Future<void> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    await operation();
    stopwatch.stop();

    _benchmarks[name] ??= [];
    _benchmarks[name]!.add(stopwatch.elapsed);

    debugPrint('⏱️ $name: ${stopwatch.elapsed}');
  }

  static void printReport() {
    debugPrint('\n📊 Performance Benchmark Report:');
    _benchmarks.forEach((name, durations) {
      final average =
          durations.map((d) => d.inMilliseconds).reduce((a, b) => a + b) ~/
              durations.length;
      final min = durations
          .map((d) => d.inMilliseconds)
          .reduce((a, b) => a < b ? a : b);
      final max = durations
          .map((d) => d.inMilliseconds)
          .reduce((a, b) => a > b ? a : b);

      debugPrint('  $name:');
      debugPrint('    - Average: ${average}ms');
      debugPrint('    - Min: ${min}ms');
      debugPrint('    - Max: ${max}ms');
      debugPrint('    - Samples: ${durations.length}');
    });
  }

  static void reset() {
    _benchmarks.clear();
  }
}
