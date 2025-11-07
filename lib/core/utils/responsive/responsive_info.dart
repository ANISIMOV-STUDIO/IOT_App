/// Responsive Information
///
/// Contains current screen state information for responsive layouts
library;

import 'package:flutter/material.dart';
import 'breakpoint_config.dart';

/// Information about the current responsive state
class ResponsiveInfo {
  final DeviceType deviceType;
  final Size screenSize;
  final Orientation orientation;
  final BreakpointConfig breakpoints;

  const ResponsiveInfo({
    required this.deviceType,
    required this.screenSize,
    required this.orientation,
    required this.breakpoints,
  });

  /// Check if device is mobile
  bool get isMobile => deviceType == DeviceType.mobile;

  /// Check if device is tablet
  bool get isTablet => deviceType == DeviceType.tablet;

  /// Check if device is desktop
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Check if orientation is portrait
  bool get isPortrait => orientation == Orientation.portrait;

  /// Check if orientation is landscape
  bool get isLandscape => orientation == Orientation.landscape;

  /// Screen width
  double get width => screenSize.width;

  /// Screen height
  double get height => screenSize.height;

  /// Screen aspect ratio (width / height)
  double get aspectRatio => width / height;
}
