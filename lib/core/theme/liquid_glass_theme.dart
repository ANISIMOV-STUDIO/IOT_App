/// iOS 26 Liquid Glass Theme
///
/// Modern translucent glass-like design with blur effects
library;

import 'package:flutter/material.dart';
import 'dart:ui';

class LiquidGlassTheme {
  // iOS 26 Liquid Glass Base Colors
  static const Color glassBlue = Color(0xFF007AFF);
  static const Color glassPurple = Color(0xFF5E5CE6);
  static const Color glassTeal = Color(0xFF5AC8FA);
  static const Color glassGreen = Color(0xFF34C759);
  static const Color glassOrange = Color(0xFFFF9500);
  static const Color glassRed = Color(0xFFFF3B30);
  static const Color glassPink = Color(0xFFFF2D55);

  // Temperature mode colors
  static const Color coolGlass = Color(0xFF30A9FF);
  static const Color heatGlass = Color(0xFFFF6B6B);
  static const Color autoGlass = Color(0xFF32D74B);
  static const Color fanGlass = Color(0xFF7B68EE);
  static const Color dryGlass = Color(0xFFFFB627);

  // Background gradients - Darker for better glass contrast
  static const List<Color> darkGradient = [
    Color(0xFF000000),  // Pure black for maximum glass effect
    Color(0xFF0A0E1A),
    Color(0xFF151923),
  ];

  static const List<Color> lightGradient = [
    Color(0xFFF5F7FA),
    Color(0xFFE8EBF0),
    Color(0xFFDBE0E8),
  ];

  // Glass material colors with transparency
  static Color glassLight(double opacity) =>
      Colors.white.withValues(alpha: opacity);

  static Color glassDark(double opacity) =>
      Colors.black.withValues(alpha: opacity);

  /// Create Liquid Glass effect container decoration
  static BoxDecoration liquidGlass({
    required bool isDark,
    double opacity = 0.08,  // Lighter for more transparency
    double blur = 10,       // Optimal blur range 5-15
    List<Color>? gradient,
    Color? borderColor,
    double borderWidth = 0.5,  // Thinner borders
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient: gradient != null
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            )
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                // More transparent in dark theme for lightness
                (isDark ? glassLight(opacity) : glassDark(opacity * 0.6)),
                (isDark ? glassLight(opacity * 0.5) : glassDark(opacity * 0.4)),
              ],
            ),
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      border: Border.all(
        color: borderColor ??
            (isDark
                ? Colors.white.withValues(alpha: 0.12)  // More subtle borders
                : Colors.black.withValues(alpha: 0.08)),
        width: borderWidth,
      ),
      boxShadow: [
        // Softer shadows for lightness
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.08),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
        // Subtle highlight
        BoxShadow(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.8),
          blurRadius: 8,
          offset: const Offset(-3, -3),
        ),
      ],
    );
  }

  /// Backdrop blur filter for glass effect
  /// Optimal blur range: 5-15 sigma for best performance and appearance
  static ImageFilter backdropBlur({double sigma = 10}) {
    return ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);
  }

  /// Light Theme with Liquid Glass
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: ColorScheme.light(
        primary: glassBlue,
        secondary: glassTeal,
        tertiary: glassPurple,
        error: glassRed,
        surface: lightGradient[0],
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1C1C1E),
      ),

      scaffoldBackgroundColor: lightGradient[0],

      // App Bar Theme - Translucent
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1C1C1E),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1C1E),
          letterSpacing: -0.5,
        ),
      ),

      // Card Theme - Glass effect
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.7),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),

      // Text Theme - San Francisco style
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1C1C1E),
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1C1E),
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1C1E),
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1C1E),
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1C1C1E),
          letterSpacing: -0.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color(0xFF3C3C43),
          letterSpacing: -0.2,
        ),
        labelLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1C1E),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: Color(0xFF1C1C1E),
        size: 24,
      ),
    );
  }

  /// Dark Theme with Liquid Glass
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: ColorScheme.dark(
        primary: glassBlue,
        secondary: glassTeal,
        tertiary: glassPurple,
        error: glassRed,
        surface: darkGradient[0],
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFFF5F5F7),
      ),

      scaffoldBackgroundColor: darkGradient[0],

      // App Bar Theme - Translucent
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFF5F5F7),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF5F5F7),
          letterSpacing: -0.5,
        ),
      ),

      // Card Theme - Glass effect
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),

      // Text Theme - San Francisco style
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: Color(0xFFF5F5F7),
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF5F5F7),
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF5F5F7),
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF5F5F7),
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: Color(0xFFF5F5F7),
          letterSpacing: -0.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color(0xFFAEAEB2),
          letterSpacing: -0.2,
        ),
        labelLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF5F5F7),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: Color(0xFFF5F5F7),
        size: 24,
      ),
    );
  }

  /// Temperature mode gradient colors
  static List<Color> getModeGradient(String mode, {bool isDark = true}) {
    switch (mode.toLowerCase()) {
      case 'cooling':
      case 'cool':
        return isDark
            ? [const Color(0xFF0A84FF), const Color(0xFF64D2FF)]
            : [const Color(0xFF007AFF), const Color(0xFF5AC8FA)];
      case 'heating':
      case 'heat':
        return isDark
            ? [const Color(0xFFFF453A), const Color(0xFFFF9F0A)]
            : [const Color(0xFFFF3B30), const Color(0xFFFF9500)];
      case 'auto':
        return isDark
            ? [const Color(0xFF30D158), const Color(0xFF64D2FF)]
            : [const Color(0xFF34C759), const Color(0xFF5AC8FA)];
      case 'fan':
        return isDark
            ? [const Color(0xFFBF5AF2), const Color(0xFF64D2FF)]
            : [const Color(0xFFAF52DE), const Color(0xFF5AC8FA)];
      case 'dry':
        return isDark
            ? [const Color(0xFFFFD60A), const Color(0xFFFF9F0A)]
            : [const Color(0xFFFFCC00), const Color(0xFFFF9500)];
      default:
        return isDark
            ? [const Color(0xFF007AFF), const Color(0xFF5E5CE6)]
            : [const Color(0xFF007AFF), const Color(0xFF5856D6)];
    }
  }
}
