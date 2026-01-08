/// Tests for BreezButton widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

import 'test_wrapper.dart';

void main() {
  group('BreezButton', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () {},
            child: const Text('Test Button'),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () => tapped = true,
            child: const Text('Tap Me'),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap when disabled (onTap is null)',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: null,
            child: const Text('Disabled'),
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () {},
            isLoading: true,
            child: const Text('Loading'),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('does not call onTap when loading', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () => tapped = true,
            isLoading: true,
            child: const Text('Loading'),
          ),
        ),
      );

      // When loading, tapping should not trigger onTap
      await tester.tap(find.byType(CircularProgressIndicator));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('shows tooltip when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () {},
            tooltip: 'Test Tooltip',
            child: const Text('Hover Me'),
          ),
        ),
      );

      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('has Semantics wrapper when semanticLabel provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () {},
            semanticLabel: 'Custom Label',
            child: const Text('Button'),
          ),
        ),
      );

      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('respects custom backgroundColor', (WidgetTester tester) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () {},
            backgroundColor: customColor,
            child: const Text('Colored'),
          ),
        ),
      );

      expect(find.byType(BreezButton), findsOneWidget);
    });

    testWidgets('respects custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(24);

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () {},
            padding: customPadding,
            child: const Text('Padded'),
          ),
        ),
      );

      expect(find.byType(BreezButton), findsOneWidget);
    });

    testWidgets('respects custom borderRadius', (WidgetTester tester) async {
      const customRadius = 20.0;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () {},
            borderRadius: customRadius,
            child: const Text('Rounded'),
          ),
        ),
      );

      expect(find.byType(BreezButton), findsOneWidget);
    });

    testWidgets('works with showBorder false', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () {},
            showBorder: false,
            child: const Text('No Border'),
          ),
        ),
      );

      expect(find.byType(BreezButton), findsOneWidget);
    });

    testWidgets('works with enableScale false', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () {},
            enableScale: false,
            child: const Text('No Scale'),
          ),
        ),
      );

      expect(find.byType(BreezButton), findsOneWidget);
    });

    testWidgets('works with enableGlow true', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () {},
            enableGlow: true,
            child: const Text('Glow'),
          ),
        ),
      );

      expect(find.byType(BreezButton), findsOneWidget);
    });

    testWidgets('works in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezButton(
            onTap: () {},
            child: const Text('Dark Mode'),
          ),
          darkMode: true,
        ),
      );

      expect(find.byType(BreezButton), findsOneWidget);
    });
  });
}
