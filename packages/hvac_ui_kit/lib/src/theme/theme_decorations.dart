/// Theme Decoration Helpers
///
/// Pre-configured BoxDecoration styles for common HVAC UI components
library;

import 'package:flutter/material.dart';
import 'colors.dart';
import 'radius.dart';

/// Collection of pre-configured decorations for HVAC UI Kit
class HvacDecorations {
  HvacDecorations._(); // Private constructor

  /// Device Card Decoration - Luxury style with selection state
  static BoxDecoration deviceCard({bool isSelected = false}) {
    return BoxDecoration(
      color: HvacColors.backgroundCard,
      borderRadius: BorderRadius.circular(HvacRadius.lg),
      border: Border.all(
        color: isSelected ? HvacColors.accent : HvacColors.backgroundCardBorder,
        width: isSelected ? 2 : 1,
      ),
      // Subtle glow when selected
      boxShadow: isSelected
          ? [
              const BoxShadow(
                color: HvacColors.accentSubtle,
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ]
          : null,
    );
  }

  /// Rounded Card Decoration - Sophisticated
  static BoxDecoration roundedCard({
    Color? color,
    bool hasBorder = true,
  }) {
    return BoxDecoration(
      color: color ?? HvacColors.backgroundCard,
      borderRadius: BorderRadius.circular(HvacRadius.lg),
      border: hasBorder
          ? Border.all(
              color: HvacColors.backgroundCardBorder,
              width: 1,
            )
          : null,
      // Subtle shadow for depth
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Card Shadow - Standard elevation
  static List<BoxShadow> cardShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  /// Accent Button Decoration - Luxury Gold with gradient
  static BoxDecoration accentButton() {
    return BoxDecoration(
      gradient: HvacColors.primaryGradient,
      borderRadius: BorderRadius.circular(HvacRadius.md),
      boxShadow: const [
        BoxShadow(
          color: HvacColors.accentSubtle,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  /// Glassmorphism Card - Frosted glass effect
  static BoxDecoration glassCard() {
    return BoxDecoration(
      gradient: HvacColors.glassGradient,
      borderRadius: BorderRadius.circular(HvacRadius.lg),
      border: Border.all(
        color: HvacColors.glassBorder,
        width: 1,
      ),
    );
  }

  /// Device Image Placeholder
  static BoxDecoration deviceImagePlaceholder() {
    return BoxDecoration(
      color: HvacColors.backgroundCard,
      borderRadius: BorderRadius.circular(HvacRadius.md),
      border: Border.all(
        color: HvacColors.backgroundCardBorder,
        width: 1,
      ),
    );
  }

  /// Subtle Background Gradient
  static BoxDecoration subtleGradient() {
    return BoxDecoration(
      gradient: HvacColors.subtleGradient,
      borderRadius: BorderRadius.circular(HvacRadius.lg),
    );
  }

  /// Orange Button Decoration - For legacy compatibility
  /// Creates an orange gradient button decoration
  static BoxDecoration orangeButton() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          HvacColors.primaryOrange,
          HvacColors.primaryOrangeDark,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(HvacRadius.md),
      boxShadow: [
        BoxShadow(
          color: HvacColors.primaryOrange.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
