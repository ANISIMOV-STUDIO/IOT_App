/// HVAC Badge - Material Design 3 badge
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// Material Design 3 badge
///
/// Features:
/// - Notification badge with count
/// - Dot badge (no label)
/// - Custom colors
/// - Positioning
///
/// Usage:
/// ```dart
/// HvacBadge(
///   count: 5,
///   child: Icon(Icons.notifications),
/// )
/// ```
class HvacBadge extends StatelessWidget {
  /// Child widget
  final Widget child;

  /// Badge label (text or number)
  final String? label;

  /// Badge count (converts to label)
  final int? count;

  /// Badge background color
  final Color? backgroundColor;

  /// Badge text color
  final Color? textColor;

  /// Whether to show badge
  final bool isVisible;

  /// Whether to show as small dot
  final bool isSmall;

  const HvacBadge({
    super.key,
    required this.child,
    this.label,
    this.count,
    this.backgroundColor,
    this.textColor,
    this.isVisible = true,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    String? effectiveLabel = label;
    if (count != null) {
      effectiveLabel = count! > 99 ? '99+' : count.toString();
    }

    return Badge(
      label: effectiveLabel != null && !isSmall ? Text(effectiveLabel) : null,
      isLabelVisible: isVisible && (effectiveLabel != null || isSmall),
      backgroundColor: backgroundColor ?? HvacColors.error,
      textColor: textColor ?? Colors.white,
      smallSize: isSmall ? 8 : null,
      child: child,
    );
  }
}

/// Dot badge (small indicator)
///
/// Usage:
/// ```dart
/// HvacDotBadge(
///   child: Icon(Icons.notifications),
/// )
/// ```
class HvacDotBadge extends StatelessWidget {
  final Widget child;
  final Color? color;

  const HvacDotBadge({
    super.key,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return HvacBadge(
      backgroundColor: color,
      isSmall: true,
      child: child,
    );
  }
}

/// Count badge
///
/// Usage:
/// ```dart
/// HvacCountBadge(
///   count: 3,
///   child: Icon(Icons.shopping_cart),
/// )
/// ```
class HvacCountBadge extends StatelessWidget {
  final int count;
  final Widget child;
  final Color? backgroundColor;

  const HvacCountBadge({
    super.key,
    required this.count,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return HvacBadge(
      count: count,
      backgroundColor: backgroundColor,
      isVisible: count > 0,
      child: child,
    );
  }
}
