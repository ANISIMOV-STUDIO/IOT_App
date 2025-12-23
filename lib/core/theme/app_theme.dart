import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Design system colors - BREEZ Blue theme
/// Corporate blue matching the BREEZ logo
abstract class AppColors {
  // Primary palette - BREEZ Blue
  static const Color primary = Color(0xFF2563EB); // Blue-600
  static const Color primaryLight = Color(0xFF3B82F6); // Blue-500
  static const Color primaryDark = Color(0xFF1D4ED8); // Blue-700

  // Accent (cyan for secondary actions)
  static const Color accent = Color(0xFF06B6D4); // Cyan-500
  static const Color accentLight = Color(0xFF22D3EE); // Cyan-400

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, accent],
  );

  static const LinearGradient bannerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF1D4ED8), Color(0xFF0891B2)],
  );

  // Background colors (light theme)
  static const Color background = Color(0xFFF8FAFC); // Slate-50
  static const Color surface = Color(0xFFFFFFFF); // White cards
  static const Color surfaceVariant = Color(0xFFEFF6FF); // Blue-50

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate-900
  static const Color textSecondary = Color(0xFF475569); // Slate-600
  static const Color textMuted = Color(0xFF94A3B8); // Slate-400

  // Climate modes
  static const Color heating = Color(0xFFEF4444); // Red-500
  static const Color cooling = Color(0xFF3B82F6); // Blue-500
  static const Color modeAuto = Color(0xFF8B5CF6); // Violet-500 (for auto only)
  static const Color ventilation = Color(0xFF06B6D4); // Cyan-500

  // Status colors
  static const Color success = Color(0xFF22C55E); // Green-500
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color info = Color(0xFF3B82F6); // Blue-500

  // Card styling
  static const double cardRadius = 20.0;
  static const double cardRadiusSmall = 12.0;
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];
}

/// App theme configuration
/// Light theme with blue accents (BREEZ corporate)
abstract class AppTheme {
  /// Light theme - primary theme
  static ShadThemeData get shadLight => ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadBlueColorScheme.light(),
      );

  /// Dark theme
  static ShadThemeData get shadDark => ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadBlueColorScheme.dark(),
      );

  /// Material light theme
  static ThemeData get materialLight => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        cardTheme: const CardThemeData(
          elevation: 0,
          color: AppColors.surface,
        ),
      );

  /// Material dark theme
  static ThemeData get materialDark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
      );
}
