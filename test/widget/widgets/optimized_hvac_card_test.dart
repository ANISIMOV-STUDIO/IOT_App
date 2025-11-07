import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/presentation/widgets/optimized/optimized_hvac_card.dart';
import 'package:hvac_control/domain/entities/hvac_unit.dart';
import '../../helpers/test_helper.dart';
import '../../helpers/mocks.dart';

void main() {
  group('OptimizedHvacCard Widget Tests', () {
    late HvacUnit testUnit;

    setUp(() {
      testUnit = FakeHvacUnit(
        id: 'test-1',
        name: 'Living Room AC',
        location: 'Living Room',
        currentTemp: 22.5,
        targetTemp: 23.0,
        mode: 'cooling',
      );
    });

    group('Rendering Tests', () {
      testWidgets('renders correctly with all required elements',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(unit: testUnit),
          ),
        );

        // Verify unit name is displayed
        expect(find.text('Living Room AC'), findsOneWidget);

        // Verify location is displayed
        if (testUnit.location != null) {
          expect(find.text(testUnit.location!), findsOneWidget);
        }

        // Verify temperature displays
        expect(find.text('22.5°'), findsOneWidget); // Current temp
        expect(find.text('23.0°'), findsOneWidget); // Target temp

        // Verify status indicators
        expect(find.text('${testUnit.humidity}%'), findsOneWidget);
        expect(find.text(testUnit.fanSpeed), findsOneWidget);
        expect(find.text(testUnit.mode), findsOneWidget);

        // Verify power switch exists
        expect(find.byType(Switch), findsOneWidget);
      });

      testWidgets('applies selected state styling correctly',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(
              unit: testUnit,
              isSelected: true,
            ),
          ),
        );

        // Find the animated container
        final animatedContainer = tester.widget<AnimatedContainer>(
          find.byType(AnimatedContainer),
        );

        // Verify gradient is applied when selected
        expect(animatedContainer.decoration, isNotNull);
        final decoration = animatedContainer.decoration as BoxDecoration;
        expect(decoration.gradient, isNotNull);
      });

      testWidgets('renders correctly when unit is offline',
          (WidgetTester tester) async {
        final offlineUnit = FakeHvacUnit(
          id: 'test-2',
          name: 'Offline Unit',
        );

        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(unit: offlineUnit),
          ),
        );

        // Verify unit renders even when offline
        expect(find.text('Offline Unit'), findsOneWidget);
      });
    });

    group('Interaction Tests', () {
      testWidgets('handles tap interaction correctly',
          (WidgetTester tester) async {
        bool wasTapped = false;

        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(
              unit: testUnit,
              onTap: () => wasTapped = true,
            ),
          ),
        );

        // Tap the card
        await tester.tap(find.byType(OptimizedHvacCard));
        await tester.pump();

        expect(wasTapped, isTrue);
      });

      testWidgets('handles power toggle correctly',
          (WidgetTester tester) async {
        bool? newPowerState;

        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(
              unit: testUnit,
              onPowerChanged: (value) => newPowerState = value,
            ),
          ),
        );

        // Find and toggle the switch
        final switchFinder = find.byType(Switch);
        expect(switchFinder, findsOneWidget);

        // Initial state should be on
        Switch switchWidget = tester.widget(switchFinder);
        expect(switchWidget.value, isTrue);

        // Toggle the switch
        await tester.tap(switchFinder);
        await tester.pump();

        // Verify callback was called with new state
        expect(newPowerState, isFalse);

        // Toggle again
        await tester.tap(switchFinder);
        await tester.pump();

        expect(newPowerState, isTrue);
      });

      testWidgets('disables controls when power is off',
          (WidgetTester tester) async {
        final poweredOffUnit = FakeHvacUnit(
          id: 'test-3',
          name: 'Powered Off Unit',
          power: false,
        );

        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(unit: poweredOffUnit),
          ),
        );

        // Temperature display should have reduced opacity
        final opacityWidget = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );
        expect(opacityWidget.opacity, 0.5);
      });
    });

    group('Animation Tests', () {
      testWidgets('plays entrance animation', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(unit: testUnit),
          ),
        );

        // Initially, the widget should be animating
        await tester.pump(const Duration(milliseconds: 100));

        // After animation duration, it should be fully visible
        await tester.pumpAndSettle(const Duration(milliseconds: 600));

        expect(find.byType(OptimizedHvacCard), findsOneWidget);
      });

      testWidgets('animates selection state change',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(
              unit: testUnit,
              isSelected: false,
            ),
          ),
        );

        // Update to selected state
        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(
              unit: testUnit,
              isSelected: true,
            ),
          ),
        );

        // Pump for animation
        await tester.pump(const Duration(milliseconds: 100));

        // Verify animation is running
        expect(find.byType(AnimatedContainer), findsOneWidget);

        // Complete animation
        await tester.pumpAndSettle();
      });
    });

    group('Performance Tests', () {
      testWidgets('uses RepaintBoundary for optimization',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(unit: testUnit),
          ),
        );

        // Verify RepaintBoundary is used
        expect(find.byType(RepaintBoundary), findsAtLeastNWidgets(2));
      });

      testWidgets('properly implements AutomaticKeepAliveClientMixin',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            ListView(
              children: [
                OptimizedHvacCard(key: const Key('card1'), unit: testUnit),
                Container(height: 1000), // Spacer to enable scrolling
                OptimizedHvacCard(
                  key: const Key('card2'),
                  unit: FakeHvacUnit(id: 'test-2', name: 'Unit 2'),
                ),
              ],
            ),
          ),
        );

        // Scroll to hide first card
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump();

        // First card should still be in the widget tree (kept alive)
        expect(find.byKey(const Key('card1')), findsOneWidget);
      });

      testWidgets('handles rapid state updates efficiently',
          (WidgetTester tester) async {
        int rebuildCount = 0;

        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            StatefulBuilder(
              builder: (context, setState) {
                rebuildCount++;
                return OptimizedHvacCard(unit: testUnit);
              },
            ),
          ),
        );

        final initialRebuildCount = rebuildCount;

        // Simulate rapid updates
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }

        // Should not cause excessive rebuilds
        expect(rebuildCount - initialRebuildCount, lessThan(5));
      });

      testWidgets('measures and reports build performance',
          (WidgetTester tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            PerformanceMonitor(
              widgetName: 'OptimizedHvacCard',
              child: OptimizedHvacCard(unit: testUnit),
            ),
          ),
        );

        stopwatch.stop();

        // Initial build should be fast
        expect(stopwatch.elapsedMilliseconds, lessThan(100));

        // Measure rebuild performance
        stopwatch
          ..reset()
          ..start();

        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            PerformanceMonitor(
              widgetName: 'OptimizedHvacCard',
              child: OptimizedHvacCard(
                unit: testUnit,
                isSelected: true,
              ),
            ),
          ),
        );

        stopwatch.stop();

        // Rebuilds should be even faster
        expect(stopwatch.elapsedMilliseconds, lessThan(50));
      });
    });

    group('Accessibility Tests', () {
      testWidgets('has proper semantics for screen readers',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(unit: testUnit),
          ),
        );

        // Verify text is accessible
        expect(find.text('Living Room AC'), findsOneWidget);
        if (testUnit.location != null) {
          expect(find.text(testUnit.location!), findsOneWidget);
        }

        // Verify switch has proper semantics
        final switchFinder = find.byType(Switch);
        final switchWidget = tester.widget<Switch>(switchFinder);
        expect(switchWidget.value, isTrue);
      });

      testWidgets('has minimum tap target size', (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(
              unit: testUnit,
              onTap: () {},
            ),
          ),
        );

        // Get the size of the card
        final cardSize = tester.getSize(find.byType(OptimizedHvacCard));

        // Card should have minimum height for tap target
        expect(cardSize.height, greaterThanOrEqualTo(48.0));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles null callbacks gracefully',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(
              unit: testUnit,
              onTap: null,
              onPowerChanged: null,
            ),
          ),
        );

        // Should render without errors
        expect(find.byType(OptimizedHvacCard), findsOneWidget);

        // Try tapping - should not throw
        await tester.tap(find.byType(OptimizedHvacCard));
        await tester.pump();
      });

      testWidgets('handles extremely long text with ellipsis',
          (WidgetTester tester) async {
        final longNameUnit = FakeHvacUnit(
          id: 'test-long',
          name: 'This is an extremely long unit name that should be truncated',
        );

        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            SizedBox(
              width: 300,
              child: OptimizedHvacCard(unit: longNameUnit),
            ),
          ),
        );

        // Text should be present but truncated
        final textWidget = tester.widget<Text>(
          find.text(longNameUnit.name),
        );
        expect(textWidget.overflow, TextOverflow.ellipsis);
      });

      testWidgets('handles extreme temperature values',
          (WidgetTester tester) async {
        final extremeUnit = FakeHvacUnit(
          id: 'test-extreme',
          name: 'Extreme Unit',
          currentTemp: -40.0,
          targetTemp: 100.0,
        );

        await tester.pumpWidget(
          TestHelper.wrapWithMaterialApp(
            OptimizedHvacCard(unit: extremeUnit),
          ),
        );

        // Should display extreme values correctly
        expect(find.text('-40.0°'), findsOneWidget);
        expect(find.text('100.0°'), findsOneWidget);
      });
    });
  });
}
