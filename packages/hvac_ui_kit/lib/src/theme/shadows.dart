/// HVAC UI Kit - Shadow System
///
/// Consistent shadow/elevation system for depth and hierarchy
library;

import 'package:flutter/material.dart';
import 'colors.dart';

/// Shadow constants for UI elements
class HvacShadows {
  HvacShadows._(); // Private constructor

  // ============================================================================
  // SHADOW PRESETS
  // ============================================================================

  /// No shadow
  static const List<BoxShadow> none = [];

  /// Extra small shadow - Subtle depth (1dp elevation) - Modern soft shadow
  static List<BoxShadow> get xs => [
        BoxShadow(
          color: const Color(0xFF1E88E5).withValues(alpha: 0.04),
          blurRadius: 3,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.02),
          blurRadius: 2,
          offset: const Offset(0, 0),
          spreadRadius: 0,
        ),
      ];

  /// Small shadow - Card at rest (2dp elevation) - Soft blue-tinted shadow
  static List<BoxShadow> get sm => [
        BoxShadow(
          color: const Color(0xFF1E88E5).withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: -1,
        ),
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ];

  /// Medium shadow - Raised elements (4dp elevation) - Enhanced depth
  static List<BoxShadow> get md => [
        BoxShadow(
          color: const Color(0xFF1E88E5).withValues(alpha: 0.12),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: -2,
        ),
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: -1,
        ),
      ];

  /// Large shadow - Floating elements (8dp elevation)
  static List<BoxShadow> get lg => [
        BoxShadow(
          color: HvacColors.backgroundDark.withValues(alpha: 0.25),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ];

  /// Extra large shadow - Modal/Dialog (16dp elevation)
  static List<BoxShadow> get xl => [
        BoxShadow(
          color: HvacColors.backgroundDark.withValues(alpha: 0.3),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  /// Extra extra large shadow - Prominent elevation (24dp)
  static List<BoxShadow> get xxl => [
        BoxShadow(
          color: HvacColors.backgroundDark.withValues(alpha: 0.35),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  // ============================================================================
  // COLORED SHADOWS - For accent elements
  // ============================================================================

  /// Accent shadow with custom color
  static List<BoxShadow> accentShadow(Color color, {double alpha = 0.3}) => [
        BoxShadow(
          color: color.withValues(alpha: alpha),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Primary orange shadow
  static List<BoxShadow> get orangeShadow => accentShadow(
        HvacColors.primaryOrange,
        alpha: 0.3,
      );

  /// Primary blue shadow
  static List<BoxShadow> get blueShadow => accentShadow(
        HvacColors.primaryBlue,
        alpha: 0.3,
      );

  /// Success shadow
  static List<BoxShadow> get successShadow => accentShadow(
        HvacColors.success,
        alpha: 0.25,
      );

  /// Error shadow
  static List<BoxShadow> get errorShadow => accentShadow(
        HvacColors.error,
        alpha: 0.25,
      );

  // ============================================================================
  // INNER SHADOWS (using negative offset for inset effect)
  // ============================================================================

  /// Inner shadow - Inset effect
  static List<BoxShadow> get inner => [
        BoxShadow(
          color: HvacColors.backgroundDark.withValues(alpha: 0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: -2,
        ),
      ];

  // ============================================================================
  // GLOW EFFECTS
  // ============================================================================

  /// Soft glow effect
  static List<BoxShadow> glow(Color color, {double alpha = 0.4}) => [
        BoxShadow(
          color: color.withValues(alpha: alpha),
          blurRadius: 16,
          offset: const Offset(0, 0),
          spreadRadius: 2,
        ),
      ];

  /// Orange glow
  static List<BoxShadow> get orangeGlow => glow(HvacColors.primaryOrange);

  /// Blue glow
  static List<BoxShadow> get blueGlow => glow(HvacColors.primaryBlue);

  /// Accent glow
  static List<BoxShadow> get accentGlow => glow(HvacColors.accent);
}
