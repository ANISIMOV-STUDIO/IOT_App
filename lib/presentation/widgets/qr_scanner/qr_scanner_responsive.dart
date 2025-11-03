/// QR Scanner Responsive Utilities
///
/// Provides responsive design utilities for QR scanner screens
/// Supporting mobile, tablet, and desktop/web layouts
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive breakpoints for QR scanner
class QrScannerBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
  static const double largeDesktop = 1920;
}

/// Responsive sizing for QR scanner screens
class QrScannerResponsive {
  final BuildContext context;
  late final double screenWidth;
  late final double screenHeight;

  QrScannerResponsive(this.context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
  }

  /// Get device type
  DeviceType get deviceType {
    if (screenWidth < QrScannerBreakpoints.mobile) return DeviceType.mobile;
    if (screenWidth < QrScannerBreakpoints.tablet) return DeviceType.tablet;
    if (screenWidth < QrScannerBreakpoints.desktop) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }

  /// Check if mobile
  bool get isMobile => deviceType == DeviceType.mobile;

  /// Check if tablet
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Check if desktop or web
  bool get isDesktop =>
      deviceType == DeviceType.desktop ||
      deviceType == DeviceType.largeDesktop;

  /// Get scanner frame size
  double get scannerFrameSize {
    switch (deviceType) {
      case DeviceType.mobile:
        return 250.w;
      case DeviceType.tablet:
        return 320.w;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 380.w;
    }
  }

  /// Get form container max width
  double get formMaxWidth {
    switch (deviceType) {
      case DeviceType.mobile:
        return double.infinity;
      case DeviceType.tablet:
        return 600.w;
      case DeviceType.desktop:
        return 600.w;
      case DeviceType.largeDesktop:
        return 700.w;
    }
  }

  /// Get horizontal padding
  double get horizontalPadding {
    switch (deviceType) {
      case DeviceType.mobile:
        return 24.w;
      case DeviceType.tablet:
        return 32.w;
      case DeviceType.desktop:
        return 48.w;
      case DeviceType.largeDesktop:
        return 64.w;
    }
  }

  /// Get vertical spacing
  double get verticalSpacing {
    switch (deviceType) {
      case DeviceType.mobile:
        return 16.h;
      case DeviceType.tablet:
        return 20.h;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 24.h;
    }
  }

  /// Get button height
  double get buttonHeight {
    switch (deviceType) {
      case DeviceType.mobile:
        return 48.h;
      case DeviceType.tablet:
        return 52.h;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 56.h;
    }
  }

  /// Get icon size for scanner UI
  double get iconSize {
    switch (deviceType) {
      case DeviceType.mobile:
        return 64.w;
      case DeviceType.tablet:
        return 80.w;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 96.w;
    }
  }

  /// Get corner marker size
  double get cornerMarkerSize {
    switch (deviceType) {
      case DeviceType.mobile:
        return 20.w;
      case DeviceType.tablet:
        return 24.w;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 28.w;
    }
  }

  /// Get camera view flex ratio
  int get cameraFlexRatio {
    switch (deviceType) {
      case DeviceType.mobile:
        return 3;
      case DeviceType.tablet:
        return 2;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 1;
    }
  }

  /// Get manual entry section flex ratio
  int get manualEntryFlexRatio {
    return 1;
  }

  /// Get border radius
  double get borderRadius {
    switch (deviceType) {
      case DeviceType.mobile:
        return 12.r;
      case DeviceType.tablet:
        return 16.r;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 20.r;
    }
  }

  /// Get dialog width
  double get dialogWidth {
    switch (deviceType) {
      case DeviceType.mobile:
        return screenWidth * 0.9;
      case DeviceType.tablet:
        return 500.w;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 550.w;
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