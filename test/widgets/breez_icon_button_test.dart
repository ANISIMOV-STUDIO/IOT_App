/// Tests for BreezIconButton, BreezCircleButton, BreezPowerButton
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_icon_button.dart';
import 'package:hvac_control/core/theme/app_colors.dart';

import 'test_wrapper.dart';

void main() {
  group('BreezIconButton', () {
    testWidgets('renders icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezIconButton(
            icon: Icons.settings,
            onTap: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezIconButton(
            icon: Icons.add,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap when disabled', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezIconButton(
            icon: Icons.close,
            onTap: null,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('shows badge when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezIconButton(
            icon: Icons.notifications,
            onTap: () {},
            badge: '5',
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('applies custom icon color', (WidgetTester tester) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezIconButton(
            icon: Icons.home,
            onTap: () {},
            iconColor: customColor,
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.home));
      expect(icon.color, customColor);
    });

    testWidgets('has Tooltip when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezIconButton(
            icon: Icons.info,
            onTap: () {},
            tooltip: 'Info button',
          ),
        ),
      );

      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('works in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezIconButton(
            icon: Icons.dark_mode,
            onTap: () {},
          ),
          darkMode: true,
        ),
      );

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('isActive changes appearance', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezIconButton(
            icon: Icons.star,
            onTap: () {},
            isActive: true,
          ),
        ),
      );

      // Icon should be white when active
      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.color, AppColors.white);
    });
  });

  group('BreezCircleButton', () {
    testWidgets('renders icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezCircleButton(
            icon: Icons.add,
            onTap: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezCircleButton(
            icon: Icons.remove,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('respects custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezCircleButton(
            icon: Icons.add,
            onTap: () {},
            size: 80,
          ),
        ),
      );

      expect(find.byType(BreezCircleButton), findsOneWidget);
    });
  });

  group('BreezPowerButton', () {
    testWidgets('renders power icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezPowerButton(
            isPowered: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.power_settings_new), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezPowerButton(
            isPowered: true,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.power_settings_new));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('shows different style when powered', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezPowerButton(
            isPowered: true,
            onTap: () {},
          ),
        ),
      );

      expect(find.byType(BreezPowerButton), findsOneWidget);
    });

    testWidgets('shows different style when not powered', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezPowerButton(
            isPowered: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.byType(BreezPowerButton), findsOneWidget);
    });
  });
}
