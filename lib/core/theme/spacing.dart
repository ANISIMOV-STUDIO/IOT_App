/// Spacing System - 8px Grid
/// Provides consistent spacing scale based on 8px base unit
library;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  // Spacing scale (based on 8px grid system)
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Responsive versions
  static double get xxsR => 4.0.w;
  static double get xsR => 8.0.w;
  static double get smR => 12.0.w;
  static double get mdR => 16.0.w;
  static double get lgR => 24.0.w;
  static double get xlR => 32.0.w;
  static double get xxlR => 48.0.w;
  static double get xxxlR => 64.0.w;

  // Vertical spacing (using height)
  static double get xxsV => 4.0.h;
  static double get xsV => 8.0.h;
  static double get smV => 12.0.h;
  static double get mdV => 16.0.h;
  static double get lgV => 24.0.h;
  static double get xlV => 32.0.h;
  static double get xxlV => 48.0.h;
  static double get xxxlV => 64.0.h;

  // Common padding presets
  static double get paddingXs => xsR;
  static double get paddingSm => smR;
  static double get paddingMd => mdR;
  static double get paddingLg => lgR;
  static double get paddingXl => xlR;

  // Common margin presets
  static double get marginXs => xsR;
  static double get marginSm => smR;
  static double get marginMd => mdR;
  static double get marginLg => lgR;
  static double get marginXl => xlR;

  // Gap sizes for Flex widgets
  static double get gapXs => xsR;
  static double get gapSm => smR;
  static double get gapMd => mdR;
  static double get gapLg => lgR;
  static double get gapXl => xlR;

  // Screen edge padding
  static double get screenPaddingMobile => mdR;
  static double get screenPaddingTablet => lgR;

  // Card padding
  static double get cardPadding => lgR; // Default card padding
  static double get cardPaddingSmall => mdR;
  static double get cardPaddingMedium => lgR;
  static double get cardPaddingLarge => xlR;
}
