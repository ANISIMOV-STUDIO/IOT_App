/// Responsive Grid System
///
/// Adaptive grid layout that adjusts columns based on screen width
/// Optimized for mobile, tablet, and desktop displays
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
/// Responsive grid widget that adapts column count based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? childAspectRatio;
  final double? maxCrossAxisExtent;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.childAspectRatio,
    this.maxCrossAxisExtent,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Determine columns based on width
        int columns;
        double spacing;
        double aspectRatio;

        if (width < 600) {
          // Mobile: 1-2 columns
          columns = width < 400 ? 1 : 2;
          spacing = HvacSpacing.md;
          aspectRatio = childAspectRatio ?? 1.2;
        } else if (width < 900) {
          // Small tablet: 2 columns
          columns = 2;
          spacing = HvacSpacing.lg;
          aspectRatio = childAspectRatio ?? 1.3;
        } else if (width < 1200) {
          // Large tablet: 3 columns
          columns = 3;
          spacing = HvacSpacing.lg;
          aspectRatio = childAspectRatio ?? 1.3;
        } else {
          // Desktop: 4 columns
          columns = 4;
          spacing = HvacSpacing.xl;
          aspectRatio = childAspectRatio ?? 1.4;
        }

        // Use maxCrossAxisExtent if provided
        if (maxCrossAxisExtent != null) {
          return GridView.builder(
            padding: padding ?? EdgeInsets.all(spacing),
            shrinkWrap: shrinkWrap,
            physics: physics ?? const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxCrossAxisExtent!,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: aspectRatio,
            ),
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
          );
        }

        return GridView.builder(
          padding: padding ?? EdgeInsets.all(spacing),
          shrinkWrap: shrinkWrap,
          physics: physics ?? const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

/// Responsive staggered grid for varying item sizes
class ResponsiveStaggeredGrid extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveStaggeredGrid({
    super.key,
    required this.children,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 1200;

        final columns = isMobile ? 1 : (isTablet ? 2 : 3);
        final spacing = isMobile
            ? HvacSpacing.md
            : (isTablet ? HvacSpacing.lg : HvacSpacing.xl);

        return SingleChildScrollView(
          physics: physics ?? const BouncingScrollPhysics(),
          padding: padding ?? EdgeInsets.all(spacing),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: children.map((child) {
              return SizedBox(
                width: (width - (columns + 1) * spacing) / columns,
                child: child,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

/// Adaptive columns widget that switches between Row and Column
class AdaptiveColumns extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double breakpoint;
  final double spacing;

  const AdaptiveColumns({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.breakpoint = 600,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isColumn = constraints.maxWidth < breakpoint;

        if (isColumn) {
          return Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: _buildChildrenWithSpacing(true),
          );
        } else {
          return Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: _buildChildrenWithSpacing(false),
          );
        }
      },
    );
  }

  List<Widget> _buildChildrenWithSpacing(bool isColumn) {
    final widgets = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (isColumn) {
        widgets.add(children[i]);
        if (i < children.length - 1) {
          widgets.add(SizedBox(height: spacing.h));
        }
      } else {
        widgets.add(Expanded(child: children[i]));
        if (i < children.length - 1) {
          widgets.add(SizedBox(width: spacing.w));
        }
      }
    }
    return widgets;
  }
}