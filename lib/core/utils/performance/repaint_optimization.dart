/// RepaintBoundary Optimization Utilities
///
/// Tools for isolating widget repaints to achieve 60 FPS
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// RepaintBoundary utilities for performance optimization
class RepaintOptimization {
  /// Wrap widget with RepaintBoundary to isolate repaints
  ///
  /// Use for:
  /// - Expensive widgets (charts, images, complex UI)
  /// - Animated widgets that change frequently
  /// - Widgets that don't need to repaint with parent
  ///
  /// Example:
  /// ```dart
  /// RepaintOptimization.isolate(
  ///   child: ExpensiveChart(),
  /// )
  /// ```
  static Widget isolate(Widget child, {String? debugLabel}) {
    return RepaintBoundary(
      child: debugLabel != null && kDebugMode
          ? DebugLabeledWidget(label: debugLabel, child: child)
          : child,
    );
  }

  /// Wrap multiple widgets with RepaintBoundary
  static List<Widget> isolateMultiple(
    List<Widget> children, {
    String? debugPrefix,
  }) {
    return List.generate(
      children.length,
      (index) => isolate(
        children[index],
        debugLabel: debugPrefix != null ? '$debugPrefix-$index' : null,
      ),
    );
  }

  /// Check if widget should use RepaintBoundary
  ///
  /// Guidelines:
  /// - Use for animated widgets
  /// - Use for expensive static widgets (images, charts)
  /// - Don't use for simple text/icons
  /// - Don't use excessively (adds overhead)
  static bool shouldIsolate({
    required bool isAnimated,
    required bool isExpensive,
    required bool changesFrequently,
  }) {
    return isAnimated || (isExpensive && changesFrequently);
  }
}

/// Debug widget label for RepaintBoundary
class DebugLabeledWidget extends StatelessWidget {
  final String label;
  final Widget child;

  const DebugLabeledWidget({
    super.key,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
