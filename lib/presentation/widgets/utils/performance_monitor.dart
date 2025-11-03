/// Performance monitoring utility for Flutter widgets
library;

import 'package:flutter/material.dart';

/// Widget wrapper that monitors build performance
///
/// Usage:
/// ```dart
/// PerformanceMonitor(
///   widgetName: 'MyComplexWidget',
///   child: MyComplexWidget(),
/// )
/// ```
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final String widgetName;
  final int thresholdMs;
  final bool enabled;

  const PerformanceMonitor({
    super.key,
    required this.child,
    required this.widgetName,
    this.thresholdMs = 16, // 60fps = 16ms per frame
    this.enabled = true,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  final _buildTimes = <Duration>[];
  late final Stopwatch _stopwatch;
  int _buildCount = 0;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    _stopwatch
      ..reset()
      ..start();

    final result = widget.child;

    _stopwatch.stop();
    _buildCount++;

    final elapsed = _stopwatch.elapsed;
    _buildTimes.add(elapsed);

    // Log if build time exceeds threshold
    if (_stopwatch.elapsedMilliseconds > widget.thresholdMs) {
      debugPrint(
        '⚠️ [Build #$_buildCount] ${widget.widgetName} exceeded threshold: '
        '${_stopwatch.elapsedMilliseconds}ms (threshold: ${widget.thresholdMs}ms)',
      );
    }

    // Keep only last 100 build times to avoid memory leak
    if (_buildTimes.length > 100) {
      _buildTimes.removeAt(0);
    }

    return result;
  }

  @override
  void dispose() {
    if (widget.enabled && _buildTimes.isNotEmpty) {
      _logPerformanceSummary();
    }
    super.dispose();
  }

  void _logPerformanceSummary() {
    final totalMicroseconds = _buildTimes
        .map((d) => d.inMicroseconds)
        .reduce((a, b) => a + b);
    final averageMicroseconds = totalMicroseconds ~/ _buildTimes.length;
    final averageMs = averageMicroseconds / 1000;

    final maxTime = _buildTimes
        .map((d) => d.inMilliseconds)
        .reduce((a, b) => a > b ? a : b);
    final minTime = _buildTimes
        .map((d) => d.inMilliseconds)
        .reduce((a, b) => a < b ? a : b);

    final exceededCount = _buildTimes
        .where((d) => d.inMilliseconds > widget.thresholdMs)
        .length;
    final exceededPercentage =
        (exceededCount / _buildTimes.length * 100).toStringAsFixed(1);

    debugPrint(
      '📊 Performance Summary for ${widget.widgetName}:\n'
      '  • Total builds: $_buildCount\n'
      '  • Average build time: ${averageMs.toStringAsFixed(2)}ms\n'
      '  • Min/Max: ${minTime}ms / ${maxTime}ms\n'
      '  • Exceeded threshold: $exceededCount times ($exceededPercentage%)\n'
      '  • Performance score: ${_calculateScore()}/100',
    );
  }

  int _calculateScore() {
    if (_buildTimes.isEmpty) return 100;

    final averageMicroseconds = _buildTimes
        .map((d) => d.inMicroseconds)
        .reduce((a, b) => a + b) ~/ _buildTimes.length;
    final averageMs = averageMicroseconds / 1000;

    // Perfect score if average is under 8ms
    if (averageMs <= 8) return 100;
    // Good score if under threshold
    if (averageMs <= widget.thresholdMs) return 90;
    // Degrading score based on how much we exceed threshold
    final excess = averageMs - widget.thresholdMs;
    final score = 90 - (excess * 5).clamp(0, 90);
    return score.round();
  }
}

/// Mixin for performance monitoring in stateful widgets
mixin PerformanceMonitorMixin<T extends StatefulWidget> on State<T> {
  final _frameTimes = <Duration>[];
  Stopwatch? _frameStopwatch;

  void startFrameMeasurement() {
    _frameStopwatch ??= Stopwatch();
    _frameStopwatch!
      ..reset()
      ..start();
  }

  void endFrameMeasurement(String label) {
    if (_frameStopwatch == null) return;

    _frameStopwatch!.stop();
    final elapsed = _frameStopwatch!.elapsed;
    _frameTimes.add(elapsed);

    if (elapsed.inMilliseconds > 16) {
      debugPrint('⚠️ $label frame exceeded 16ms: ${elapsed.inMilliseconds}ms');
    }
  }

  void logPerformanceMetrics(String widgetName) {
    if (_frameTimes.isEmpty) return;

    final averageMs = _frameTimes
        .map((d) => d.inMicroseconds)
        .reduce((a, b) => a + b) / _frameTimes.length / 1000;

    debugPrint(
      '📊 $widgetName performance: '
      'Average frame time: ${averageMs.toStringAsFixed(2)}ms',
    );
  }

  @override
  void dispose() {
    logPerformanceMetrics(widget.runtimeType.toString());
    super.dispose();
  }
}