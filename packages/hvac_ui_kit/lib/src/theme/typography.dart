/// HVAC UI Kit - Typography System
///
/// Professional text styles with responsive sizing
library;

import 'package:flutter/material.dart';
import 'colors.dart';

/// Typography system for HVAC UI Kit
class HvacTypography {
  HvacTypography._(); // Private constructor

  // ============================================================================
  // DISPLAY STYLES - Large headings
  // ============================================================================

  static TextStyle get displayLarge => TextStyle(
        fontSize: 57.0,
        fontWeight: FontWeight.w700,
        color: HvacColors.textPrimary,
        letterSpacing: -0.25,
        height: 1.1,
      );

  static TextStyle get displayMedium => TextStyle(
        fontSize: 45.0,
        fontWeight: FontWeight.w700,
        color: HvacColors.textPrimary,
        height: 1.15,
      );

  static TextStyle get displaySmall => TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textPrimary,
        height: 1.2,
      );

  // ============================================================================
  // HEADLINE STYLES - Section headers
  // ============================================================================

  static TextStyle get headlineLarge => TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textPrimary,
        height: 1.25,
      );

  static TextStyle get headlineMedium => TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineSmall => TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textPrimary,
        height: 1.3,
      );

  // ============================================================================
  // TITLE STYLES - Component headers
  // ============================================================================

  static TextStyle get titleLarge => TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textPrimary,
        height: 1.35,
      );

  static TextStyle get titleMedium => TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get titleSmall => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textPrimary,
        height: 1.4,
      );

  // ============================================================================
  // BODY STYLES - Content text
  // ============================================================================

  static TextStyle get bodyLarge => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: HvacColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: HvacColors.textSecondary,
        height: 1.5,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        color: HvacColors.textTertiary,
        height: 1.5,
      );

  // ============================================================================
  // LABEL STYLES - UI labels and buttons
  // ============================================================================

  static TextStyle get labelLarge => TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textPrimary,
        letterSpacing: 0.1,
      );

  static TextStyle get labelMedium => TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: HvacColors.textPrimary,
        letterSpacing: 0.1,
      );

  static TextStyle get labelSmall => TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        color: HvacColors.textSecondary,
        letterSpacing: 0.1,
      );

  // ============================================================================
  // CUSTOM STYLES
  // ============================================================================

  /// Caption text
  static TextStyle get caption => TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        color: HvacColors.textTertiary,
        letterSpacing: 0.4,
      );

  /// Caption medium weight
  static TextStyle get captionMedium => TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        color: HvacColors.textSecondary,
        letterSpacing: 0.4,
      );

  /// Caption small
  static TextStyle get captionSmall => TextStyle(
        fontSize: 11.0,
        fontWeight: FontWeight.w400,
        color: HvacColors.textTertiary,
        letterSpacing: 0.4,
      );

  /// Caption bold
  static TextStyle get captionBold => TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textSecondary,
        letterSpacing: 0.4,
      );

  /// Label text (alias for labelSmall)
  static TextStyle get label => labelSmall;

  /// Overline text (all caps labels)
  static TextStyle get overline => TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textTertiary,
        letterSpacing: 1.5,
      );

  /// Button text
  static TextStyle get button => TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textPrimary,
        letterSpacing: 0.5,
      );

  /// Button medium
  static TextStyle get buttonMedium => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textPrimary,
        letterSpacing: 0.5,
      );

  // ============================================================================
  // HEADLINE ALIASES (h1-h6)
  // ============================================================================

  /// h1 - Alias for headlineLarge
  static TextStyle get h1 => headlineLarge;

  /// h2 - Alias for headlineMedium
  static TextStyle get h2 => headlineMedium;

  /// h3 - Alias for headlineSmall
  static TextStyle get h3 => headlineSmall;

  /// h4 - 20sp
  static TextStyle get h4 => TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textPrimary,
        height: 1.35,
      );

  /// h5 - 18sp
  static TextStyle get h5 => TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: HvacColors.textPrimary,
        height: 1.4,
      );

  /// h6 - Alias for titleSmall
  static TextStyle get h6 => titleSmall;

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Create Material TextTheme
  static TextTheme createTextTheme() {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }
}
