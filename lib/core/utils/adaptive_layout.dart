/// Adaptive Layout System
///
/// Big-tech approach for responsive controls and layouts
/// Inspired by Airbnb, Google Material Design 3, and Netflix
library;

import 'package:flutter/material.dart';

/// Device size categories (Material Design 3 breakpoints)
/// Full responsive support: mobile, tablet, and desktop
enum DeviceSize {
  compact, // < 600dp (phones)
  medium, // 600-1024dp (tablets, foldables)
  expanded, // 1024dp+ (desktops, large screens)
}

/// Layout configuration based on device size
class AdaptiveLayout {
  /// Get current device size category
  static DeviceSize getDeviceSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return DeviceSize.compact;
    } else if (width < 1024) {
      return DeviceSize.medium;
    } else {
      return DeviceSize.expanded;
    }
  }

  /// Get adaptive value based on device size
  static T getAdaptiveValue<T>(
    BuildContext context, {
    required T compact,
    T? medium,
    T? expanded,
  }) {
    final size = getDeviceSize(context);

    switch (size) {
      case DeviceSize.compact:
        return compact;
      case DeviceSize.medium:
        return medium ?? compact;
      case DeviceSize.expanded:
        return expanded ?? medium ?? compact;
    }
  }

  /// Adaptive padding for controls
  static EdgeInsets controlPadding(BuildContext context) {
    return getAdaptiveValue(
      context,
      compact: const EdgeInsets.all(16.0),
      medium: const EdgeInsets.all(20.0),
      expanded:
          const EdgeInsets.all(16.0), // Standard for desktop with fixed width
    );
  }

  /// Adaptive icon size
  static double iconSize(BuildContext context, {double base = 20}) {
    return getAdaptiveValue(
      context,
      compact: base,
      medium: base * 1.2,
      expanded: base, // Same as mobile for desktop
    );
  }

  /// Adaptive font size
  static double fontSize(BuildContext context, {double base = 14}) {
    return getAdaptiveValue(
      context,
      compact: base,
      medium: base * 0.95,
      expanded: base, // Same as mobile for desktop
    );
  }

  /// Adaptive spacing
  static double spacing(BuildContext context, {double base = 12}) {
    return getAdaptiveValue(
      context,
      compact: base,
      medium: base * 1.2,
      expanded: base, // Same as mobile for desktop with fixed width
    );
  }

  /// Adaptive border radius
  static double borderRadius(BuildContext context, {double base = 12}) {
    return getAdaptiveValue(
      context,
      compact: base,
      medium: base * 1.1,
      expanded: base * 1.2,
    );
  }

  /// Check if should use single column layout
  static bool useSingleColumn(BuildContext context) {
    return getDeviceSize(context) == DeviceSize.compact;
  }

  /// Check if should use two column layout
  static bool useTwoColumn(BuildContext context) {
    return getDeviceSize(context) == DeviceSize.medium;
  }

  /// Check if should use multi-column layout
  static bool useMultiColumn(BuildContext context) {
    final size = getDeviceSize(context);
    return size == DeviceSize.medium || size == DeviceSize.expanded;
  }

  /// Get number of columns for grid
  static int getGridColumns(BuildContext context) {
    return getAdaptiveValue(
      context,
      compact: 1,
      medium: 2,
      expanded: 3,
    );
  }

  /// Get slider height (important for touch targets)
  static double getSliderHeight(BuildContext context) {
    return getAdaptiveValue(
      context,
      compact: 48.0, // Material minimum touch target
      medium: 56.0,
      expanded: 56.0,
    );
  }

  /// Get control card height
  static double getControlCardHeight(BuildContext context) {
    return getAdaptiveValue(
          context,
          compact: null, // Auto height
          medium: 200.0,
          expanded: 220.0,
        ) ??
        double.infinity;
  }

  /// Get maximum content width (for desktop - prevents content stretching)
  static double? getMaxContentWidth(BuildContext context) {
    return getDeviceSize(context) == DeviceSize.expanded ? 1400.0 : null;
  }

  /// Build adaptive layout with different widgets per size
  static Widget buildAdaptive(
    BuildContext context, {
    required Widget compact,
    Widget? medium,
    Widget? expanded,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = getDeviceSize(context);

        switch (size) {
          case DeviceSize.compact:
            return compact;
          case DeviceSize.medium:
            return medium ?? compact;
          case DeviceSize.expanded:
            return expanded ?? medium ?? compact;
        }
      },
    );
  }

  /// Get slider track shape based on device
  static SliderTrackShape getSliderTrackShape(BuildContext context) {
    // Same track shape for all mobile and tablet devices
    return const RoundedRectSliderTrackShape();
  }

  /// Get slider thumb size
  static double getSliderThumbRadius(BuildContext context) {
    return getAdaptiveValue(
      context,
      compact: 12.0,
      medium: 14.0,
    );
  }

  /// Check if device supports hover
  static bool supportsHover(BuildContext context) {
    // Mobile and tablet primarily use touch, minimal hover support needed
    return false;
  }
}

/// Adaptive control widget wrapper
class AdaptiveControl extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceSize size) builder;

  const AdaptiveControl({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = AdaptiveLayout.getDeviceSize(context);
        return builder(context, size);
      },
    );
  }
}
