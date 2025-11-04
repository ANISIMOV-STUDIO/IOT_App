/// Big Tech Level Typography System
/// Comprehensive typography system following Apple/Google design standards
/// Uses responsive sizing and precise font weights for pixel-perfect UI
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class AppTypography {
  // Font Family
  static const String fontFamily = 'SF Pro Display'; // iOS style
  static const String fallbackFontFamily = 'Roboto'; // Android fallback

  // Display Styles - For large hero text
  static TextStyle display1 = TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.1,
    color: HvacColors.textPrimary,
  );

  static TextStyle display2 = TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.0,
    height: 1.15,
    color: HvacColors.textPrimary,
  );

  static TextStyle display3 = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.8,
    height: 1.2,
    color: HvacColors.textPrimary,
  );

  // Headlines - For section headers
  static TextStyle h1 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: HvacColors.textPrimary,
  );

  static TextStyle h2 = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.25,
    color: HvacColors.textPrimary,
  );

  static TextStyle h3 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
    color: HvacColors.textPrimary,
  );

  static TextStyle h4 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.35,
    color: HvacColors.textPrimary,
  );

  static TextStyle h5 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
    color: HvacColors.textPrimary,
  );

  static TextStyle h6 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
    color: HvacColors.textPrimary,
  );

  // Body Text - For content
  static TextStyle bodyLarge = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: HvacColors.textPrimary,
  );

  static TextStyle bodyLargeMedium = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
    color: HvacColors.textPrimary,
  );

  static TextStyle bodyLargeBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
    color: HvacColors.textPrimary,
  );

  static TextStyle body = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
    color: HvacColors.textPrimary,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
    color: HvacColors.textPrimary,
  );

  static TextStyle bodyBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.5,
    color: HvacColors.textPrimary,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.45,
    color: HvacColors.textPrimary,
  );

  static TextStyle bodySmallMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.45,
    color: HvacColors.textPrimary,
  );

  static TextStyle bodySmallBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.45,
    color: HvacColors.textPrimary,
  );

  // Captions - For secondary text
  static TextStyle caption = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.4,
    color: HvacColors.textSecondary,
  );

  static TextStyle captionMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.4,
    color: HvacColors.textSecondary,
  );

  static TextStyle captionBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.4,
    color: HvacColors.textSecondary,
  );

  static TextStyle captionSmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.35,
    color: HvacColors.textSecondary,
  );

  // Labels - For UI elements
  static TextStyle label = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.3,
    color: HvacColors.textSecondary,
  );

  static TextStyle labelMedium = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.3,
    color: HvacColors.textSecondary,
  );

  static TextStyle labelLarge = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.3,
    color: HvacColors.textPrimary,
  );

  // Buttons - For interactive elements
  static TextStyle buttonLarge = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
    color: HvacColors.textPrimary,
  );

  static TextStyle buttonMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
    color: HvacColors.textPrimary,
  );

  static TextStyle buttonSmall = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
    color: HvacColors.textPrimary,
  );

  // Numbers - For metrics and values
  static TextStyle numberLarge = TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w300,
    letterSpacing: -1,
    height: 1.0,
    color: HvacColors.textPrimary,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle numberMedium = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
    height: 1.0,
    color: HvacColors.textPrimary,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle numberSmall = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.0,
    color: HvacColors.textPrimary,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  // Temperature Display - Special style for temperature values
  static TextStyle temperatureDisplay = TextStyle(
    fontSize: 72.sp,
    fontWeight: FontWeight.w200,
    letterSpacing: -2,
    height: 0.9,
    color: HvacColors.textPrimary,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle temperatureUnit = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w300,
    letterSpacing: 0,
    height: 1.0,
    color: HvacColors.textSecondary,
  );

  // Overline - For small labels above content
  static TextStyle overline = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.2,
    color: HvacColors.textSecondary,
  );

  // Code - For technical text
  static TextStyle code = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    color: HvacColors.primaryOrange,
    fontFamily: 'JetBrains Mono',
  );

  // Helper methods
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size.sp);
  }

  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(
      color: style.color?.withValues(alpha: opacity),
    );
  }

  // Responsive text styles based on screen size (mobile and tablet only)
  static TextStyle responsive({
    required TextStyle mobile,
    TextStyle? tablet,
  }) {
    final screenWidth = 1.sw;

    if (screenWidth >= 600 && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
