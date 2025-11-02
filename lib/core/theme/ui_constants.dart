/// UI Constants
/// Comprehensive design system constants following Material Design 3
/// and iOS Human Interface Guidelines for professional, cohesive UI
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UIConstants {
  // ==================== ICON SIZES ====================
  // Standard icon sizes following Material Design 3 guidelines
  // Touch targets must be at least 48x48dp per accessibility guidelines

  /// Extra small icons (16dp) - For inline text icons, badges
  static const double iconXs = 16.0;

  /// Small icons (20dp) - For compact UI elements
  static const double iconSm = 20.0;

  /// Medium icons (24dp) - Default Material icon size
  static const double iconMd = 24.0;

  /// Large icons (32dp) - For prominent actions
  static const double iconLg = 32.0;

  /// Extra large icons (48dp) - For headers, hero elements
  static const double iconXl = 48.0;

  /// XXL icons (64dp) - For empty states, splash screens
  static const double iconXxl = 64.0;

  // Responsive icon sizes
  static double get iconXsR => iconXs.r;
  static double get iconSmR => iconSm.r;
  static double get iconMdR => iconMd.r;
  static double get iconLgR => iconLg.r;
  static double get iconXlR => iconXl.r;
  static double get iconXxlR => iconXxl.r;

  // ==================== ELEVATION LEVELS ====================
  // Material Design 3 elevation system (0-5 levels)

  /// No elevation - Flat surface
  static const double elevation0 = 0.0;

  /// Level 1 - Subtle elevation for cards at rest
  static const double elevation1 = 1.0;

  /// Level 2 - Standard elevation for raised elements
  static const double elevation2 = 2.0;

  /// Level 3 - Elevated elements like FAB
  static const double elevation3 = 4.0;

  /// Level 4 - Navigation drawer, modal bottom sheet
  static const double elevation4 = 8.0;

  /// Level 5 - Dialog, modal
  static const double elevation5 = 16.0;

  // ==================== ANIMATION DURATIONS ====================
  // Following Material Motion guidelines (100-400ms for most transitions)

  /// Extra fast (100ms) - Micro-interactions, ripples
  static const Duration durationXFast = Duration(milliseconds: 100);

  /// Fast (150ms) - Simple transitions, button states
  static const Duration durationFast = Duration(milliseconds: 150);

  /// Normal (250ms) - Standard transitions, page changes
  static const Duration durationNormal = Duration(milliseconds: 250);

  /// Medium (300ms) - Card expansions, sheet presentations
  static const Duration durationMedium = Duration(milliseconds: 300);

  /// Slow (400ms) - Complex animations, hero transitions
  static const Duration durationSlow = Duration(milliseconds: 400);

  /// Extra slow (600ms) - Loading states, shimmer effects
  static const Duration durationXSlow = Duration(milliseconds: 600);

  // ==================== TOUCH TARGETS ====================
  // iOS HIG and Material Design both recommend 48dp minimum

  /// Minimum touch target size (48x48dp) - Accessibility requirement
  static const double minTouchTarget = 48.0;

  /// Comfortable touch target (56x56dp) - For primary actions
  static const double comfortableTouchTarget = 56.0;

  /// Large touch target (64x64dp) - For critical actions
  static const double largeTouchTarget = 64.0;

  // Responsive touch targets
  static double get minTouchTargetR => minTouchTarget.r;
  static double get comfortableTouchTargetR => comfortableTouchTarget.r;
  static double get largeTouchTargetR => largeTouchTarget.r;

  // ==================== OPACITY LEVELS ====================
  // Standard opacity values for disabled states, overlays

  /// Disabled elements
  static const double opacityDisabled = 0.38;

  /// Secondary/tertiary text
  static const double opacitySecondary = 0.6;
  static const double opacityTertiary = 0.4;

  /// Hover/pressed states
  static const double opacityHover = 0.08;
  static const double opacityPressed = 0.12;

  /// Scrim/overlay
  static const double opacityScrim = 0.32;
  static const double opacityOverlay = 0.5;

  // ==================== LINE HEIGHTS ====================
  // Optimal readability: 1.2-1.5 for headings, 1.5-1.7 for body

  /// Tight line height for headings
  static const double lineHeightTight = 1.2;

  /// Normal line height for UI elements
  static const double lineHeightNormal = 1.4;

  /// Comfortable line height for body text
  static const double lineHeightComfortable = 1.5;

  /// Relaxed line height for long-form content
  static const double lineHeightRelaxed = 1.7;

  // ==================== ASPECT RATIOS ====================

  /// Square (1:1) - Icons, avatars
  static const double aspectRatioSquare = 1.0;

  /// Landscape (16:9) - Videos, images
  static const double aspectRatioLandscape = 16 / 9;

  /// Portrait (4:3) - Cards
  static const double aspectRatioPortrait = 4 / 3;

  /// Wide (21:9) - Panoramic views
  static const double aspectRatioWide = 21 / 9;

  // ==================== LAYOUT CONSTRAINTS ====================

  /// Maximum content width on desktop (1200-1440px recommended)
  static const double maxContentWidth = 1440.0;

  /// Maximum card width for readability
  static const double maxCardWidth = 768.0;

  /// Maximum text width (60-80 characters per line optimal)
  static const double maxTextWidth = 680.0;

  // Responsive layout constraints
  static double get maxContentWidthR => maxContentWidth.w;
  static double get maxCardWidthR => maxCardWidth.w;
  static double get maxTextWidthR => maxTextWidth.w;

  // ==================== BREAKPOINTS ====================
  // Standard responsive breakpoints

  /// Mobile breakpoint (< 600dp)
  static const double breakpointMobile = 600.0;

  /// Tablet breakpoint (600-1024dp)
  static const double breakpointTablet = 1024.0;

  /// Desktop breakpoint (>= 1024dp)
  static const double breakpointDesktop = 1024.0;

  /// Large desktop (>= 1440dp)
  static const double breakpointLargeDesktop = 1440.0;

  // ==================== CARD DIMENSIONS ====================

  /// Standard control card height (consistent across app)
  static const double controlCardHeight = 280.0;

  /// Compact card height
  static const double compactCardHeight = 120.0;

  /// Expanded card height
  static const double expandedCardHeight = 400.0;

  // Responsive card dimensions
  static double get controlCardHeightR => controlCardHeight.h;
  static double get compactCardHeightR => compactCardHeight.h;
  static double get expandedCardHeightR => expandedCardHeight.h;

  // ==================== BLUR RADIUS ====================

  /// Subtle blur for cards
  static const double blurSubtle = 4.0;

  /// Medium blur for modals
  static const double blurMedium = 8.0;

  /// Strong blur for backdrops
  static const double blurStrong = 16.0;

  // ==================== DIVIDER THICKNESS ====================

  /// Thin divider (1dp)
  static const double dividerThin = 1.0;

  /// Medium divider (2dp)
  static const double dividerMedium = 2.0;

  /// Thick divider (4dp)
  static const double dividerThick = 4.0;

  // ==================== HERO ANIMATION ====================

  /// Hero animation duration
  static const Duration heroAnimationDuration = Duration(milliseconds: 300);

  /// Hero animation curve
  static const Curve heroAnimationCurve = Curves.easeInOutCubic;

  // ==================== SCROLL PHYSICS ====================

  /// Enable scroll on mobile/tablet, disable on desktop
  static bool shouldEnableScroll(double screenWidth) {
    return screenWidth < breakpointDesktop;
  }

  /// Check if current screen is mobile
  static bool isMobile(double screenWidth) {
    return screenWidth < breakpointMobile;
  }

  /// Check if current screen is tablet
  static bool isTablet(double screenWidth) {
    return screenWidth >= breakpointMobile && screenWidth < breakpointTablet;
  }

  /// Check if current screen is desktop
  static bool isDesktop(double screenWidth) {
    return screenWidth >= breakpointDesktop;
  }
}
