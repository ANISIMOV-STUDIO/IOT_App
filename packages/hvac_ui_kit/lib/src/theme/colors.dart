/// HVAC UI Kit - Color Palette
///
/// Corporate color system: White & Deep Blue
/// Philosophy: Professional, clean, trustworthy
library;

import 'package:flutter/material.dart';

/// Professional color palette for HVAC UI Kit
///
/// Based on corporate identity: White & Deep Blue
/// Inspired by: Modern corporate dashboards, professional tools
class HvacColors {
  HvacColors._(); // Private constructor

  // ============================================================================
  // CORPORATE PRIMARY COLORS - White & Deep Blue
  // ============================================================================

  /// Corporate primary color - Deep Navy Blue
  static const Color primary = Color(0xFF0A2647); // Deep Navy Blue

  /// Primary dark variant
  static const Color primaryDark = Color(0xFF051729); // Darker Navy

  /// Primary light variant
  static const Color primaryLight = Color(0xFF144272); // Lighter Navy

  /// Primary extra light
  static const Color primaryExtraLight = Color(0xFF205295); // Sky Blue

  /// Corporate secondary color - Pure White
  static const Color secondary = Color(0xFFFFFFFF); // Pure White

  /// Secondary with slight tint
  static const Color secondaryTint = Color(0xFFF8FAFC); // Barely tinted white

  // ============================================================================
  // ACCENT COLORS - Modern Blue Palette
  // ============================================================================

  /// Main accent color - Bright Blue
  static const Color accent = Color(0xFF2C7BE5); // Vibrant Blue

  /// Dark variant of accent
  static const Color accentDark = Color(0xFF1A5CB8); // Deep Blue

  /// Light variant of accent
  static const Color accentLight = Color(0xFF5A9FFF); // Light Blue

  /// Subtle accent with transparency
  static const Color accentSubtle = Color(0x332C7BE5); // 20% opacity

  // ============================================================================
  // BACKGROUNDS - Blue Gradient
  // ============================================================================

  /// Primary dark background - Deep Navy
  static const Color backgroundDark = Color(0xFF0A2647);

  /// Card background - Navy with slight lightness
  static const Color backgroundCard = Color(0xFF0F3460);

  /// Card border color
  static const Color backgroundCardBorder = Color(0xFF1A4680);

  /// Elevated surface background
  static const Color backgroundElevated = Color(0xFF144272);

  /// Light background for contrast sections
  static const Color backgroundLight = Color(0xFFF5F7FA);

  // ============================================================================
  // TEXT - Optimized for white & dark backgrounds
  // ============================================================================

  /// Primary text color (white for dark backgrounds)
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary text color (slightly transparent white)
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% White

  /// Tertiary text color
  static const Color textTertiary = Color(0x80FFFFFF); // 50% White

  /// Disabled text color
  static const Color textDisabled = Color(0x40FFFFFF); // 25% White

  /// Text for light backgrounds
  static const Color textDark = Color(0xFF0A2647); // Navy text

  /// Secondary text for light backgrounds
  static const Color textDarkSecondary = Color(0x800A2647); // 50% Navy

  // ============================================================================
  // BLUE SHADES - For data visualization & UI elements
  // ============================================================================

  /// Extra light blue
  static const Color blue50 = Color(0xFFE3F2FD);

  /// Light blue
  static const Color blue100 = Color(0xFFBBDEFB);

  /// Medium light blue
  static const Color blue200 = Color(0xFF90CAF9);

  /// Medium blue
  static const Color blue300 = Color(0xFF64B5F6);

  /// Medium dark blue
  static const Color blue400 = Color(0xFF42A5F5);

  /// Dark blue
  static const Color blue500 = Color(0xFF2C7BE5);

  /// Extra dark blue
  static const Color blue600 = Color(0xFF1E5DB5);

  /// Deep blue
  static const Color blue700 = Color(0xFF144272);

  /// Navy blue
  static const Color blue800 = Color(0xFF0F3460);

  /// Deep navy
  static const Color blue900 = Color(0xFF0A2647);

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

  /// Legacy compatibility - now maps to accent
  static const Color primaryOrange = Color(0xFF2C7BE5); // Mapped to blue
  static const Color primaryOrangeDark = Color(0xFF1A5CB8);
  static const Color primaryOrangeLight = Color(0xFF5A9FFF);

  /// Primary blue (main accent)
  static const Color primaryBlue = accent;

  /// Preset colors
  static const Color presetOrange = Color(0xFF2C7BE5); // Now blue
  static const Color presetDeepOrange = Color(0xFF1A5CB8); // Dark blue

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

  /// Neutral shades (blue-tinted)
  static const Color neutral100 = blue200;
  static const Color neutral200 = blue300;
  static const Color neutral300 = blue500;
  static const Color neutral400 = blue700;

  // ============================================================================
  // GLASSMORPHISM - Frosted Glass & Shimmer Effects
  // ============================================================================

  /// Pure white for glass elements
  static const Color glassWhite = Color(0xFFFFFFFF);

  /// Very light for glass
  static const Color glassLight = Color(0xFFF8FAFC);

  /// Glass border color (30% white)
  static const Color glassBorder = Color(0x4DFFFFFF);

  /// Subtle border color
  static const Color borderSubtle = Color(0x1AFFFFFF); // 10% white

  /// Accent orange light (legacy mapping to blue)
  static const Color accentOrangeLight = accentLight;

  /// Shimmer base color (15% white)
  static const Color glassShimmerBase = Color(0x26FFFFFF);

  /// Shimmer highlight color (40% white)
  static const Color glassShimmerHighlight = Color(0x66FFFFFF);

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
  // GRADIENTS - Blue themed
  // ============================================================================

  /// Primary gradient (blue shades)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient (vibrant blues)
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle background gradient
  static const LinearGradient subtleGradient = LinearGradient(
    colors: [backgroundCard, backgroundElevated],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Glass gradient for frosted effect
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x26FFFFFF), // 15% white
      Color(0x0DFFFFFF), // 5% white
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Corporate gradient (navy to blue)
  static const LinearGradient corporateGradient = LinearGradient(
    colors: [primaryDark, accent],
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
    return isDark(background) ? textPrimary : textDark;
  }

  /// Get secondary text color for background
  static Color getSecondaryTextForBackground(Color background) {
    return isDark(background) ? textSecondary : textDarkSecondary;
  }
}
