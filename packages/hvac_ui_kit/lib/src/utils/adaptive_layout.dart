/// Adaptive Layout System
///
/// Big-tech approach for responsive controls and layouts
/// Inspired by Airbnb, Google Material Design 3, and Netflix
library;

import 'package:flutter/material.dart';

/// Device size categories (Material Design 3 breakpoints)
enum DeviceSize {
  compact, // < 600dp (phones)
  medium, // 600-840dp (tablets, foldables)
  expanded, // > 840dp (desktops, large tablets)
}

/// Layout configuration based on device size
class AdaptiveLayout {
  /// Get current device size category
  static DeviceSize getDeviceSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return DeviceSize.compact;
    } else if (width < 840) {
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
      expanded: const EdgeInsets.all(24.0),
    );
  }

  /// Adaptive icon size
  static double iconSize(BuildContext context, {double base = 20}) {
    return getAdaptiveValue(
      context,
      compact: base,
      medium: (base * 1.2),
      expanded: (base * 1.4),
    );
  }

  /// Adaptive font size
  static double fontSize(BuildContext context, {double base = 14}) {
    return getAdaptiveValue(
      context,
      compact: base,
      medium: (base * 0.95),
      expanded: (base * 0.9),
    );
  }

  /// Adaptive spacing
  static double spacing(BuildContext context, {double base = 12}) {
    return getAdaptiveValue(
      context,
      compact: base,
      medium: (base * 1.2),
      expanded: (base * 1.4),
    );
  }

  /// Adaptive border radius
  static double borderRadius(BuildContext context, {double base = 12}) {
    return getAdaptiveValue(
      context,
      compact: base,
      medium: (base * 1.1),
      expanded: (base * 1.2),
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
    return getDeviceSize(context) == DeviceSize.expanded;
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
      expanded: 64.0,
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

  /// Get maximum content width (for large screens)
  static double? getMaxContentWidth(BuildContext context) {
    final size = getDeviceSize(context);

    if (size == DeviceSize.expanded) {
      return 1400.0; // Max width for ultra-wide screens
    }
    return null; // No limit on smaller screens
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
    final size = getDeviceSize(context);

    if (size == DeviceSize.compact) {
      return const RoundedRectSliderTrackShape();
    } else {
      // Thicker track for tablet/desktop
      return const RoundedRectSliderTrackShape();
    }
  }

  /// Get slider thumb size
  static double getSliderThumbRadius(BuildContext context) {
    return getAdaptiveValue(
      context,
      compact: 12.0,
      medium: 14.0,
      expanded: 16.0,
    );
  }

  /// Check if device supports hover (desktop/web)
  static bool supportsHover(BuildContext context) {
    // On web or desktop, we can use hover states
    return getDeviceSize(context) == DeviceSize.expanded;
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
