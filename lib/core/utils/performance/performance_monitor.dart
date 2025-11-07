/// Performance Monitoring Widgets
///
/// Debug tools for measuring and monitoring performance
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Performance measurement utilities
class PerformanceMeasurement {
  /// Measure widget build performance in debug mode
  static Widget measure({
    required Widget child,
    required String label,
  }) {
    if (!kDebugMode) return child;

    return PerformanceMeasureWidget(
      label: label,
      child: child,
    );
  }
}

/// Debug widget to measure build performance
class PerformanceMeasureWidget extends StatelessWidget {
  final String label;
  final Widget child;

  const PerformanceMeasureWidget({
    super.key,
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
        'Performance Warning: $label took ${stopwatch.elapsedMilliseconds}ms to build (>16ms)',
      );
    } else if (stopwatch.elapsedMilliseconds > 8) {
      debugPrint(
        'Performance Note: $label took ${stopwatch.elapsedMilliseconds}ms to build',
      );
    }

    return result;
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
