/// Responsive Layout Widgets
///
/// Pre-built widgets for common responsive layout patterns
library;

import 'package:flutter/material.dart';
import 'breakpoint_config.dart';
import 'responsive_builder_core.dart';

/// Responsive layout widget with different layouts for each breakpoint
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final BreakpointConfig? breakpoints;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        switch (info.deviceType) {
          case DeviceType.mobile:
            return mobile;
          case DeviceType.tablet:
          case DeviceType.desktop:
            return tablet ?? mobile;
        }
      },
    );
  }
}

/// Responsive value widget that returns different values based on screen size
class ResponsiveValue<T> extends StatelessWidget {
  final T mobile;
  final T? tablet;
  final Widget Function(BuildContext context, T value) builder;
  final BreakpointConfig? breakpoints;

  const ResponsiveValue({
    super.key,
    required this.mobile,
    this.tablet,
    required this.builder,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        final value = _getValue(info.deviceType);
        return builder(context, value);
      },
    );
  }

  T _getValue(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
      case DeviceType.desktop:
        return tablet ?? mobile;
    }
  }
}

/// Responsive grid widget with adaptive column count
class ResponsiveGrid extends StatelessWidget {
  final int mobileColumns;
  final int? tabletColumns;
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final BreakpointConfig? breakpoints;

  const ResponsiveGrid({
    super.key,
    required this.mobileColumns,
    this.tabletColumns,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: breakpoints,
      builder: (context, info) {
        final columns = _getColumnCount(info.deviceType);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
            childAspectRatio: 1.0,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }

  int _getColumnCount(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return mobileColumns;
      case DeviceType.tablet:
        return tabletColumns ?? mobileColumns + 1;
      case DeviceType.desktop:
        return tabletColumns ?? mobileColumns + 2;
    }
  }
}
