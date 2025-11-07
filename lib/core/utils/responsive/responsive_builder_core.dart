/// Core Responsive Builder
///
/// Base widget for building responsive layouts
library;

import 'package:flutter/material.dart';
import 'breakpoint_config.dart';
import 'responsive_info.dart';

/// Responsive builder for adaptive layouts
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    ResponsiveInfo responsiveInfo,
  ) builder;
  final BreakpointConfig? breakpoints;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final config = breakpoints ?? BreakpointConfig.defaultConfig;
        final info = ResponsiveInfo(
          deviceType: config.getDeviceType(constraints.maxWidth),
          screenSize: Size(constraints.maxWidth, constraints.maxHeight),
          orientation: MediaQuery.of(context).orientation,
          breakpoints: config,
        );
        return builder(context, info);
      },
    );
  }
}

/// Responsive extensions for BuildContext
extension ResponsiveExtensions on BuildContext {
  /// Get responsive information for current screen
  ResponsiveInfo get responsive {
    final size = MediaQuery.of(this).size;
    final orientation = MediaQuery.of(this).orientation;
    const config = BreakpointConfig.defaultConfig;

    return ResponsiveInfo(
      deviceType: config.getDeviceType(size.width),
      screenSize: size,
      orientation: orientation,
      breakpoints: config,
    );
  }

  /// Check if device is mobile
  bool get isMobile => responsive.isMobile;

  /// Check if device is tablet
  bool get isTablet => responsive.isTablet;

  /// Check if device is desktop
  bool get isDesktop => responsive.isDesktop;

  /// Check if orientation is portrait
  bool get isPortrait => responsive.isPortrait;

  /// Check if orientation is landscape
  bool get isLandscape => responsive.isLandscape;
}
