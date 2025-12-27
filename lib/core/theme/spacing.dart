/// Spacing System - 8px Grid
/// Provides consistent spacing scale based on 8px base unit
library;

import 'package:flutter/material.dart';

class AppSpacing {
  // Spacing scale (based on 8px grid system) - FIXED values, no scaling
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Common padding presets
  static double get paddingXs => xs;
  static double get paddingSm => sm;
  static double get paddingMd => md;
  static double get paddingLg => lg;
  static double get paddingXl => xl;

  // Common margin presets
  static double get marginXs => xs;
  static double get marginSm => sm;
  static double get marginMd => md;
  static double get marginLg => lg;
  static double get marginXl => xl;

  // Gap sizes for Flex widgets
  static double get gapXs => xs;
  static double get gapSm => sm;
  static double get gapMd => md;
  static double get gapLg => lg;
  static double get gapXl => xl;

  // Screen edge padding
  static double get screenPaddingMobile => md;
  static double get screenPaddingTablet => lg;

  // Card padding
  static double get cardPadding => lg; // Default card padding
  static double get cardPaddingSmall => md;
  static double get cardPaddingMedium => lg;
  static double get cardPaddingLarge => xl;

  // Snackbar margins (responsive based on breakpoints)
  static double snackbarMargin(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return md; // 16 for mobile
    if (width < 1024) return lg; // 24 for tablet
    return xl; // 32 for desktop
  }

  static double get snackbarMarginMobile => md;
  static double get snackbarMarginTablet => lg;
  static double get snackbarMarginDesktop => xl;

  // Border radius - используйте AppColors.buttonRadius, cardRadius и т.д.
}
