import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'neumorphic_colors.dart';

/// Neumorphic Typography System
/// Clean, modern font styles for Smart Home UI
class NeumorphicTypography {
  final bool isDark;
  
  const NeumorphicTypography._({required this.isDark});
  
  static const light = NeumorphicTypography._(isDark: false);
  static const dark = NeumorphicTypography._(isDark: true);

  // ============================================
  // COLOR GETTERS
  // ============================================
  
  Color get textPrimary => isDark 
      ? NeumorphicColors.darkTextPrimary 
      : NeumorphicColors.lightTextPrimary;
      
  Color get textSecondary => isDark 
      ? NeumorphicColors.darkTextSecondary 
      : NeumorphicColors.lightTextSecondary;
      
  Color get textTertiary => isDark 
      ? NeumorphicColors.darkTextTertiary 
      : NeumorphicColors.lightTextTertiary;

  // ============================================
  // BASE TEXT STYLES (using Inter/Poppins)
  // ============================================
  
  /// Extra large display (Temperature numbers)
  TextStyle get displayLarge => GoogleFonts.poppins(
    fontSize: 64,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.1,
    letterSpacing: -2,
  );

  /// Large display (Section headers)
  TextStyle get displayMedium => GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
    letterSpacing: -1,
  );

  /// Medium display
  TextStyle get displaySmall => GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.2,
  );

  // ============================================
  // HEADINGS
  // ============================================

  /// H1 - Page titles
  TextStyle get headlineLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  /// H2 - Section titles
  TextStyle get headlineMedium => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  /// H3 - Card titles
  TextStyle get headlineSmall => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  // ============================================
  // TITLES (Component level)
  // ============================================

  /// Card title
  TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  /// Device name
  TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  /// Small title
  TextStyle get titleSmall => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  // ============================================
  // BODY TEXT
  // ============================================

  /// Primary body text
  TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );

  /// Secondary body text
  TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
  );

  /// Small body text
  TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
  );

  // ============================================
  // LABELS & CAPTIONS
  // ============================================

  /// Button label
  TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  /// Small label
  TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  /// Caption / Hint text
  TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: textTertiary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // ============================================
  // SPECIAL STYLES
  // ============================================

  /// Large numeric value (kWh, percentage)
  TextStyle get numericLarge => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
  );

  /// Medium numeric value
  TextStyle get numericMedium => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.2,
  );

  /// Small numeric value
  TextStyle get numericSmall => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textSecondary,
    height: 1.2,
  );

  /// Unit suffix (kWh, %, ppm)
  TextStyle get unit => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textTertiary,
    height: 1.2,
  );

  /// Status indicator text
  TextStyle get status => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.4,
  );
}
