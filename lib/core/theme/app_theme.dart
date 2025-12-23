import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Semantic colors for the app - HVAC-specific
/// These colors are used across the entire application
abstract class AppColors {
  // Climate modes
  static const Color heating = Color(0xFFFF6B35);
  static const Color cooling = Color(0xFF00B4D8);
  static const Color modeAuto = Color(0xFF8B5CF6);

  // Status colors
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFFCC00);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF007AFF);

  // Air quality - only unique shade (others use status colors)
  static const Color airGood = Color(0xFF30D158);
  // Use: success for excellent, airGood for good, warning for moderate, error for poor

  // Primary accent
  static const Color primary = Color(0xFF2563EB);
}

/// App theme configuration using shadcn_ui
/// Corporate blue theme - light and dark modes
abstract class AppTheme {
  /// Light theme - blue corporate
  static ShadThemeData get shadLight => ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadBlueColorScheme.light(),
      );

  /// Dark theme - blue corporate
  static ShadThemeData get shadDark => ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadBlueColorScheme.dark(),
      );

  /// Material light theme (for compatibility with Material widgets)
  static ThemeData get materialLight => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // Blue-600
          brightness: Brightness.light,
        ),
      );

  /// Material dark theme (for compatibility with Material widgets)
  static ThemeData get materialDark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6), // Blue-500
          brightness: Brightness.dark,
        ),
      );
}
