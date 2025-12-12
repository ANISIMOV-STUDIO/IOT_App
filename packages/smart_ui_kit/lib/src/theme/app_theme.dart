import 'package:flutter/material.dart';
import 'tokens/app_colors.dart';

class AppTheme {
  static ThemeData get light => _createTheme(AppColors.lightScheme);
  static ThemeData get dark => _createTheme(AppColors.darkScheme);

  static ThemeData _createTheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.brightness == Brightness.light
          ? const Color(0xFFF1F5F9) // Slate 100 (Darker than before for card contrast)
          : const Color(0xFF0F172A), // Dark slate

      // Card Theme
      // cardTheme: CardTheme(
      //   color: scheme.surface,
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(16),
      //     side: BorderSide(
      //       color: scheme.outline,
      //       width: 1,
      //     ),
      //   ),
      // ),

      // Button Themes for SmartButton consistency
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: scheme.primary.withAlpha(77),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: scheme.primary, width: 1.5),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Theme (Hooking up typography)
      // We would ideally map AppTypography here completely
    );
  }
}
