import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Mathematical Design System
/// Based on Golden Ratio, 8px Grid, and Modular Type Scale
///
/// References:
/// - Golden Ratio: φ = 1.618033988749895
/// - 8px Grid System (Material Design)
/// - Major Third Type Scale (1.25)
abstract class DesignSystem {
  DesignSystem._();

  // ============================================
  // MATHEMATICAL CONSTANTS
  // ============================================

  /// Golden Ratio (φ) - природная пропорция красоты
  static const double phi = 1.618033988749895;

  /// Inverse Golden Ratio (1/φ)
  static const double phiInverse = 0.618033988749895;

  /// Silver Ratio (δ) - для вторичных пропорций
  static const double silverRatio = 2.414213562373095;

  /// Base grid unit (8px - Material Design standard)
  static const double gridUnit = 8.0;

  /// Minor grid unit (4px - for fine adjustments)
  static const double gridUnitMinor = 4.0;

  // ============================================
  // SPACING SCALE (Geometric Progression)
  // Based on 8px × multipliers
  // ============================================

  /// 4px - micro spacing (borders, dividers)
  static const double space0 = 4.0;

  /// 8px - base unit
  static const double space1 = 8.0;

  /// 12px - tight spacing
  static const double space2 = 12.0;

  /// 16px - default spacing
  static const double space3 = 16.0;

  /// 24px - comfortable spacing
  static const double space4 = 24.0;

  /// 32px - section spacing
  static const double space5 = 32.0;

  /// 48px - large section spacing
  static const double space6 = 48.0;

  /// 64px - extra large spacing
  static const double space7 = 64.0;

  /// 96px - hero spacing
  static const double space8 = 96.0;

  /// Get spacing by index (0-8)
  static double spacing(int index) => switch (index) {
        0 => space0,
        1 => space1,
        2 => space2,
        3 => space3,
        4 => space4,
        5 => space5,
        6 => space6,
        7 => space7,
        8 => space8,
        _ => space3,
      };

  // ============================================
  // TYPOGRAPHY SCALE (Major Third - 1.25)
  // Base: 16px
  // ============================================

  /// Type scale ratio (Major Third)
  static const double typeScale = 1.25;

  /// 10px - micro (badges, captions)
  static const double fontSize0 = 10.0;

  /// 12px - small (labels, hints)
  static const double fontSize1 = 12.0;

  /// 14px - body small
  static const double fontSize2 = 14.0;

  /// 16px - body (base)
  static const double fontSize3 = 16.0;

  /// 20px - large body / small title
  static const double fontSize4 = 20.0;

  /// 24px - title
  static const double fontSize5 = 24.0;

  /// 32px - headline
  static const double fontSize6 = 32.0;

  /// 40px - display small
  static const double fontSize7 = 40.0;

  /// 48px - display
  static const double fontSize8 = 48.0;

  /// 64px - display large
  static const double fontSize9 = 64.0;

  // ============================================
  // LINE HEIGHTS (Based on Golden Ratio)
  // ============================================

  /// Tight line height (headings)
  static const double lineHeightTight = 1.2;

  /// Normal line height (body text)
  static const double lineHeightNormal = 1.5;

  /// Relaxed line height (large text blocks)
  static const double lineHeightRelaxed = 1.618; // φ

  // ============================================
  // LAYOUT PROPORTIONS (Golden Ratio)
  // ============================================

  /// Primary content width ratio (61.8%)
  static const double layoutPrimary = 0.618;

  /// Secondary content width ratio (38.2%)
  static const double layoutSecondary = 0.382;

  /// Content area split: 2/3 + 1/3
  static const double layoutTwoThirds = 0.667;
  static const double layoutOneThird = 0.333;

  /// Content area split: 3/4 + 1/4
  static const double layoutThreeQuarters = 0.75;
  static const double layoutOneQuarter = 0.25;

  // ============================================
  // BORDER RADIUS (8px Grid Based)
  // ============================================

  /// 4px - subtle rounding (inputs, tags)
  static const double radiusXs = 4.0;

  /// 8px - small rounding (buttons, chips)
  static const double radiusSm = 8.0;

  /// 12px - medium rounding (cards)
  static const double radiusMd = 12.0;

  /// 16px - large rounding (modals, panels)
  static const double radiusLg = 16.0;

  /// 24px - extra large rounding (feature cards)
  static const double radiusXl = 24.0;

  /// Full rounding (circles, pills)
  static const double radiusFull = 9999.0;

  // ============================================
  // SHADOWS (Elevation System)
  // ============================================

  /// Elevation levels (dp)
  static const double elevation0 = 0.0;
  static const double elevation1 = 2.0;
  static const double elevation2 = 4.0;
  static const double elevation3 = 8.0;
  static const double elevation4 = 16.0;
  static const double elevation5 = 24.0;

  // ============================================
  // OPACITY LEVELS (Visual Hierarchy)
  // ============================================

  /// Full opacity (primary content)
  static const double opacityFull = 1.0;

  /// High emphasis (87%)
  static const double opacityHigh = 0.87;

  /// Medium emphasis (60%)
  static const double opacityMedium = 0.60;

  /// Disabled state (38%)
  static const double opacityDisabled = 0.38;

  /// Dividers and borders (12%)
  static const double opacityDivider = 0.12;

  /// Hover/focus overlay (8%)
  static const double opacityHover = 0.08;

  /// Splash overlay (12%)
  static const double opacitySplash = 0.12;

  // ============================================
  // BREAKPOINTS (Responsive)
  // ============================================

  /// Mobile: < 600px
  static const double breakpointMobile = 600.0;

  /// Tablet: 600px - 1024px
  static const double breakpointTablet = 1024.0;

  /// Desktop: 1024px - 1440px
  static const double breakpointDesktop = 1440.0;

  /// Large Desktop: > 1440px
  static const double breakpointLarge = 1920.0;

  // ============================================
  // COMPONENT SIZES
  // ============================================

  /// Icon sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  /// Avatar sizes
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXl = 80.0;

  /// Button heights
  static const double buttonSm = 32.0;
  static const double buttonMd = 40.0;
  static const double buttonLg = 48.0;
  static const double buttonXl = 56.0;

  /// Input heights
  static const double inputSm = 36.0;
  static const double inputMd = 44.0;
  static const double inputLg = 52.0;

  // ============================================
  // SIDEBAR & PANELS
  // ============================================

  /// Sidebar collapsed width
  static const double sidebarCollapsed = 72.0;

  /// Sidebar expanded width
  static const double sidebarExpanded = 240.0;

  /// Right panel width (Golden Ratio based)
  /// For 1920px screen: 1920 × 0.382 ≈ 733px (too wide)
  /// Better: Fixed width that feels balanced
  static const double rightPanelWidth = 360.0;

  /// Right panel width compact
  static const double rightPanelWidthCompact = 320.0;

  // ============================================
  // ANIMATION DURATIONS
  // ============================================

  /// Instant (state changes)
  static const Duration durationInstant = Duration.zero;

  /// Fast (micro-interactions)
  static const Duration durationFast = Duration(milliseconds: 100);

  /// Normal (standard transitions)
  static const Duration durationNormal = Duration(milliseconds: 200);

  /// Slow (complex animations)
  static const Duration durationSlow = Duration(milliseconds: 300);

  /// Slower (page transitions)
  static const Duration durationSlower = Duration(milliseconds: 400);

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Round value to nearest grid unit (8px)
  static double snapToGrid(double value) {
    return (value / gridUnit).round() * gridUnit;
  }

  /// Round value to nearest minor grid unit (4px)
  static double snapToMinorGrid(double value) {
    return (value / gridUnitMinor).round() * gridUnitMinor;
  }

  /// Calculate Golden Ratio derived value
  static double goldenRatio(double base, {bool larger = true}) {
    return larger ? base * phi : base / phi;
  }

  /// Calculate font size from scale index
  /// Index 0 = base (16px), positive = larger, negative = smaller
  static double fontSizeFromScale(int index, {double base = 16.0}) {
    return base * math.pow(typeScale, index);
  }

  /// Get width split by Golden Ratio
  static ({double primary, double secondary}) goldenSplit(double totalWidth) {
    return (
      primary: totalWidth * layoutPrimary,
      secondary: totalWidth * layoutSecondary,
    );
  }

  /// Calculate card grid columns based on available width
  static int gridColumns(double availableWidth, {double minCardWidth = 280.0}) {
    return math.max(1, (availableWidth / minCardWidth).floor());
  }

  /// Calculate optimal card width for given columns and spacing
  static double cardWidth(
    double availableWidth, {
    required int columns,
    double gap = space3,
  }) {
    final totalGaps = (columns - 1) * gap;
    return (availableWidth - totalGaps) / columns;
  }
}

// ============================================
// EXTENSION FOR EASY ACCESS
// ============================================

extension DesignSystemContext on BuildContext {
  /// Get spacing value
  double ds(int index) => DesignSystem.spacing(index);

  /// Check if screen is mobile
  bool get isMobile => MediaQuery.of(this).size.width < DesignSystem.breakpointMobile;

  /// Check if screen is tablet
  bool get isTablet {
    final width = MediaQuery.of(this).size.width;
    return width >= DesignSystem.breakpointMobile && width < DesignSystem.breakpointTablet;
  }

  /// Check if screen is desktop
  bool get isDesktop => MediaQuery.of(this).size.width >= DesignSystem.breakpointTablet;

  /// Get available content width (excluding sidebar)
  double get contentWidth {
    final screenWidth = MediaQuery.of(this).size.width;
    if (isMobile) return screenWidth;
    return screenWidth - DesignSystem.sidebarExpanded;
  }
}

// ============================================
// SPACING WIDGET HELPERS
// ============================================

/// Horizontal spacing widget
class HGap extends StatelessWidget {
  final double size;
  const HGap(this.size, {super.key});

  const HGap.xs({super.key}) : size = DesignSystem.space0;
  const HGap.sm({super.key}) : size = DesignSystem.space1;
  const HGap.md({super.key}) : size = DesignSystem.space3;
  const HGap.lg({super.key}) : size = DesignSystem.space4;
  const HGap.xl({super.key}) : size = DesignSystem.space5;

  @override
  Widget build(BuildContext context) => SizedBox(width: size);
}

/// Vertical spacing widget
class VGap extends StatelessWidget {
  final double size;
  const VGap(this.size, {super.key});

  const VGap.xs({super.key}) : size = DesignSystem.space0;
  const VGap.sm({super.key}) : size = DesignSystem.space1;
  const VGap.md({super.key}) : size = DesignSystem.space3;
  const VGap.lg({super.key}) : size = DesignSystem.space4;
  const VGap.xl({super.key}) : size = DesignSystem.space5;

  @override
  Widget build(BuildContext context) => SizedBox(height: size);
}
