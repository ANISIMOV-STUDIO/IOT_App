/// Application Theme Configuration
///
/// Modern theme with dark mode support, gradients, and glassmorphism
library;

import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors - Modern purple/blue gradient
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Accent colors
  static const Color accentColor = Color(0xFF06B6D4); // Cyan
  static const Color secondaryColor = Color(0xFF10B981); // Emerald

  // Temperature mode colors with gradients
  static const Color coolColor = Color(0xFF3B82F6); // Blue
  static const Color coolColorLight = Color(0xFF60A5FA);
  static const Color coolColorDark = Color(0xFF2563EB);

  static const Color heatColor = Color(0xFFEF4444); // Red
  static const Color heatColorLight = Color(0xFFF87171);
  static const Color heatColorDark = Color(0xFFDC2626);

  static const Color autoColor = Color(0xFF10B981); // Emerald
  static const Color autoColorLight = Color(0xFF34D399);
  static const Color autoColorDark = Color(0xFF059669);

  static const Color fanColor = Color(0xFF8B5CF6); // Violet
  static const Color fanColorLight = Color(0xFFA78BFA);
  static const Color fanColorDark = Color(0xFF7C3AED);

  // Light theme colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);

  // Text colors
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextHint = Color(0xFF94A3B8);

  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextHint = Color(0xFF94A3B8);

  // Success, Warning, Error
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);

  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        tertiary: secondaryColor,
        error: errorColor,
        surface: lightSurface,
        background: lightBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
        onBackground: lightTextPrimary,
      ),
      scaffoldBackgroundColor: lightBackground,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: lightTextPrimary,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
          letterSpacing: -0.5,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: lightBorder.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: lightTextSecondary,
        size: 24,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: lightTextPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: lightTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: lightTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: lightTextSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: lightTextHint,
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: lightBorder.withOpacity(0.5),
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryLight,
        secondary: accentColor,
        tertiary: secondaryColor,
        error: errorColor,
        surface: darkSurface,
        background: darkBackground,
        onPrimary: darkBackground,
        onSecondary: darkBackground,
        onSurface: darkTextPrimary,
        onBackground: darkTextPrimary,
      ),
      scaffoldBackgroundColor: darkBackground,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: darkTextPrimary,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
          letterSpacing: -0.5,
        ),
      ),

      // Card Theme with glassmorphism effect
      cardTheme: CardThemeData(
        color: darkCard.withOpacity(0.7),
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: darkBorder.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryLight,
          foregroundColor: darkBackground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: darkTextSecondary,
        size: 24,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: darkTextSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: darkTextHint,
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: darkBorder.withOpacity(0.3),
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Get gradient for HVAC mode
  static LinearGradient getModeGradient(String mode, {bool isDark = false}) {
    switch (mode.toLowerCase()) {
      case 'cooling':
        return LinearGradient(
          colors: isDark
              ? [coolColorDark, coolColor]
              : [coolColor, coolColorLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'heating':
        return LinearGradient(
          colors: isDark
              ? [heatColorDark, heatColor]
              : [heatColor, heatColorLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'auto':
        return LinearGradient(
          colors: isDark
              ? [autoColorDark, autoColor]
              : [autoColor, autoColorLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'fan':
        return LinearGradient(
          colors: isDark
              ? [fanColorDark, fanColor]
              : [fanColor, fanColorLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: isDark
              ? [darkTextSecondary, darkTextHint]
              : [lightTextSecondary, lightTextHint],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  /// Get color for HVAC mode
  static Color getModeColor(String mode) {
    switch (mode.toLowerCase()) {
      case 'cooling':
        return coolColor;
      case 'heating':
        return heatColor;
      case 'auto':
        return autoColor;
      case 'fan':
        return fanColor;
      default:
        return lightTextSecondary;
    }
  }

  /// Get icon for HVAC mode
  static IconData getModeIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'cooling':
        return Icons.ac_unit_rounded;
      case 'heating':
        return Icons.local_fire_department_rounded;
      case 'auto':
        return Icons.autorenew_rounded;
      case 'fan':
        return Icons.air_rounded;
      default:
        return Icons.device_thermostat_rounded;
    }
  }

  /// Get subtle shadow for cards (light theme)
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  /// Get glassmorphism effect for dark cards
  static BoxDecoration glassmorphicCard({
    required bool isDark,
    Color? color,
    double borderRadius = 20,
  }) {
    return BoxDecoration(
      color: color ?? (isDark ? darkCard.withOpacity(0.5) : lightCard),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
        width: 1,
      ),
      boxShadow: isDark
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ]
          : cardShadow,
    );
  }
}
