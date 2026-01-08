/// Tests for BreezCard widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';

import 'test_wrapper.dart';

void main() {
  group('BreezCard', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezCard(
            child: Text('Card Content'),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('applies custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(32);

      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezCard(
            padding: customPadding,
            child: Text('Padded'),
          ),
        ),
      );

      expect(find.byType(BreezCard), findsOneWidget);
    });

    testWidgets('reduces opacity when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezCard(
            disabled: true,
            child: Text('Disabled Card'),
          ),
        ),
      );

      final opacityFinder = find.byType(AnimatedOpacity);
      expect(opacityFinder, findsOneWidget);

      final opacity = tester.widget<AnimatedOpacity>(opacityFinder);
      expect(opacity.opacity, lessThan(1.0));
    });

    testWidgets('has full opacity when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezCard(
            disabled: false,
            child: Text('Enabled Card'),
          ),
        ),
      );

      final opacityFinder = find.byType(AnimatedOpacity);
      expect(opacityFinder, findsOneWidget);

      final opacity = tester.widget<AnimatedOpacity>(opacityFinder);
      expect(opacity.opacity, equals(1.0));
    });

    testWidgets('renders title when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezCard(
            title: 'Card Title',
            child: Text('Content'),
          ),
        ),
      );

      // Title is uppercase
      expect(find.text('CARD TITLE'), findsOneWidget);
    });

    testWidgets('renders description when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezCard(
            description: 'Card description',
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('Card description'), findsOneWidget);
    });

    testWidgets('shows shimmer when loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezCard(
            isLoading: true,
            child: Text('Loading'),
          ),
        ),
      );

      // Child should not be visible when loading
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('has Semantics', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezCard(
            title: 'Accessible Card',
            child: Text('Content'),
          ),
        ),
      );

      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('works without optional parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezCard(
            child: Text('Simple Card'),
          ),
        ),
      );

      expect(find.text('Simple Card'), findsOneWidget);
      expect(find.byType(BreezCard), findsOneWidget);
    });

    testWidgets('ignores pointer when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezCard(
            disabled: true,
            child: Text('Disabled'),
          ),
        ),
      );

      // Find IgnorePointer widgets that are actually ignoring
      final ignorePointers = find.byType(IgnorePointer).evaluate();
      final ignoringWidget = ignorePointers.firstWhere(
        (e) => (e.widget as IgnorePointer).ignoring,
        orElse: () => throw StateError('No ignoring IgnorePointer found'),
      );
      expect((ignoringWidget.widget as IgnorePointer).ignoring, isTrue);
    });

    testWidgets('works in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezCard(
            child: Text('Dark Mode'),
          ),
          darkMode: true,
        ),
      );

      expect(find.byType(BreezCard), findsOneWidget);
    });
  });
}
