import 'package:flutter/material.dart';

/// Responsive utilities for web-responsive snackbar system
class ResponsiveUtils {
  ResponsiveUtils._();

  /// Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Get device type from context
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return DeviceType.mobile;
    if (width < tabletBreakpoint) return DeviceType.tablet;
    if (width < desktopBreakpoint) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }

  /// Check if current device is mobile
  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  /// Check if current device is tablet
  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  /// Check if current device is desktop
  static bool isDesktop(BuildContext context) {
    final type = getDeviceType(context);
    return type == DeviceType.desktop || type == DeviceType.largeDesktop;
  }

  /// Scale font size based on device width
  static double scaledFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = (width / 375).clamp(0.85, 1.5);
    return baseSize * scaleFactor;
  }

  /// Scale icon size based on device width
  static double scaledIconSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = (width / 375).clamp(0.9, 1.4);
    return baseSize * scaleFactor;
  }

  /// Get snackbar width based on device type
  static double? getSnackbarWidth(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return null; // Full width minus margins
      case DeviceType.tablet:
        return 500;
      case DeviceType.desktop:
        return 450;
      case DeviceType.largeDesktop:
        return 480;
    }
  }

  /// Get snackbar margin based on device type
  static EdgeInsets getSnackbarMargin(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.all(16);
      case DeviceType.tablet:
        return const EdgeInsets.all(24);
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return const EdgeInsets.all(32);
    }
  }

  /// Get toast width based on device type
  static double? getToastMaxWidth(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return null; // Full width minus padding
      case DeviceType.tablet:
        return 400;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 360;
    }
  }

  /// Get horizontal padding based on device type
  static double getHorizontalPadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 16;
      case DeviceType.tablet:
        return 20;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 24;
    }
  }

  /// Get vertical padding based on device type
  static double getVerticalPadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 12;
      case DeviceType.tablet:
        return 14;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 16;
    }
  }
}

/// Device types for responsive design
enum DeviceType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// Extension for responsive sizing
extension ResponsiveExtension on num {
  /// Responsive width
  double w(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (this * width / 375).clamp(toDouble() * 0.8, toDouble() * 1.5);
  }

  /// Responsive height
  double h(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return (this * height / 812).clamp(toDouble() * 0.8, toDouble() * 1.5);
  }

  /// Responsive font size
  double sp(BuildContext context) => ResponsiveUtils.scaledFontSize(context, toDouble());

  /// Responsive radius
  double r(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (this * width / 375).clamp(toDouble() * 0.8, toDouble() * 1.2);
  }
}