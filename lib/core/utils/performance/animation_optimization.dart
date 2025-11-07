/// Animation Performance Utilities
///
/// Tools for optimizing animations to maintain 60 FPS
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Animation performance utilities
class AnimationOptimization {
  /// Optimize AnimatedBuilder to reduce unnecessary rebuilds
  ///
  /// Wraps AnimatedBuilder with RepaintBoundary and ensures
  /// child widget is const when possible
  static Widget animatedBuilder({
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
