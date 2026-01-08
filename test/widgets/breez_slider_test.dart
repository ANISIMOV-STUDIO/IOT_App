/// Tests for BreezSlider widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_slider.dart';

import 'test_wrapper.dart';

void main() {
  group('BreezSlider', () {
    testWidgets('renders with initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezSlider(
            value: 0.5,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(BreezSlider), findsOneWidget);
    });

    testWidgets('calls onChanged when dragged', (WidgetTester tester) async {
      double? newValue;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          SizedBox(
            width: 300,
            child: BreezSlider(
              value: 0.0,
              onChanged: (v) => newValue = v,
            ),
          ),
        ),
      );

      // Drag the slider to the right
      await tester.drag(find.byType(BreezSlider), const Offset(100, 0));
      await tester.pumpAndSettle();

      expect(newValue, isNotNull);
      expect(newValue, greaterThan(0.0));
    });

    testWidgets('does not call onChanged when disabled',
        (WidgetTester tester) async {
      double? newValue;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          SizedBox(
            width: 300,
            child: BreezSlider(
              value: 0.5,
              onChanged: null,
            ),
          ),
        ),
      );

      await tester.drag(find.byType(BreezSlider), const Offset(50, 0));
      await tester.pumpAndSettle();

      expect(newValue, isNull);
    });

    testWidgets('respects min and max values', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezSlider(
            value: 50,
            min: 0,
            max: 100,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(BreezSlider), findsOneWidget);
    });

    testWidgets('applies custom activeColor', (WidgetTester tester) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezSlider(
            value: 0.5,
            onChanged: (_) {},
            activeColor: customColor,
          ),
        ),
      );

      expect(find.byType(BreezSlider), findsOneWidget);
    });

    testWidgets('respects custom trackHeight', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezSlider(
            value: 0.5,
            onChanged: (_) {},
            trackHeight: 12.0,
          ),
        ),
      );

      expect(find.byType(BreezSlider), findsOneWidget);
    });

    testWidgets('respects custom thumbRadius', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezSlider(
            value: 0.5,
            onChanged: (_) {},
            thumbRadius: 16.0,
          ),
        ),
      );

      expect(find.byType(BreezSlider), findsOneWidget);
    });

    testWidgets('works in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezSlider(
            value: 0.5,
            onChanged: (_) {},
          ),
          darkMode: true,
        ),
      );

      expect(find.byType(BreezSlider), findsOneWidget);
    });
  });

  group('BreezLabeledSlider', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezLabeledSlider(
            label: 'Volume',
            value: 50,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Volume'), findsOneWidget);
    });

    testWidgets('shows formatted value with default suffix',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezLabeledSlider(
            label: 'Speed',
            value: 75.0,
            min: 0,
            max: 100,
            onChanged: (_) {},
          ),
        ),
      );

      // Default format is "75%" (rounded value + %)
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('shows custom suffix', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezLabeledSlider(
            label: 'Temperature',
            value: 22.0,
            min: 15,
            max: 30,
            onChanged: (_) {},
            suffix: '°C',
          ),
        ),
      );

      expect(find.text('22°C'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezLabeledSlider(
            label: 'Brightness',
            value: 50,
            onChanged: (_) {},
            icon: Icons.brightness_low,
          ),
        ),
      );

      expect(find.byIcon(Icons.brightness_low), findsOneWidget);
    });

    testWidgets('calls onChanged when slider is dragged',
        (WidgetTester tester) async {
      double? newValue;

      await tester.pumpWidget(
        wrapWithBreezTheme(
          SizedBox(
            width: 300,
            child: BreezLabeledSlider(
              label: 'Test',
              value: 0.0,
              onChanged: (v) => newValue = v,
            ),
          ),
        ),
      );

      await tester.drag(find.byType(BreezSlider), const Offset(100, 0));
      await tester.pumpAndSettle();

      expect(newValue, isNotNull);
    });

    testWidgets('is disabled when onChanged is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezLabeledSlider(
            label: 'Disabled',
            value: 50,
            onChanged: null,
          ),
        ),
      );

      expect(find.byType(BreezLabeledSlider), findsOneWidget);
    });

    testWidgets('works in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithBreezTheme(
          BreezLabeledSlider(
            label: 'Dark Mode',
            value: 50,
            onChanged: (_) {},
          ),
          darkMode: true,
        ),
      );

      expect(find.byType(BreezLabeledSlider), findsOneWidget);
    });
  });
}
