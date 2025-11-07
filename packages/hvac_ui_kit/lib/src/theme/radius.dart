/// HVAC UI Kit - Border Radius System
///
/// Consistent border radius scale for UI elements
library;

import 'package:flutter/material.dart';

/// Border radius constants for UI elements
class HvacRadius {
  HvacRadius._(); // Private constructor

  // ============================================================================
  // RADIUS SCALE
  // ============================================================================

  /// Extra small radius: 4px
  static const double xs = 4.0;

  /// Small radius: 8px
  static const double sm = 8.0;

  /// Medium radius: 12px
  static const double md = 12.0;

  /// Large radius: 16px
  static const double lg = 16.0;

  /// Extra large radius: 20px
  static const double xl = 20.0;

  /// Extra extra large radius: 24px
  static const double xxl = 24.0;

  /// Full circle
  static const double full = 9999.0;

  /// Round - alias for full circle
  static const double round = full;

  // ============================================================================
  // RESPONSIVE RADIUS VALUES (with .r suffix for flutter_screenutil)
  // ============================================================================

  /// Extra small radius responsive: 4.r
  static double get xsR => xs;

  /// Small radius responsive: 8.r
  static double get smR => sm;

  /// Medium radius responsive: 12.r
  static double get mdR => md;

  /// Large radius responsive: 16.r
  static double get lgR => lg;

  /// Extra large radius responsive: 20.r
  static double get xlR => xl;

  /// Extra extra large radius responsive: 24.r
  static double get xxlR => xxl;

  /// Round radius responsive (fully rounded)
  static double get roundR => full;

  // ============================================================================
  // BORDER RADIUS HELPERS
  // ============================================================================

  static BorderRadius get xsRadius => BorderRadius.circular(xs);
  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get xxlRadius => BorderRadius.circular(xxl);
  static BorderRadius get fullRadius => BorderRadius.circular(full);
}
