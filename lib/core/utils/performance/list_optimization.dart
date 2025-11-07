/// Optimized List and Grid Builders
///
/// Performance-optimized ListView and GridView builders with RepaintBoundary
library;

import 'package:flutter/material.dart';
import 'repaint_optimization.dart';

/// List and grid view optimization utilities
class ListOptimization {
  /// Create optimized list with RepaintBoundary on items
  ///
  /// Use for ListView with complex items
  static Widget listView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    ScrollController? controller,
    Axis scrollDirection = Axis.vertical,
    bool addRepaintBoundary = true,
  }) {
    return ListView.builder(
      itemCount: itemCount,
      controller: controller,
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      itemBuilder: (context, index) {
        final item = itemBuilder(context, index);
        return addRepaintBoundary
            ? RepaintBoundary(child: item)
            : item;
      },
    );
  }

  /// Create optimized grid view
  static Widget gridView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    required SliverGridDelegate gridDelegate,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    ScrollController? controller,
    bool addRepaintBoundary = true,
  }) {
    return GridView.builder(
      itemCount: itemCount,
      gridDelegate: gridDelegate,
      controller: controller,
      physics: physics,
      padding: padding,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        final item = itemBuilder(context, index);
        return addRepaintBoundary
            ? RepaintBoundary(child: item)
            : item;
      },
    );
  }

  /// Get optimal scroll physics for smooth scrolling
  static ScrollPhysics getOptimalPhysics({
    bool bouncing = true,
    bool alwaysScrollable = true,
  }) {
    if (bouncing) {
      return alwaysScrollable
          ? const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            )
          : const BouncingScrollPhysics();
    } else {
      return alwaysScrollable
          ? const ClampingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            )
          : const ClampingScrollPhysics();
    }
  }
}

/// Optimized stack that only rebuilds changed children
class OptimizedStack extends StatelessWidget {
  final List<Widget> children;
  final AlignmentGeometry alignment;
  final StackFit fit;
  final Clip clipBehavior;

  const OptimizedStack({
    super.key,
    required this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      fit: fit,
      clipBehavior: clipBehavior,
      children: RepaintOptimization.isolateMultiple(
        children,
        debugPrefix: 'stack-item',
      ),
    );
  }
}
