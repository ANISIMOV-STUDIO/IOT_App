/// QR Scanner Responsive Utilities
///
/// Provides responsive design utilities for QR scanner screens
/// Supporting mobile, tablet, and desktop/web layouts
///
/// Note: This class provides QR-scanner-specific responsive utilities.
/// For general responsive design, prefer using `responsive` from hvac_ui_kit.
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

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
      deviceType == DeviceType.desktop || deviceType == DeviceType.largeDesktop;

  /// Get scanner frame size
  double get scannerFrameSize {
    switch (deviceType) {
      case DeviceType.mobile:
        return 250.0;
      case DeviceType.tablet:
        return 320.0;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 380.0;
    }
  }

  /// Get form container max width
  double get formMaxWidth {
    switch (deviceType) {
      case DeviceType.mobile:
        return double.infinity;
      case DeviceType.tablet:
        return 600.0;
      case DeviceType.desktop:
        return 600.0;
      case DeviceType.largeDesktop:
        return 700.0;
    }
  }

  /// Get horizontal padding
  double get horizontalPadding {
    switch (deviceType) {
      case DeviceType.mobile:
        return 24.0;
      case DeviceType.tablet:
        return 32.0;
      case DeviceType.desktop:
        return 48.0;
      case DeviceType.largeDesktop:
        return 64.0;
    }
  }

  /// Get vertical spacing
  double get verticalSpacing {
    switch (deviceType) {
      case DeviceType.mobile:
        return 16.0;
      case DeviceType.tablet:
        return 20.0;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 24.0;
    }
  }

  /// Get button height
  double get buttonHeight {
    switch (deviceType) {
      case DeviceType.mobile:
        return 48.0;
      case DeviceType.tablet:
        return 52.0;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 56.0;
    }
  }

  /// Get icon size for scanner UI
  double get iconSize {
    switch (deviceType) {
      case DeviceType.mobile:
        return 64.0;
      case DeviceType.tablet:
        return 80.0;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 96.0;
    }
  }

  /// Get corner marker size
  double get cornerMarkerSize {
    switch (deviceType) {
      case DeviceType.mobile:
        return 20.0;
      case DeviceType.tablet:
        return 24.0;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 28.0;
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
        return 12.0;
      case DeviceType.tablet:
        return 16.0;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 20.0;
    }
  }

  /// Get dialog width
  double get dialogWidth {
    switch (deviceType) {
      case DeviceType.mobile:
        return screenWidth * 0.9;
      case DeviceType.tablet:
        return 500.0;
      case DeviceType.desktop:
      case DeviceType.largeDesktop:
        return 550.0;
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
