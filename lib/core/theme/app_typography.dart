/// Big Tech Level Typography System
/// Comprehensive typography system following Apple/Google design standards
/// Uses FIXED sizing for web/desktop, responsive only for mobile
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../utils/responsive_text.dart';

class AppTypography {
  // Font Family
  static const String fontFamily = 'SF Pro Display'; // iOS style
  static const String fallbackFontFamily = 'Roboto'; // Android fallback

  // Display Styles - For large hero text
  static const TextStyle display1 = TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.1,
    color: HvacColors.textPrimary,
  );

  static const TextStyle display2 = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.0,
    height: 1.15,
    color: HvacColors.textPrimary,
  );

  static const TextStyle display3 = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.8,
    height: 1.2,
    color: HvacColors.textPrimary,
  );

  // Headlines - For section headers
  static const TextStyle h1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: HvacColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.25,
    color: HvacColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
    color: HvacColors.textPrimary,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.35,
    color: HvacColors.textPrimary,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
    color: HvacColors.textPrimary,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
    color: HvacColors.textPrimary,
  );

  // Body Text - For content
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: HvacColors.textPrimary,
  );

  static const TextStyle bodyLargeMedium = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.5,
    color: HvacColors.textPrimary,
  );

  static const TextStyle bodyLargeBold = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
    color: HvacColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.5,
    color: HvacColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5,
    color: HvacColors.textPrimary,
  );

  static const TextStyle bodyBold = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.5,
    color: HvacColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.45,
    color: HvacColors.textPrimary,
  );

  static const TextStyle bodySmallMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.45,
    color: HvacColors.textPrimary,
  );

  static const TextStyle bodySmallBold = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.45,
    color: HvacColors.textPrimary,
  );

  // Captions - For secondary text
  static const TextStyle caption = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.4,
    color: HvacColors.textSecondary,
  );

  static const TextStyle captionMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    height: 1.4,
    color: HvacColors.textSecondary,
  );

  static const TextStyle captionBold = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.4,
    color: HvacColors.textSecondary,
  );

  static const TextStyle captionSmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.35,
    color: HvacColors.textSecondary,
  );

  // Labels - For UI elements
  static const TextStyle label = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.3,
    color: HvacColors.textSecondary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.3,
    color: HvacColors.textSecondary,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.3,
    color: HvacColors.textPrimary,
  );

  // Buttons - For interactive elements
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
    color: HvacColors.textPrimary,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
    color: HvacColors.textPrimary,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
    color: HvacColors.textPrimary,
  );

  // Numbers - For metrics and values
  static const TextStyle numberLarge = TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.w300,
    letterSpacing: -1,
    height: 1.0,
    color: HvacColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle numberMedium = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
    height: 1.0,
    color: HvacColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle numberSmall = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.0,
    color: HvacColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // Temperature Display - Special style for temperature values
  static const TextStyle temperatureDisplay = TextStyle(
    fontSize: 72.0,
    fontWeight: FontWeight.w200,
    letterSpacing: -2,
    height: 0.9,
    color: HvacColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle temperatureUnit = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w300,
    letterSpacing: 0,
    height: 1.0,
    color: HvacColors.textSecondary,
  );

  // Overline - For small labels above content
  static const TextStyle overline = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.2,
    color: HvacColors.textSecondary,
  );

  // Code - For technical text
  static const TextStyle code = TextStyle(
    fontSize: 14.0,
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
    return style.copyWith(fontSize: size);
  }

  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(
      color: style.color?.withValues(alpha: opacity),
    );
  }

  // Responsive text styles - uses breakpoint-based sizing
  static TextStyle responsive(
    BuildContext context, {
    required TextStyle mobile,
    required TextStyle desktop,
  }) {
    if (ResponsiveLayout.isDesktop(context)) {
      return desktop;
    } else {
      return mobile;
    }
  }

  // Adaptive variants for common text styles
  static TextStyle adaptiveH1(BuildContext context) {
    return responsive(context, mobile: h2, desktop: h1);
  }

  static TextStyle adaptiveH2(BuildContext context) {
    return responsive(context, mobile: h3, desktop: h2);
  }

  static TextStyle adaptiveH3(BuildContext context) {
    return responsive(context, mobile: h4, desktop: h3);
  }

  static TextStyle adaptiveBody(BuildContext context) {
    return responsive(context, mobile: bodySmall, desktop: body);
  }

  static TextStyle adaptiveBodyLarge(BuildContext context) {
    return responsive(context, mobile: body, desktop: bodyLarge);
  }
}
