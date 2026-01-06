/// App Breakpoints - Centralized responsive breakpoint definitions
library;

import 'package:flutter/widgets.dart';

/// Responsive breakpoints for the application
///
/// Usage:
/// ```dart
/// final width = MediaQuery.sizeOf(context).width;
/// if (width >= AppBreakpoints.desktop) {
///   // Desktop layout
/// } else if (width >= AppBreakpoints.tablet) {
///   // Tablet layout
/// } else {
///   // Mobile layout
/// }
/// ```
abstract final class AppBreakpoints {
  /// Mobile phones (< 600dp)
  static const double mobile = 600;

  /// Tablets and small laptops (600-900dp)
  static const double tablet = 900;

  /// Desktop screens (900-1200dp)
  static const double desktop = 1200;

  /// Large desktop / widescreen (> 1440dp)
  static const double widescreen = 1440;

  /// Check if current width is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < mobile;
  }

  /// Check if current width is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < tablet;
  }

  /// Check if current width is desktop or larger
  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= tablet;
  }

  /// Check if current width is widescreen
  static bool isWidescreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= widescreen;
  }

  /// Get the current device type
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= widescreen) return DeviceType.widescreen;
    if (width >= tablet) return DeviceType.desktop;
    if (width >= mobile) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  /// Get number of columns for grid layout
  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= widescreen) return 4;
    if (width >= desktop) return 3;
    if (width >= tablet) return 2;
    return 1;
  }

  /// Get horizontal padding based on screen size
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= widescreen) return 48;
    if (width >= desktop) return 32;
    if (width >= tablet) return 24;
    return 16;
  }
}

/// Device type enum for cleaner conditionals
enum DeviceType {
  mobile,
  tablet,
  desktop,
  widescreen,
}

/// Extension for easier responsive checks
extension ResponsiveContext on BuildContext {
  /// Quick access to device type
  DeviceType get deviceType => AppBreakpoints.getDeviceType(this);

  /// Check if mobile
  bool get isMobile => AppBreakpoints.isMobile(this);

  /// Check if tablet
  bool get isTablet => AppBreakpoints.isTablet(this);

  /// Check if desktop or larger
  bool get isDesktop => AppBreakpoints.isDesktop(this);

  /// Check if widescreen
  bool get isWidescreen => AppBreakpoints.isWidescreen(this);

  /// Get responsive horizontal padding
  double get responsivePadding => AppBreakpoints.getHorizontalPadding(this);

  /// Get grid columns for current screen
  int get gridColumns => AppBreakpoints.getGridColumns(this);
}
