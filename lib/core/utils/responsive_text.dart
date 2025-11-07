/// Fixed Typography System
///
/// Industry-standard responsive text that doesn't scale beyond design specifications
/// Based on Material Design 3 type scale and big tech best practices
library;

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Fixed font sizes that don't scale with screen width
/// These sizes are based on Material Design 3 recommendations
class ResponsiveText {
  ResponsiveText._();

  /// Display sizes - For large, attention-grabbing text
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;

  /// Headline sizes - For page titles and section headers
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;

  /// Title sizes - For card titles and prominent text
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;

  /// Body sizes - For regular content text
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;

  /// Label sizes - For buttons, tags, and labels
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;

  /// Icon sizes - Fixed icon sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconXLarge = 32.0;

  /// Get responsive font size based on breakpoint
  /// Mobile: smaller text for better readability
  /// Tablet/Desktop: standard sizes
  static double getSize(
    BuildContext context, {
    required double mobile,
    required double desktop,
  }) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return mobile;
    }
    return desktop;
  }

  /// Get adaptive text style that changes size based on breakpoint
  static TextStyle adaptive(
    BuildContext context, {
    required double mobileSize,
    required double desktopSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    final size = getSize(context, mobile: mobileSize, desktop: desktopSize);
    return TextStyle(
      fontSize: size,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}

/// Extension for responsive spacing
/// Uses fixed values instead of screen-width-based scaling
extension ResponsiveSpacing on num {
  /// Fixed spacing for mobile
  double get spaceMobile {
    if (this <= 4) return 4.0;
    if (this <= 8) return 8.0;
    if (this <= 12) return 12.0;
    if (this <= 16) return 16.0;
    if (this <= 20) return 20.0;
    if (this <= 24) return 24.0;
    if (this <= 32) return 32.0;
    if (this <= 40) return 40.0;
    if (this <= 48) return 48.0;
    return 64.0;
  }

  /// Fixed spacing for desktop
  double get spaceDesktop {
    if (this <= 4) return 8.0;
    if (this <= 8) return 12.0;
    if (this <= 12) return 16.0;
    if (this <= 16) return 20.0;
    if (this <= 20) return 24.0;
    if (this <= 24) return 32.0;
    if (this <= 32) return 40.0;
    if (this <= 40) return 48.0;
    if (this <= 48) return 56.0;
    return 64.0;
  }

  /// Get responsive spacing based on context
  double space(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return spaceMobile;
    }
    return spaceDesktop;
  }
}

/// Helper functions for responsive layouts
class ResponsiveLayout {
  ResponsiveLayout._();

  /// Check if current breakpoint is mobile
  static bool isMobile(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isMobile;
  }

  /// Check if current breakpoint is tablet
  static bool isTablet(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isTablet;
  }

  /// Check if current breakpoint is desktop or larger
  static bool isDesktop(BuildContext context) {
    return ResponsiveBreakpoints.of(context).isDesktop;
  }

  /// Get max content width for centering
  /// Mobile: full width
  /// Tablet: 768px
  /// Desktop: 1920px
  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 768.0;
    return 1920.0;
  }

  /// Get horizontal padding based on breakpoint
  static double getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 32.0;
    return 48.0;
  }

  /// Get vertical padding based on breakpoint
  static double getVerticalPadding(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }

  /// Get number of columns for grid layouts
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }
}
