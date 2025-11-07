/// HVAC UI Kit - Decoration Helpers
///
/// Pre-built BoxDecoration patterns for consistent styling
library;

import 'package:flutter/material.dart';
import 'colors.dart';
import 'radius.dart';
import 'shadows.dart';

/// Decoration helper methods for common UI patterns
class HvacDecorations {
  HvacDecorations._(); // Private constructor

  // ============================================================================
  // CARD DECORATIONS
  // ============================================================================

  /// Standard card decoration
  static BoxDecoration card({
    Color? color,
    double? radius,
    List<BoxShadow>? shadow,
    bool withBorder = true,
  }) {
    return BoxDecoration(
      color: color ?? HvacColors.backgroundCard,
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.md),
      border: withBorder
          ? Border.all(
              color: HvacColors.backgroundCardBorder,
              width: 1,
            )
          : null,
      boxShadow: shadow ?? HvacShadows.sm,
    );
  }

  /// Elevated card decoration (with more prominent shadow)
  static BoxDecoration cardElevated({
    Color? color,
    double? radius,
  }) {
    return BoxDecoration(
      color: color ?? HvacColors.backgroundCard,
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.md),
      border: Border.all(
        color: HvacColors.backgroundCardBorder,
        width: 1,
      ),
      boxShadow: HvacShadows.md,
    );
  }

  /// Flat card without shadow
  static BoxDecoration cardFlat({
    Color? color,
    double? radius,
    bool withBorder = true,
  }) {
    return BoxDecoration(
      color: color ?? HvacColors.backgroundCard,
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.md),
      border: withBorder
          ? Border.all(
              color: HvacColors.backgroundCardBorder,
              width: 1,
            )
          : null,
    );
  }

  // ============================================================================
  // BADGE/CHIP DECORATIONS
  // ============================================================================

  /// Badge decoration with custom color
  static BoxDecoration badge({
    required Color color,
    double? radius,
    bool filled = false,
  }) {
    return BoxDecoration(
      color: filled ? color : color.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.sm),
      border: filled
          ? null
          : Border.all(
              color: color,
              width: 1,
            ),
    );
  }

  /// Small rounded badge
  static BoxDecoration badgeSmall({
    required Color color,
    bool filled = false,
  }) {
    return badge(
      color: color,
      radius: HvacRadius.xs,
      filled: filled,
    );
  }

  // ============================================================================
  // BUTTON DECORATIONS
  // ============================================================================

  /// Primary button with gradient
  static BoxDecoration buttonPrimary({
    Color? startColor,
    Color? endColor,
    double? radius,
  }) {
    final start = startColor ?? HvacColors.primaryOrange;
    final end = endColor ?? HvacColors.primaryOrangeDark;

    return BoxDecoration(
      gradient: LinearGradient(
        colors: [start, end],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.md),
      boxShadow: HvacShadows.accentShadow(start, alpha: 0.3),
    );
  }

  /// Secondary button (outlined)
  static BoxDecoration buttonSecondary({
    Color? borderColor,
    double? radius,
  }) {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.md),
      border: Border.all(
        color: borderColor ?? HvacColors.accent,
        width: 2,
      ),
    );
  }

  /// Ghost button (subtle background)
  static BoxDecoration buttonGhost({
    Color? backgroundColor,
    double? radius,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? HvacColors.backgroundElevated,
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.md),
    );
  }

  // ============================================================================
  // GLASSMORPHISM DECORATIONS
  // ============================================================================

  /// Glass card with frosted effect (use with BackdropFilter)
  static BoxDecoration glass({
    double? radius,
    double opacity = 0.1,
  }) {
    return BoxDecoration(
      color: HvacColors.glassWhite.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.md),
      border: Border.all(
        color: HvacColors.glassBorder,
        width: 1,
      ),
    );
  }

  /// Glass card with gradient
  static BoxDecoration glassGradient({
    double? radius,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0x1AFFFFFF), // 10% white
          Color(0x0DFFFFFF), // 5% white
        ],
        begin: Alignment.topLeft,        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.md),
      border: Border.all(
        color: HvacColors.glassBorder,
        width: 1,
      ),
    );
  }

  // ============================================================================
  // SPECIALIZED DECORATIONS
  // ============================================================================

  /// Icon container decoration
  static BoxDecoration iconContainer({
    required Color color,
    double? radius,
    bool withShadow = false,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.sm),
      border: Border.all(
        color: color.withValues(alpha: 0.4),
        width: 1,
      ),
      boxShadow: withShadow ? HvacShadows.accentShadow(color, alpha: 0.15) : null,
    );
  }

  /// Mode badge decoration (for HVAC modes)
  static BoxDecoration modeBadge({
    required Color modeColor,
    double? radius,
  }) {
    return BoxDecoration(
      color: modeColor.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.sm),
      border: Border.all(
        color: modeColor,
        width: 1,
      ),
    );
  }

  /// Alert/notification decoration
  static BoxDecoration alert({
    required Color color,
    double? radius,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.sm),
      border: Border.all(
        color: color,
        width: 1,
      ),
    );
  }

  /// Input field decoration
  static BoxDecoration input({
    bool focused = false,
    bool error = false,
    double? radius,
  }) {
    return BoxDecoration(
      color: HvacColors.backgroundElevated,
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.sm),
      border: Border.all(
        color: error
            ? HvacColors.error
            : focused
                ? HvacColors.primaryOrange
                : HvacColors.backgroundCardBorder,
        width: focused || error ? 2 : 1,
      ),
    );
  }

  /// Divider decoration (horizontal line)
  static BoxDecoration divider({
    Color? color,
    double thickness = 1,
  }) {
    return BoxDecoration(
      color: color ?? HvacColors.backgroundCardBorder,
      borderRadius: BorderRadius.circular(thickness / 2),
    );
  }

  // ============================================================================
  // GRADIENT DECORATIONS
  // ============================================================================

  /// Custom gradient decoration
  static BoxDecoration gradient({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    double? radius,
    List<BoxShadow>? shadow,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ),
      borderRadius: BorderRadius.circular(radius ?? HvacRadius.md),
      boxShadow: shadow,
    );
  }

  /// Orange gradient decoration
  static BoxDecoration gradientOrange({double? radius}) {
    return gradient(
      colors: [
        HvacColors.primaryOrange,
        HvacColors.primaryOrangeDark,
      ],
      radius: radius,
      shadow: HvacShadows.orangeShadow,
    );
  }

  /// Blue gradient decoration
  static BoxDecoration gradientBlue({double? radius}) {
    return gradient(
      colors: [
        HvacColors.primaryBlue,
        HvacColors.primaryBlue.withValues(alpha: 0.8),
      ],
      radius: radius,
      shadow: HvacShadows.blueShadow,
    );
  }

  /// Subtle background gradient
  static BoxDecoration gradientSubtle({double? radius}) {
    return gradient(
      colors: [
        HvacColors.backgroundCard,
        HvacColors.backgroundElevated,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      radius: radius,
    );
  }
}
