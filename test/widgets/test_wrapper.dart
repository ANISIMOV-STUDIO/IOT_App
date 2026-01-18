/// Test wrapper that provides BREEZ theme for widget tests
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';

/// Wraps a widget with MaterialApp and BREEZ theme for testing
Widget wrapWithBreezTheme(Widget child, {bool darkMode = false}) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      extensions: const [BreezColors.light],
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      extensions: const [BreezColors.dark],
    ),
    themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
    home: Scaffold(body: child),
  );
