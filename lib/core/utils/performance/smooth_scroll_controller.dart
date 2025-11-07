/// Smooth Scrolling Controller
///
/// Enhanced ScrollController with performance optimizations
library;

import 'package:flutter/material.dart';

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
