import 'package:flutter/material.dart';

/// Neumorphic Spacing System
/// Based on 4px grid with semantic naming
abstract class NeumorphicSpacing {
  // ============================================
  // BASE UNITS (4px grid)
  // ============================================
  
  static const double unit = 4.0;
  
  static const double xxs = 4.0;   // 1 unit
  static const double xs = 8.0;    // 2 units
  static const double sm = 12.0;   // 3 units
  static const double md = 16.0;   // 4 units
  static const double lg = 24.0;   // 6 units
  static const double xl = 32.0;   // 8 units
  static const double xxl = 48.0;  // 12 units
  static const double xxxl = 64.0; // 16 units

  // ============================================
  // SEMANTIC SPACING
  // ============================================
  
  /// Padding inside cards
  static const double cardPadding = 16.0;
  
  /// Gap between cards in grid
  static const double cardGap = 12.0;
  
  /// Sidebar width (collapsed)
  static const double sidebarCollapsed = 80.0;
  
  /// Sidebar width (expanded)
  static const double sidebarExpanded = 200.0;
  
  /// Right panel width
  static const double rightPanelWidth = 300.0;
  
  /// Screen edge padding
  static const double screenPadding = 20.0;
  
  /// Section gap (between major sections)
  static const double sectionGap = 20.0;

  // ============================================
  // BORDER RADIUS
  // ============================================
  
  static const double radiusXs = 8.0;
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 24.0;
  static const double radiusRound = 999.0;
  
  /// Default card radius
  static const double cardRadius = 20.0;
  
  /// Button radius
  static const double buttonRadius = 12.0;
  
  /// Input field radius
  static const double inputRadius = 12.0;
  
  /// Dial/circular element radius factor
  static const double dialRadius = 999.0;

  // ============================================
  // RESPONSIVE BREAKPOINTS
  // ============================================
  
  /// Mobile breakpoint (< 600dp)
  static const double breakpointMobile = 600.0;
  
  /// Tablet breakpoint (600-1024dp)
  static const double breakpointTablet = 1024.0;
  
  /// Desktop breakpoint (> 1024dp)
  static const double breakpointDesktop = 1440.0;

  // ============================================
  // ICON SIZES
  // ============================================
  
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  
  /// Device card icon size
  static const double deviceIconSize = 28.0;
  
  /// Navigation icon size
  static const double navIconSize = 24.0;

  // ============================================
  // COMPONENT SIZES
  // ============================================
  
  /// Temperature dial size
  static const double temperatureDialSize = 200.0;
  
  /// Device card minimum height
  static const double deviceCardMinHeight = 120.0;
  
  /// Toggle switch width
  static const double toggleWidth = 48.0;
  
  /// Toggle switch height
  static const double toggleHeight = 28.0;
  
  /// Avatar size (small)
  static const double avatarSm = 32.0;
  
  /// Avatar size (medium)
  static const double avatarMd = 48.0;
  
  /// Avatar size (large)
  static const double avatarLg = 64.0;

  // ============================================
  // BOTTOM NAVIGATION
  // ============================================

  /// Bottom navigation bar height
  static const double bottomNavHeight = 80.0;

  /// Bottom navigation bar height (compact)
  static const double bottomNavHeightCompact = 64.0;

  /// Bottom navigation item width
  static const double bottomNavItemWidth = 64.0;

  /// Bottom navigation icon size
  static const double bottomNavIconSize = 24.0;

  // ============================================
  // HELPER METHODS
  // ============================================
  
  /// EdgeInsets with equal padding
  static EdgeInsets all(double value) => EdgeInsets.all(value);
  
  /// EdgeInsets symmetric
  static EdgeInsets symmetric({double h = 0, double v = 0}) => 
      EdgeInsets.symmetric(horizontal: h, vertical: v);
  
  /// Standard card padding
  static EdgeInsets get cardInsets => const EdgeInsets.all(cardPadding);
  
  /// Screen safe area padding
  static EdgeInsets get screenInsets => const EdgeInsets.all(screenPadding);
}

// Backwards compatibility alias
typedef GlassSpacing = NeumorphicSpacing;
