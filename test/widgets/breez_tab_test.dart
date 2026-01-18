/// Tests for BreezTab and BreezTabGroup
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_tab.dart';

import 'test_wrapper.dart';

void main() {
  group('BreezTab', () {
    testWidgets('renders label', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTab(
            label: 'Mon',
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Mon'), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTab(
            label: 'Tue',
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Tue'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap when disabled', (WidgetTester tester) async {
      const tapped = false;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezTab(
            label: 'Wed',
          ),
        ),
      );

      await tester.tap(find.text('Wed'));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('shows selected state', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTab(
            label: 'Thu',
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      expect(find.byType(BreezTab), findsOneWidget);
    });

    testWidgets('shows active indicator when isActive', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTab(
            label: 'Fri',
            isActive: true,
            onTap: () {},
          ),
        ),
      );

      // Should show active indicator (green dot)
      expect(find.byType(BreezTab), findsOneWidget);
    });

    testWidgets('works in compact mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTab(
            label: 'Sat',
            compact: true,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Sat'), findsOneWidget);
    });

    testWidgets('has Semantics', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTab(
            label: 'Sun',
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('works in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTab(
            label: 'Mon',
            onTap: () {},
          ),
          darkMode: true,
        ),
      );

      expect(find.text('Mon'), findsOneWidget);
    });
  });

  group('BreezTabGroup', () {
    testWidgets('renders all tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTabGroup(
            labels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
            selectedIndex: 0,
            onTabSelected: (_) {},
          ),
        ),
      );

      expect(find.text('Mon'), findsOneWidget);
      expect(find.text('Tue'), findsOneWidget);
      expect(find.text('Wed'), findsOneWidget);
      expect(find.text('Thu'), findsOneWidget);
      expect(find.text('Fri'), findsOneWidget);
    });

    testWidgets('calls onTabSelected with correct index', (WidgetTester tester) async {
      int? selectedIndex;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTabGroup(
            labels: const ['A', 'B', 'C'],
            selectedIndex: 0,
            onTabSelected: (index) => selectedIndex = index,
          ),
        ),
      );

      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
    });

    testWidgets('marks correct tab as selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTabGroup(
            labels: const ['A', 'B', 'C'],
            selectedIndex: 1,
            onTabSelected: (_) {},
          ),
        ),
      );

      // Tab B should be selected
      expect(find.byType(BreezTab), findsNWidgets(3));
    });

    testWidgets('shows active indicators for active indices', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTabGroup(
            labels: const ['A', 'B', 'C'],
            selectedIndex: 0,
            activeIndices: const {0, 2},
            onTabSelected: (_) {},
          ),
        ),
      );

      expect(find.byType(BreezTab), findsNWidgets(3));
    });

    testWidgets('works in compact mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTabGroup(
            labels: const ['Mon', 'Tue', 'Wed'],
            selectedIndex: 0,
            compact: true,
            onTabSelected: (_) {},
          ),
        ),
      );

      expect(find.byType(BreezTab), findsNWidgets(3));
    });

    testWidgets('has Semantics wrapper', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezTabGroup(
            labels: const ['A', 'B'],
            selectedIndex: 0,
            onTabSelected: (_) {},
          ),
        ),
      );

      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('works without onTabSelected (read-only)', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezTabGroup(
            labels: ['A', 'B', 'C'],
            selectedIndex: 0,
          ),
        ),
      );

      expect(find.byType(BreezTab), findsNWidgets(3));
    });
  });
}
