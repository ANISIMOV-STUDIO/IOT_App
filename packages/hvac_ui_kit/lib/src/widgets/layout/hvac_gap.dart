/// HVAC Gap - Spacing widget using design system constants
library;

import 'package:flutter/material.dart';
import '../../theme/spacing.dart';

/// Spacing widget using HvacSpacing constants
///
/// Features:
/// - Vertical or horizontal spacing
/// - Design system aligned
/// - Named constructors for common sizes
///
/// Usage:
/// ```dart
/// Column(
///   children: [
///     Text('Item 1'),
///     HvacGap.md(),
///     Text('Item 2'),
///   ],
/// )
/// ```
class HvacGap extends StatelessWidget {
  /// Gap size in pixels
  final double size;

  /// Direction (vertical or horizontal)
  final Axis direction;

  const HvacGap({
    super.key,
    required this.size,
    this.direction = Axis.vertical,
  });

  // Vertical gaps
  const HvacGap.xxs({super.key})
      : size = HvacSpacing.xxs,
        direction = Axis.vertical;

  const HvacGap.xs({super.key})
      : size = HvacSpacing.xs,
        direction = Axis.vertical;

  const HvacGap.sm({super.key})
      : size = HvacSpacing.sm,
        direction = Axis.vertical;

  const HvacGap.md({super.key})
      : size = HvacSpacing.md,
        direction = Axis.vertical;

  const HvacGap.lg({super.key})
      : size = HvacSpacing.lg,
        direction = Axis.vertical;

  const HvacGap.xl({super.key})
      : size = HvacSpacing.xl,
        direction = Axis.vertical;

  const HvacGap.xxl({super.key})
      : size = HvacSpacing.xxl,
        direction = Axis.vertical;

  // Horizontal gaps
  const HvacGap.horizontalXxs({super.key})
      : size = HvacSpacing.xxs,
        direction = Axis.horizontal;

  const HvacGap.horizontalXs({super.key})
      : size = HvacSpacing.xs,
        direction = Axis.horizontal;

  const HvacGap.horizontalSm({super.key})
      : size = HvacSpacing.sm,
        direction = Axis.horizontal;

  const HvacGap.horizontalMd({super.key})
      : size = HvacSpacing.md,
        direction = Axis.horizontal;

  const HvacGap.horizontalLg({super.key})
      : size = HvacSpacing.lg,
        direction = Axis.horizontal;

  const HvacGap.horizontalXl({super.key})
      : size = HvacSpacing.xl,
        direction = Axis.horizontal;

  const HvacGap.horizontalXxl({super.key})
      : size = HvacSpacing.xxl,
        direction = Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: direction == Axis.horizontal ? size : null,
      height: direction == Axis.vertical ? size : null,
    );
  }
}

/// Flexible spacer that expands to fill available space
///
/// Usage:
/// ```dart
/// Row(
///   children: [
///     Text('Left'),
///     HvacSpacer(),
///     Text('Right'),
///   ],
/// )
/// ```
class HvacSpacer extends StatelessWidget {
  final int flex;

  const HvacSpacer({
    super.key,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Spacer(flex: flex);
  }
}

/// Expanded wrapper
///
/// Usage:
/// ```dart
/// Row(
///   children: [
///     HvacExpanded(child: Text('Takes all space')),
///     Text('Fixed'),
///   ],
/// )
/// ```
class HvacExpanded extends StatelessWidget {
  final Widget child;
  final int flex;

  const HvacExpanded({
    super.key,
    required this.child,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: child,
    );
  }
}

/// Padding wrapper using HvacSpacing constants
///
/// Usage:
/// ```dart
/// HvacPadding.all(
///   size: HvacSpacing.md,
///   child: Text('Padded content'),
/// )
/// ```
class HvacPadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const HvacPadding({
    super.key,
    required this.child,
    required this.padding,
  });

  HvacPadding.all({
    super.key,
    required this.child,
    required double size,
  }) : padding = EdgeInsets.all(size);

  HvacPadding.symmetric({
    super.key,
    required this.child,
    double horizontal = 0,
    double vertical = 0,
  }) : padding = EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        );

  HvacPadding.only({
    super.key,
    required this.child,
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) : padding = EdgeInsets.only(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
        );

  // Named constructors for common padding sizes
  const HvacPadding.xs({
    super.key,
    required this.child,
  }) : padding = const EdgeInsets.all(HvacSpacing.xs);

  const HvacPadding.sm({
    super.key,
    required this.child,
  }) : padding = const EdgeInsets.all(HvacSpacing.sm);

  const HvacPadding.md({
    super.key,
    required this.child,
  }) : padding = const EdgeInsets.all(HvacSpacing.md);

  const HvacPadding.lg({
    super.key,
    required this.child,
  }) : padding = const EdgeInsets.all(HvacSpacing.lg);

  const HvacPadding.xl({
    super.key,
    required this.child,
  }) : padding = const EdgeInsets.all(HvacSpacing.xl);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}
