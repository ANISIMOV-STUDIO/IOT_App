/// Tests for BreezCheckbox widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_checkbox.dart';

import 'test_wrapper.dart';

void main() {
  group('BreezCheckbox', () {
    testWidgets('renders label', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezCheckbox(
            value: false,
            onChanged: (_) {},
            label: 'Test Label',
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('shows check icon when checked', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezCheckbox(
            value: true,
            onChanged: (_) {},
            label: 'Checked',
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('does not show check icon when unchecked',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezCheckbox(
            value: false,
            onChanged: (_) {},
            label: 'Unchecked',
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('calls onChanged with new value when tapped',
        (WidgetTester tester) async {
      bool? newValue;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezCheckbox(
            value: false,
            onChanged: (v) => newValue = v,
            label: 'Toggle Me',
          ),
        ),
      );

      await tester.tap(find.text('Toggle Me'));
      await tester.pumpAndSettle();

      expect(newValue, isTrue);
    });

    testWidgets('calls onChanged with false when checked and tapped',
        (WidgetTester tester) async {
      bool? newValue;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezCheckbox(
            value: true,
            onChanged: (v) => newValue = v,
            label: 'Uncheck Me',
          ),
        ),
      );

      await tester.tap(find.text('Uncheck Me'));
      await tester.pumpAndSettle();

      expect(newValue, isFalse);
    });

    testWidgets('does not call onChanged when disabled',
        (WidgetTester tester) async {
      bool? newValue;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          const BreezCheckbox(
            value: false,
            onChanged: null,
            label: 'Disabled',
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      expect(newValue, isNull);
    });

    testWidgets('has Semantics widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezCheckbox(
            value: true,
            onChanged: (_) {},
            label: 'Accessible',
          ),
        ),
      );

      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('applies custom fontSize', (WidgetTester tester) async {
      const customFontSize = 18.0;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezCheckbox(
            value: false,
            onChanged: (_) {},
            label: 'Custom Font',
            fontSize: customFontSize,
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Custom Font'));
      expect(text.style?.fontSize, equals(customFontSize));
    });

    testWidgets('works in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezCheckbox(
            value: true,
            onChanged: (_) {},
            label: 'Dark Mode',
          ),
          darkMode: true,
        ),
      );

      expect(find.byType(BreezCheckbox), findsOneWidget);
    });
  });
}
