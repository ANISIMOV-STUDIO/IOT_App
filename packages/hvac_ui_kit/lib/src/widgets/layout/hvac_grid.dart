/// HVAC Grid - Responsive grid system
library;

import 'package:flutter/material.dart';
import '../../theme/spacing.dart';

/// Responsive grid layout
///
/// Features:
/// - Fixed or responsive column count
/// - Custom spacing
/// - Aspect ratio control
/// - Shrink wrap support
///
/// Usage:
/// ```dart
/// HvacGrid(
///   crossAxisCount: 2,
///   spacing: 16,
///   children: [
///     Card(child: Text('Item 1')),
///     Card(child: Text('Item 2')),
///   ],
/// )
/// ```
class HvacGrid extends StatelessWidget {
  /// Number of columns
  final int crossAxisCount;

  /// Grid spacing (both cross and main axis)
  final double spacing;

  /// Cross axis spacing (overrides spacing)
  final double? crossAxisSpacing;

  /// Main axis spacing (overrides spacing)
  final double? mainAxisSpacing;

  /// Child widgets
  final List<Widget> children;

  /// Child aspect ratio
  final double childAspectRatio;

  /// Shrink wrap
  final bool shrinkWrap;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Padding
  final EdgeInsets? padding;

  const HvacGrid({
    super.key,
    required this.crossAxisCount,
    this.spacing = HvacSpacing.md,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    required this.children,
    this.childAspectRatio = 1.0,
    this.shrinkWrap = true,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing ?? spacing,
      mainAxisSpacing: mainAxisSpacing ?? spacing,
      childAspectRatio: childAspectRatio,
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      padding: padding,
      children: children,
    );
  }
}

/// Responsive grid that adapts columns based on screen width
///
/// Usage:
/// ```dart
/// HvacResponsiveGrid(
///   children: [
///     Card(child: Text('Item 1')),
///     Card(child: Text('Item 2')),
///   ],
/// )
/// ```
class HvacResponsiveGrid extends StatelessWidget {
  /// Child widgets
  final List<Widget> children;

  /// Minimum item width
  final double minItemWidth;

  /// Grid spacing
  final double spacing;

  /// Child aspect ratio
  final double childAspectRatio;

  /// Shrink wrap
  final bool shrinkWrap;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Padding
  final EdgeInsets? padding;

  const HvacResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 150.0,
    this.spacing = HvacSpacing.md,
    this.childAspectRatio = 1.0,
    this.shrinkWrap = true,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount =
            (constraints.maxWidth / minItemWidth).floor().clamp(1, 6);

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: childAspectRatio,
          shrinkWrap: shrinkWrap,
          physics: physics ?? const NeverScrollableScrollPhysics(),
          padding: padding,
          children: children,
        );
      },
    );
  }
}

/// Grid with builder pattern
///
/// Usage:
/// ```dart
/// HvacGridBuilder(
///   itemCount: 10,
///   crossAxisCount: 2,
///   itemBuilder: (context, index) => Card(child: Text('Item $index')),
/// )
/// ```
class HvacGridBuilder extends StatelessWidget {
  /// Item count
  final int itemCount;

  /// Number of columns
  final int crossAxisCount;

  /// Grid spacing
  final double spacing;

  /// Item builder
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Child aspect ratio
  final double childAspectRatio;

  /// Shrink wrap
  final bool shrinkWrap;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Padding
  final EdgeInsets? padding;

  const HvacGridBuilder({
    super.key,
    required this.itemCount,
    required this.crossAxisCount,
    this.spacing = HvacSpacing.md,
    required this.itemBuilder,
    this.childAspectRatio = 1.0,
    this.shrinkWrap = true,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      padding: padding,
    );
  }
}

/// Staggered grid (Pinterest-style)
///
/// Usage:
/// ```dart
/// HvacStaggeredGrid(
///   crossAxisCount: 2,
///   children: [
///     SizedBox(height: 100, child: Card()),
///     SizedBox(height: 150, child: Card()),
///   ],
/// )
/// ```
class HvacStaggeredGrid extends StatelessWidget {
  /// Number of columns
  final int crossAxisCount;

  /// Grid spacing
  final double spacing;

  /// Child widgets (should have intrinsic heights)
  final List<Widget> children;

  const HvacStaggeredGrid({
    super.key,
    required this.crossAxisCount,
    this.spacing = HvacSpacing.md,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // Create columns
    final List<List<Widget>> columns =
        List.generate(crossAxisCount, (_) => []);

    // Distribute children across columns
    for (int i = 0; i < children.length; i++) {
      columns[i % crossAxisCount].add(children[i]);
      if (i % crossAxisCount < crossAxisCount - 1) {
        columns[i % crossAxisCount].add(SizedBox(height: spacing));
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        crossAxisCount,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < crossAxisCount - 1 ? spacing : 0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: columns[index],
            ),
          ),
        ),
      ),
    );
  }
}
