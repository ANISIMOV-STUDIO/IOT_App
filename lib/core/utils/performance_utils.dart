/// Performance Optimization Utilities
///
/// Tools and helpers for achieving 60 FPS performance
/// Based on 2024-2025 Flutter best practices
///
/// Key optimizations:
/// - RepaintBoundary isolation
/// - Build method optimization
/// - Animation performance
/// - Memory management
library;

// Export all performance optimization modules
export 'performance/repaint_optimization.dart';
export 'performance/list_optimization.dart';
export 'performance/animation_optimization.dart';
export 'performance/rebuild_optimization.dart';
export 'performance/performance_monitor.dart';
export 'performance/smooth_scroll_controller.dart';

import 'package:flutter/material.dart';
import 'performance/repaint_optimization.dart';
import 'performance/list_optimization.dart';
import 'performance/animation_optimization.dart';
import 'performance/rebuild_optimization.dart';

/// Main performance utilities class providing common optimization helpers
class PerformanceUtils {
  // Repaint optimization shortcuts
  static Widget isolateRepaint(Widget child, {String? debugLabel}) =>
      RepaintOptimization.isolate(child, debugLabel: debugLabel);

  static List<Widget> isolateRepaints(
    List<Widget> children, {
    String? debugPrefix,
  }) =>
      RepaintOptimization.isolateMultiple(children, debugPrefix: debugPrefix);

  // List optimization shortcuts
  static Widget optimizedListView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    ScrollController? controller,
    Axis scrollDirection = Axis.vertical,
    bool addRepaintBoundary = true,
  }) =>
      ListOptimization.listView(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        physics: physics,
        padding: padding,
        shrinkWrap: shrinkWrap,
        controller: controller,
        scrollDirection: scrollDirection,
        addRepaintBoundary: addRepaintBoundary,
      );

  static Widget optimizedGridView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    required SliverGridDelegate gridDelegate,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    ScrollController? controller,
    bool addRepaintBoundary = true,
  }) =>
      ListOptimization.gridView(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        gridDelegate: gridDelegate,
        physics: physics,
        padding: padding,
        shrinkWrap: shrinkWrap,
        controller: controller,
        addRepaintBoundary: addRepaintBoundary,
      );

  // Animation optimization shortcuts
  static Widget optimizedAnimatedBuilder({
    required Animation<double> animation,
    required Widget Function(BuildContext, Widget?) builder,
    Widget? child,
    String? debugLabel,
  }) =>
      AnimationOptimization.animatedBuilder(
        animation: animation,
        builder: builder,
        child: child,
        debugLabel: debugLabel,
      );

  // Rebuild optimization shortcuts
  static Widget deferBuild({
    required Widget Function() builder,
    Widget? placeholder,
    Duration delay = const Duration(milliseconds: 50),
  }) =>
      RebuildOptimization.deferBuild(
        builder: builder,
        placeholder: placeholder,
        delay: delay,
      );

  static void batchedSetState(State state, List<VoidCallback> updates) =>
      RebuildOptimization.batchedSetState(state, updates);

  // Utility methods
  static ScrollPhysics getOptimalScrollPhysics({
    bool bouncing = true,
    bool alwaysScrollable = true,
  }) =>
      ListOptimization.getOptimalPhysics(
        bouncing: bouncing,
        alwaysScrollable: alwaysScrollable,
      );
}
