/// Responsive Utilities for Web Authentication
///
/// Provides responsive design utilities for web-first authentication screens
library;

import 'package:flutter/material.dart';

/// Responsive breakpoints for web
class WebBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
  static const double largeDesktop = 1920;
}

/// Responsive sizing for authentication screens
class AuthResponsive {
  final BuildContext context;
  late final double screenWidth;
  late final double screenHeight;

  AuthResponsive(this.context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
  }

  /// Get device type
  DeviceType get deviceType {
    if (screenWidth < WebBreakpoints.mobile) return DeviceType.mobile;
    if (screenWidth < WebBreakpoints.tablet) return DeviceType.tablet;
    if (screenWidth < WebBreakpoints.desktop) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }

  /// Check if mobile
  bool get isMobile => deviceType == DeviceType.mobile;

  /// Check if tablet
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Check if desktop
  bool get isDesktop =>
      deviceType == DeviceType.desktop || deviceType == DeviceType.largeDesktop;

  /// Get form max width
  double get formMaxWidth {
    switch (deviceType) {
      case DeviceType.mobile:
        return double.infinity;
      case DeviceType.tablet:
        return 500;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 450;
    }
  }

  /// Get horizontal padding
  double get horizontalPadding {
    switch (deviceType) {
      case DeviceType.mobile:
        return 24;
      case DeviceType.tablet:
        return 48;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 64;
    }
  }

  /// Get vertical spacing
  double get verticalSpacing {
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

  /// Get button height
  double get buttonHeight {
    switch (deviceType) {
      case DeviceType.mobile:
        return 48;
      case DeviceType.tablet:
        return 52;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 56;
    }
  }

  /// Get input field height
  double get inputHeight {
    switch (deviceType) {
      case DeviceType.mobile:
        return 56;
      case DeviceType.tablet:
        return 60;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 64;
    }
  }

  /// Get logo size
  double get logoSize {
    switch (deviceType) {
      case DeviceType.mobile:
        return 80;
      case DeviceType.tablet:
        return 100;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 120;
    }
  }

  /// Get font size multiplier
  double get fontMultiplier {
    switch (deviceType) {
      case DeviceType.mobile:
        return 1.0;
      case DeviceType.tablet:
        return 1.1;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 1.2;
    }
  }
}

/// Device types including desktop support
enum DeviceType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// Extension for responsive values with unique naming
extension AuthResponsiveExt on num {
  /// Scale value based on screen width
  double rw(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (this * width / 375).clamp(toDouble() * 0.8, toDouble() * 1.5);
  }

  /// Scale value based on screen height
  double rh(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return (this * height / 812).clamp(toDouble() * 0.8, toDouble() * 1.5);
  }

  /// Scale font size
  double rsp(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = (width / 375).clamp(0.85, 1.3);
    return this * scaleFactor;
  }
}
