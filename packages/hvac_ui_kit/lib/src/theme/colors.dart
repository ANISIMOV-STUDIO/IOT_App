/// HVAC UI Kit - Color Palette
///
/// Corporate color system: Blue & White (50/50 balance)
/// Philosophy: Professional, clean, balanced, modern
library;

import 'package:flutter/material.dart';

/// Professional color palette for HVAC UI Kit
///
/// Based on corporate identity: Blue & White on equal footing
/// Design principle: Light backgrounds with blue accents, not dark blue everywhere
class HvacColors {
  HvacColors._(); // Private constructor

  // ============================================================================
  // CORPORATE PRIMARY COLORS - Blue & White (Equal Partners)
  // ============================================================================

  /// Corporate primary color - Professional Blue
  static const Color primary = Color(0xFF2563EB); // Vibrant Blue (not navy!)

  /// Primary dark variant
  static const Color primaryDark = Color(0xFF1E40AF); // Deep Blue

  /// Primary light variant
  static const Color primaryLight = Color(0xFF60A5FA); // Light Blue

  /// Primary extra light
  static const Color primaryExtraLight = Color(0xFFDCEEFF); // Very Light Blue

  /// Corporate secondary color - Pure White
  static const Color secondary = Color(0xFFFFFFFF); // Pure White

  /// Secondary with slight tint
  static const Color secondaryTint = Color(0xFFF8FAFC); // Barely tinted white

  // ============================================================================
  // ACCENT COLORS - Modern Blue Palette
  // ============================================================================

  /// Main accent color - Same as primary
  static const Color accent = primary;

  /// Dark variant of accent
  static const Color accentDark = primaryDark;

  /// Light variant of accent
  static const Color accentLight = primaryLight;

  /// Subtle accent with transparency
  static const Color accentSubtle = Color(0x332563EB); // 20% opacity

  // ============================================================================
  // BACKGROUNDS - Light theme with blue accents (NOT dark blue!)
  // ============================================================================

  /// Primary background - Clean White
  static const Color backgroundPrimary = Color(0xFFFFFFFF);

  /// Secondary background - Very Light Gray
  static const Color backgroundSecondary = Color(0xFFF8FAFC);

  /// Card background - Pure White with elevation
  static const Color backgroundCard = Color(0xFFFFFFFF);

  /// Card border color - Light Gray
  static const Color backgroundCardBorder = Color(0xFFE2E8F0);

  /// Elevated surface background - Subtle Gray
  static const Color backgroundElevated = Color(0xFFFAFAFB);

  /// Dark background (for special sections only) - Soft Dark Gray
  static const Color backgroundDark = Color(0xFF1E293B);

  /// Light background for contrast sections
  static const Color backgroundLight = Color(0xFFF5F7FA);

  // ============================================================================
  // TEXT - Optimized for LIGHT backgrounds (primary use case)
  // ============================================================================

  /// Primary text color - Dark Gray (for light backgrounds)
  static const Color textPrimary = Color(0xFF0F172A);

  /// Secondary text color - Medium Gray
  static const Color textSecondary = Color(0xFF64748B);

  /// Tertiary text color - Light Gray
  static const Color textTertiary = Color(0xFF94A3B8);

  /// Disabled text color - Very Light Gray
  static const Color textDisabled = Color(0xFFCBD5E1);

  /// Text for light backgrounds (alias for consistency)
  static const Color textDark = textPrimary;

  /// Secondary text for light backgrounds
  static const Color textDarkSecondary = textSecondary;

  /// Text for dark backgrounds - White
  static const Color textLight = Color(0xFFFFFFFF);

  /// Secondary text for dark backgrounds
  static const Color textLightSecondary = Color(0xB3FFFFFF); // 70% White

  // ============================================================================
  // BLUE SHADES - Professional Blue Scale
  // ============================================================================

  /// Extra light blue - backgrounds
  static const Color blue50 = Color(0xFFEFF6FF);

  /// Light blue - hover states
  static const Color blue100 = Color(0xFFDBEAFE);

  /// Medium light blue - subtle accents
  static const Color blue200 = Color(0xFFBFDBFE);

  /// Medium blue - icons
  static const Color blue300 = Color(0xFF93C5FD);

  /// Medium dark blue - secondary buttons
  static const Color blue400 = Color(0xFF60A5FA);

  /// Main blue - primary actions
  static const Color blue500 = primary;

  /// Dark blue - hover on primary
  static const Color blue600 = Color(0xFF2563EB);

  /// Deep blue - pressed states
  static const Color blue700 = primaryDark;

  /// Very dark blue - text on light backgrounds
  static const Color blue800 = Color(0xFF1E3A8A);

  /// Deepest blue - special emphasis
  static const Color blue900 = Color(0xFF1E40AF);

  // ============================================================================
  // SEMANTIC COLORS - Professional palette
  // ============================================================================

  /// Success color - Fresh green
  static const Color success = Color(0xFF10B981);
  static const Color successSubtle = Color(0x3310B981);
  static const Color successLight = Color(0xFF34D399);

  /// Error color - Professional red
  static const Color error = Color(0xFFDC2626);
  static const Color errorSubtle = Color(0x33DC2626);
  static const Color errorLight = Color(0xFFEF4444);

  /// Warning color - Warm amber
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSubtle = Color(0x33F59E0B);
  static const Color warningLight = Color(0xFFFBBF24);

  /// Info color - Cool blue (accent)
  static const Color info = Color(0xFF2C7BE5);
  static const Color infoSubtle = Color(0x332C7BE5);
  static const Color infoLight = Color(0xFF60A5FA);

  // ============================================================================
  // AIR QUALITY COLORS - For AQI indicators
  // ============================================================================

  /// Excellent air quality (0-50 AQI)
  static const Color airQualityExcellent = Color(0xFF10B981);

  /// Good air quality (51-100 AQI)
  static const Color airQualityGood = Color(0xFF84CC16);

  /// Fair air quality (101-150 AQI)
  static const Color airQualityFair = Color(0xFFFBBF24);

  /// Poor air quality (151-200 AQI)
  static const Color airQualityPoor = Color(0xFFF97316);

  /// Bad air quality (201+ AQI)
  static const Color airQualityBad = Color(0xFFEF4444);

  // ============================================================================
  // FUNCTIONAL COLORS
  // ============================================================================

  /// Alert/notification color
  static const Color alertLight = Color(0xFFEF4444);

  /// Dashboard accent - green
  static const Color dashboardGreen = Color(0xFF10B981);

  /// Dashboard accent - blue
  static const Color dashboardBlue = Color(0xFF2C7BE5);

  /// Legacy compatibility - maps to primary blue
  static const Color primaryOrange = primary;
  static const Color primaryOrangeDark = primaryDark;
  static const Color primaryOrangeLight = primaryLight;

  /// Primary blue (main corporate color)
  static const Color primaryBlue = primary;

  /// Preset colors (blue)
  static const Color presetOrange = primary;
  static const Color presetDeepOrange = primaryDark;

  /// Alert dark
  static const Color alertDarkRed = Color(0xFFDC2626);

  // ============================================================================
  // MODE COLORS - For HVAC mode indicators
  // ============================================================================

  /// Fan mode color - Light blue
  static const Color modeFan = blue300;

  /// Heat mode color - Warm color (exception to blue theme)
  static const Color modeHeat = Color(0xFFEF4444); // Red for heat

  /// Cool mode color - Cool blue
  static const Color modeCool = blue500;

  // ============================================================================
  // COMPATIBILITY ALIASES
  // ============================================================================

  /// Alias for backgroundCard
  static const Color cardDark = backgroundCard;

  /// Alias for success
  static const Color successGreen = success;

  /// Alias for error
  static const Color errorRed = error;

  /// Neutral shades (gray, not blue!)
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);

  // ============================================================================
  // GLASSMORPHISM - Frosted Glass & Shimmer Effects (Light Theme)
  // ============================================================================

  /// Pure white for glass elements
  static const Color glassWhite = Color(0xFFFFFFFF);

  /// Very light for glass
  static const Color glassLight = Color(0xFFFAFAFB);

  /// Glass border color (subtle gray)
  static const Color glassBorder = Color(0xFFE2E8F0);

  /// Subtle border color
  static const Color borderSubtle = Color(0xFFF1F5F9);

  /// Accent blue light (legacy compatibility)
  static const Color accentOrangeLight = accentLight;

  /// Shimmer base color (very light gray)
  static const Color glassShimmerBase = Color(0xFFF1F5F9);

  /// Shimmer highlight color (white)
  static const Color glassShimmerHighlight = Color(0xFFFFFFFF);

  // ============================================================================
  // BLUR SIGMA VALUES - For BackdropFilter
  // ============================================================================

  /// Light frosted glass blur
  static const double blurLight = 8.0;

  /// Medium frosted glass blur (optimal performance)
  static const double blurMedium = 12.0;

  /// Heavy frosted glass blur
  static const double blurHeavy = 20.0;

  // ============================================================================
  // TEMPERATURE GRADIENT COLORS
  // ============================================================================

  /// Cool temperature indicator - Cool blue
  static const Color tempCold = Color(0xFF60A5FA);

  /// Neutral temperature indicator - Medium blue
  static const Color tempNeutral = Color(0xFF2C7BE5);

  /// Warm temperature indicator - Warm orange (exception)
  static const Color tempWarm = Color(0xFFF59E0B);

  // ============================================================================
  // GRADIENTS - Professional & Clean
  // ============================================================================

  /// Primary gradient (blue shades)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient (vibrant blues)
  static const LinearGradient accentGradient = LinearGradient(
    colors: [primary, blue400],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle background gradient (very light)
  static const LinearGradient subtleGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Glass gradient for frosted effect (light theme)
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0xFFFFFFFF), // White
      Color(0xFFFAFAFB), // Very light gray
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Corporate gradient (blue emphasis)
  static const LinearGradient corporateGradient = LinearGradient(
    colors: [primaryDark, primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

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
        return blue400;
      case 'auto':
        return accent;
      default:
        return accent;
    }
  }

  /// Check if color is dark
  static bool isDark(Color color) {
    return color.computeLuminance() < 0.5;
  }

  /// Get contrasting text color
  static Color getContrastColor(Color background) {
    return isDark(background) ? textPrimary : textDark;
  }

  /// Get appropriate text color for background
  static Color getTextForBackground(Color background) {
    return isDark(background) ? textLight : textPrimary;
  }

  /// Get secondary text color for background
  static Color getSecondaryTextForBackground(Color background) {
    return isDark(background) ? textLightSecondary : textSecondary;
  }
}
