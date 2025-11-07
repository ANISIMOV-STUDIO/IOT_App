/// HVAC UI Kit - Spacing System
///
/// Consistent spacing scale for layouts and components
library;

import 'package:flutter/material.dart';

/// Spacing constants for consistent layouts
class HvacSpacing {
  HvacSpacing._(); // Private constructor

  // ============================================================================
  // BASE SPACING SCALE (4px base unit)
  // ============================================================================

  /// Extra extra small: 4px
  static const double xxs = 4.0;

  /// Extra small: 8px
  static const double xs = 8.0;

  /// Small: 12px
  static const double sm = 12.0;

  /// Medium: 16px (base)
  static const double md = 16.0;

  /// Large: 24px
  static const double lg = 24.0;

  /// Extra large: 32px
  static const double xl = 32.0;

  /// Extra extra large: 48px
  static const double xxl = 48.0;

  /// Huge: 64px
  static const double huge = 64.0;

  // ============================================================================
  // RESPONSIVE ALIASES (with .r suffix for ScreenUtil compatibility)
  // ============================================================================

  /// Responsive versions - same as base (for backward compatibility)
  static const double xxsR = xxs;
  static const double xsR = xs;
  static const double smR = sm;
  static const double mdR = md;
  static const double lgR = lg;
  static const double xlR = xl;
  static const double xxlR = xxl;

  /// Vertical spacing aliases (V suffix)
  static const double xxsV = xxs;
  static const double xsV = xs;
  static const double smV = sm;
  static const double mdV = md;
  static const double lgV = lg;
  static const double xlV = xl;
  static const double xxlV = xxl;

  // ============================================================================
  // EDGE INSETS HELPERS
  // ============================================================================

  static const EdgeInsets paddingXxs = EdgeInsets.all(xxs);
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);

  /// Screen padding (horizontal: 16, vertical: 16)
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: md,
  );

  /// Card padding (all: 24)
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  // ============================================================================
  // GAP HELPERS (for Row/Column)
  // ============================================================================

  static const double gapXxs = xxs;
  static const double gapXs = xs;
  static const double gapSm = sm;
  static const double gapMd = md;
  static const double gapLg = lg;
  static const double gapXl = xl;
}
