/// Responsive Utilities
///
/// Helper methods for responsive sizing across platforms
library;

import 'package:flutter/material.dart';

class ResponsiveUtils {
  /// Get screen width using MediaQuery.sizeOf for better performance
  /// This method only rebuilds when size changes, not on other MediaQuery changes
  static double _getWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  /// Get responsive value based on screen width
  static double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final width = _getWidth(context);

    if (width >= 1200) {
      return desktop ?? tablet ?? mobile;
    } else if (width >= 600) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return _getWidth(context) < 600;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final width = _getWidth(context);
    return width >= 600 && width < 1200;
  }

  /// Check if device is desktop/web
  static bool isDesktop(BuildContext context) {
    return _getWidth(context) >= 1200;
  }

  /// Get scaled font size
  static double scaledFontSize(BuildContext context, double baseFontSize) {
    return getResponsiveValue(
      context,
      mobile: baseFontSize,
      tablet: baseFontSize * 0.9,
      desktop: baseFontSize * 0.85,
    );
  }

  /// Get scaled spacing
  static double scaledSpacing(BuildContext context, double baseSpacing) {
    return getResponsiveValue(
      context,
      mobile: baseSpacing,
      tablet: baseSpacing * 0.85,
      desktop: baseSpacing * 0.75,
    );
  }

  /// Get scaled icon size
  static double scaledIconSize(BuildContext context, double baseIconSize) {
    return getResponsiveValue(
      context,
      mobile: baseIconSize,
      tablet: baseIconSize * 0.9,
      desktop: baseIconSize * 0.8,
    );
  }

  /// Get scaled border radius
  static double scaledBorderRadius(BuildContext context, double baseRadius) {
    return getResponsiveValue(
      context,
      mobile: baseRadius,
      tablet: baseRadius * 0.85,
      desktop: baseRadius * 0.75,
    );
  }

  /// Get grid column count based on screen width
  static int getGridColumnCount(BuildContext context, {int mobile = 2}) {
    return getResponsiveValue(
      context,
      mobile: mobile.toDouble(),
      tablet: (mobile + 1).toDouble(),
      desktop: (mobile + 2).toDouble(),
    ).toInt();
  }

  /// Get content max width for centered layouts
  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1200) {
      return 1200;
    } else if (width >= 600) {
      return 900;
    } else {
      return width;
    }
  }
}
