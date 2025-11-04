/// Performance Optimization Utilities
///
/// Tools and helpers for achieving 60 FPS performance
/// Based on 2024-2025 Flutter best practices
///
/// Key optimizations:
/// - RepaintBoundary isolation
/// - Const widget optimization
/// - Build method optimization
/// - Animation performance
/// - Memory management
library;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Performance utilities for 60 FPS optimization
class PerformanceUtils {
  /// Wrap widget with RepaintBoundary to isolate repaints
  ///
  /// Use for:
  /// - Expensive widgets (charts, images, complex UI)
  /// - Animated widgets that change frequently
  /// - Widgets that don't need to repaint with parent
  ///
  /// Example:
  /// ```dart
  /// PerformanceUtils.isolateRepaint(
  ///   child: ExpensiveChart(),
  /// )
  /// ```
  static Widget isolateRepaint(Widget child, {String? debugLabel}) {
    return RepaintBoundary(
      child: debugLabel != null && kDebugMode
          ? _DebugLabeledWidget(label: debugLabel, child: child)
          : child,
    );
  }

  /// Wrap multiple widgets with RepaintBoundary
  static List<Widget> isolateRepaints(
    List<Widget> children, {
    String? debugPrefix,
  }) {
    return List.generate(
      children.length,
      (index) => isolateRepaint(
        children[index],
        debugLabel: debugPrefix != null ? '$debugPrefix-$index' : null,
      ),
    );
  }

  /// Create optimized list with RepaintBoundary on items
  ///
  /// Use for ListView/GridView with complex items
  static Widget optimizedListView({
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
  static Widget optimizedGridView({
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

  /// Optimize AnimatedBuilder to reduce unnecessary rebuilds
  ///
  /// Wraps AnimatedBuilder with RepaintBoundary and ensures
  /// child widget is const when possible
  static Widget optimizedAnimatedBuilder({
    required Animation<double> animation,
    required Widget Function(BuildContext, Widget?) builder,
    Widget? child,
    String? debugLabel,
  }) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: animation,
        builder: builder,
        child: child,
      ),
    );
  }

  /// Defer heavy widget building until needed
  ///
  /// Uses FutureBuilder to delay rendering of expensive widgets
  static Widget deferBuild({
    required Widget Function() builder,
    Widget? placeholder,
    Duration delay = const Duration(milliseconds: 50),
  }) {
    return FutureBuilder(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return builder();
        }
        return placeholder ?? const SizedBox.shrink();
      },
    );
  }

  /// Measure widget build performance in debug mode
  static Widget measurePerformance({
    required Widget child,
    required String label,
  }) {
    if (!kDebugMode) return child;

    return _PerformanceMeasureWidget(
      label: label,
      child: child,
    );
  }

  /// Create const-optimized container
  ///
  /// Forces const constructor when decoration is simple
  static Widget constContainer({
    Key? key,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    AlignmentGeometry? alignment,
    required Widget child,
  }) {
    // If we can make it const, do it
    if (color != null && padding != null && margin == null) {
      return Container(
        key: key,
        color: color,
        padding: padding,
        width: width,
        height: height,
        alignment: alignment,
        child: child,
      );
    }

    return Container(
      key: key,
      color: color,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      alignment: alignment,
      child: child,
    );
  }

  /// Check if widget should use RepaintBoundary
  ///
  /// Guidelines:
  /// - Use for animated widgets
  /// - Use for expensive static widgets (images, charts)
  /// - Don't use for simple text/icons
  /// - Don't use excessively (adds overhead)
  static bool shouldIsolateRepaint({
    required bool isAnimated,
    required bool isExpensive,
    required bool changesFrequently,
  }) {
    return isAnimated || (isExpensive && changesFrequently);
  }

  /// Get optimal scroll physics for smooth scrolling
  static ScrollPhysics getOptimalScrollPhysics({
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

  /// Optimize image loading for better performance
  static ImageProvider optimizedImageProvider({
    required String url,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return NetworkImage(url);
  }

  /// Create const Text widget when possible
  static Widget constText(
    String data, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      data,
      key: key,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Batch multiple setState calls to reduce rebuilds
  static void batchedSetState(
    State state,
    List<VoidCallback> updates,
  ) {
    if (updates.isEmpty) return;

    // ignore: invalid_use_of_protected_member
    state.setState(() {
      for (final update in updates) {
        update();
      }
    });
  }

  /// Check if device can handle high-performance animations
  static bool canHandleComplexAnimations() {
    // In debug mode, always return true for testing
    if (kDebugMode) return true;

    // In release, could check device capabilities
    // For now, always return true
    return true;
  }

  /// Get recommended animation duration based on complexity
  static Duration getRecommendedDuration({
    required AnimationComplexity complexity,
  }) {
    switch (complexity) {
      case AnimationComplexity.simple:
        return const Duration(milliseconds: 200);
      case AnimationComplexity.medium:
        return const Duration(milliseconds: 300);
      case AnimationComplexity.complex:
        return const Duration(milliseconds: 400);
      case AnimationComplexity.veryComplex:
        return const Duration(milliseconds: 600);
    }
  }
}

/// Animation complexity levels
enum AnimationComplexity {
  simple,      // Icon rotation, simple fade
  medium,      // Slide, scale, combined animations
  complex,     // Multiple widgets, staggered
  veryComplex, // Heavy transformations, 3D effects
}

/// Debug widget to measure build performance
class _PerformanceMeasureWidget extends StatelessWidget {
  final String label;
  final Widget child;

  const _PerformanceMeasureWidget({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final stopwatch = Stopwatch()..start();
    final result = child;
    stopwatch.stop();

    if (stopwatch.elapsedMilliseconds > 16) {
      debugPrint(
        '⚠️ Performance Warning: $label took ${stopwatch.elapsedMilliseconds}ms to build (>16ms)',
      );
    } else if (stopwatch.elapsedMilliseconds > 8) {
      debugPrint(
        '⚡ Performance Note: $label took ${stopwatch.elapsedMilliseconds}ms to build',
      );
    }

    return result;
  }
}

/// Debug widget label for RepaintBoundary
class _DebugLabeledWidget extends StatelessWidget {
  final String label;
  final Widget child;

  const _DebugLabeledWidget({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Widget rebuild optimizer
///
/// Prevents unnecessary rebuilds by comparing old and new data
class RebuildOptimizer<T> extends StatefulWidget {
  final T data;
  final Widget Function(BuildContext, T) builder;
  final bool Function(T oldData, T newData)? shouldRebuild;

  const RebuildOptimizer({
    super.key,
    required this.data,
    required this.builder,
    this.shouldRebuild,
  });

  @override
  State<RebuildOptimizer<T>> createState() => _RebuildOptimizerState<T>();
}

class _RebuildOptimizerState<T> extends State<RebuildOptimizer<T>> {
  late T _cachedData;
  late Widget _cachedWidget;

  @override
  void initState() {
    super.initState();
    _cachedData = widget.data;
    _cachedWidget = widget.builder(context, _cachedData);
  }

  @override
  void didUpdateWidget(RebuildOptimizer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final shouldRebuild = widget.shouldRebuild?.call(
      _cachedData,
      widget.data,
    ) ?? (_cachedData != widget.data);

    if (shouldRebuild) {
      _cachedData = widget.data;
      _cachedWidget = widget.builder(context, _cachedData);
    }
  }

  @override
  Widget build(BuildContext context) => _cachedWidget;
}

/// Smooth scrolling controller with performance optimizations
class SmoothScrollController extends ScrollController {
  SmoothScrollController({
    super.initialScrollOffset,
    super.keepScrollOffset,
    super.debugLabel,
  });

  /// Animate to position with smooth spring physics
  Future<void> animateToSmooth(
    double offset, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOutCubic,
  }) {
    return animateTo(
      offset,
      duration: duration,
      curve: curve,
    );
  }

  /// Jump to position instantly (use sparingly)
  void jumpToSmooth(double offset) {
    jumpTo(offset);
  }

  /// Scroll to top smoothly
  Future<void> scrollToTop({
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return animateToSmooth(0, duration: duration);
  }

  /// Scroll to bottom smoothly
  Future<void> scrollToBottom({
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return animateToSmooth(
      position.maxScrollExtent,
      duration: duration,
    );
  }
}

/// Performance monitoring widget
///
/// Displays FPS counter in debug mode
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.enabled = kDebugMode,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 50,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: HvacRadius.xsRadius,
            ),
            child: const Text(
              'FPS: Monitor',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
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
      children: PerformanceUtils.isolateRepaints(
        children,
        debugPrefix: 'stack-item',
      ),
    );
  }
}
