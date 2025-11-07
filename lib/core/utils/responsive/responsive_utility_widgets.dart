/// Responsive Utility Widgets
///
/// Helper widgets for responsive padding, visibility, and text
library;

import 'package:flutter/material.dart';
import 'breakpoint_config.dart';
import 'responsive_builder_core.dart';

/// Responsive padding with different values for each breakpoint
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets mobile;
  final EdgeInsets? tablet;
  final BreakpointConfig? breakpoints;

  const ResponsivePadding({
    super.key,
    required this.child,
    required this.mobile,
    this.tablet,
    this.breakpoints,
  });

  /// Create responsive padding with uniform values
  factory ResponsivePadding.all({
    required Widget child,
    required double mobile,
    double? tablet,
    BreakpointConfig? breakpoints,
  }) {
    return ResponsivePadding(
      mobile: EdgeInsets.all(mobile),
      tablet: tablet != null ? EdgeInsets.all(tablet) : null,
      breakpoints: breakpoints,
      child: child,
    );
  }

  /// Create responsive padding with symmetric values
  factory ResponsivePadding.symmetric({
    required Widget child,
    double? mobileHorizontal,
    double? mobileVertical,
    double? tabletHorizontal,
    double? tabletVertical,
    BreakpointConfig? breakpoints,
  }) {
    return ResponsivePadding(
      mobile: EdgeInsets.symmetric(
        horizontal: mobileHorizontal ?? 0,
        vertical: mobileVertical ?? 0,
      ),
      tablet: (tabletHorizontal != null || tabletVertical != null)
          ? EdgeInsets.symmetric(
              horizontal: tabletHorizontal ?? 0,
              vertical: tabletVertical ?? 0,
            )
          : null,
      breakpoints: breakpoints,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        final padding = _getPadding(info.deviceType);
        return Padding(
          padding: padding,
          child: child,
        );
      },
    );
  }

  EdgeInsets _getPadding(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
      case DeviceType.desktop:
        return tablet ?? mobile;
    }
  }
}

/// Responsive visibility widget that shows/hides based on screen size
class ResponsiveVisibility extends StatelessWidget {
  final Widget child;
  final bool visibleOnMobile;
  final bool visibleOnTablet;
  final Widget? replacement;
  final BreakpointConfig? breakpoints;

  const ResponsiveVisibility({
    super.key,
    required this.child,
    this.visibleOnMobile = true,
    this.visibleOnTablet = true,
    this.replacement,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        final isVisible = _isVisible(info.deviceType);
        if (isVisible) {
          return child;
        }
        return replacement ?? const SizedBox.shrink();
      },
    );
  }

  bool _isVisible(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return visibleOnMobile;
      case DeviceType.tablet:
      case DeviceType.desktop:
        return visibleOnTablet;
    }
  }
}

/// Responsive text with different styles for each breakpoint
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? mobileStyle;
  final TextStyle? tabletStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final BreakpointConfig? breakpoints;

  const ResponsiveText(
    this.text, {
    super.key,
    this.mobileStyle,
    this.tabletStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        final style = _getTextStyle(info.deviceType);
        return Text(
          text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }

  TextStyle? _getTextStyle(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return mobileStyle;
      case DeviceType.tablet:
      case DeviceType.desktop:
        return tabletStyle ?? mobileStyle;
    }
  }
}
