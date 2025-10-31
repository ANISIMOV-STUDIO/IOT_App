/// Smart Home App Theme
/// Based on Figma design with dark background and orange accents
library;

import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors - From Figma Design
  static const Color primaryOrange = Color(0xFFFFB267); // #ffb267
  static const Color primaryOrangeDark = Color(0xFFE8A055);
  static const Color primaryOrangeLight = Color(0xFFFFCEA0); // rgba(255, 206, 160, 0.7)
  static const Color primaryOrangeBorder = Color(0x99FFB267); // rgba(255, 178, 103, 0.6)

  // Background Colors - From Figma Design
  static const Color backgroundDark = Color(0xFF211D1D); // #211d1d
  static const Color backgroundCard = Color(0xFF282424); // #282424
  static const Color backgroundCardBorder = Color(0xFF393535); // #393535

  // Text Colors - From Figma Design
  static const Color textPrimary = Color(0xFFF8F8F8); // #f8f8f8
  static const Color textSecondary = Color(0x99FFFFFF); // rgba(255, 255, 255, 0.6)
  static const Color textTertiary = Color(0x66FFFFFF); // rgba(255, 255, 255, 0.4)

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF42A5F5);

  // Device Mode Colors
  static const Color modeCool = Color(0xFF42A5F5);
  static const Color modeHeat = Color(0xFFEF5350);
  static const Color modeFan = Color(0xFF66BB6A);
  static const Color modeDry = Color(0xFFFFCA28);
  static const Color modeAuto = Color(0xFFAB47BC);

  /// Dark Theme
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryOrange,
        secondary: primaryOrangeLight,
        surface: backgroundCard,
        error: error,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onError: textPrimary,
      ),

      scaffoldBackgroundColor: backgroundDark,

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: backgroundCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: backgroundCardBorder,
            width: 1,
          ),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundDark,
        selectedItemColor: primaryOrange,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textTertiary,
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: backgroundCardBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: backgroundCardBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryOrange,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: error,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Switch Theme - Orange Rounded Toggle
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryOrange;
          }
          return backgroundCardBorder;
        }),
      ),

      // Slider Theme - Orange Slider
      sliderTheme: const SliderThemeData(
        activeTrackColor: primaryOrange,
        inactiveTrackColor: backgroundCardBorder,
        thumbColor: Colors.white,
        overlayColor: Color(0x33FF9D5C),
        trackHeight: 4,
      ),
    );
  }

  /// Get color for device mode
  static Color getModeColor(String mode) {
    switch (mode.toLowerCase()) {
      case 'cool':
      case 'cooling':
        return modeCool;
      case 'heat':
      case 'heating':
        return modeHeat;
      case 'fan':
      case 'fan_only':
        return modeFan;
      case 'dry':
        return modeDry;
      case 'auto':
        return modeAuto;
      default:
        return primaryOrange;
    }
  }

  /// Device Card Decoration
  static BoxDecoration deviceCard({bool isSelected = false}) {
    return BoxDecoration(
      color: backgroundCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isSelected ? primaryOrange : backgroundCardBorder,
        width: isSelected ? 2 : 1,
      ),
    );
  }

  /// Orange Button Decoration
  static BoxDecoration orangeButton() {
    return BoxDecoration(
      color: primaryOrange,
      borderRadius: BorderRadius.circular(12),
    );
  }

  /// Device Image Placeholder
  static BoxDecoration deviceImagePlaceholder() {
    return BoxDecoration(
      color: backgroundCard,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: backgroundCardBorder,
        width: 1,
      ),
    );
  }
}
