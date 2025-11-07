/// Performance Utilities
///
/// Utilities for performance monitoring and optimization
library;

import 'package:flutter/material.dart';

/// Performance utilities for HVAC UI Kit
class PerformanceUtils {
  PerformanceUtils._();

  /// Check if a widget should rebuild
  static bool shouldRebuild(Object oldWidget, Object newWidget) {
    return oldWidget != newWidget;
  }

  /// Create a const-safe key
  static Key createKey(String value) => ValueKey(value);

  /// Check if device is low-end
  static bool isLowEndDevice(BuildContext context) {
    // Simple heuristic - can be enhanced with device_info_plus
    return MediaQuery.of(context).size.width < 360;
  }

  /// Get optimal image quality based on device
  static FilterQuality getOptimalImageQuality(BuildContext context) {
    return isLowEndDevice(context) ? FilterQuality.low : FilterQuality.medium;
  }

  /// Debounce duration for user input
  static const Duration debounceDuration = Duration(milliseconds: 300);

  /// Throttle duration for scroll events
  static const Duration throttleDuration = Duration(milliseconds: 16);

  /// Get optimal scroll physics for current device
  static ScrollPhysics getOptimalScrollPhysics(
    BuildContext context, {
    bool bouncing = true,
    bool alwaysScrollable = false,
  }) {
    if (alwaysScrollable) {
      return bouncing
          ? const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            )
          : const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            );
    }
    return isLowEndDevice(context) || !bouncing
        ? const ClampingScrollPhysics()
        : const BouncingScrollPhysics();
  }

  /// Isolate repaint boundary for performance
  static Widget isolateRepaint({
    required Widget child,
  }) {
    return RepaintBoundary(child: child);
  }
}
