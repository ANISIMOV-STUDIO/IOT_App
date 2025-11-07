/// Core animation utilities for creating controllers and simulations
library;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'constants/animation_durations.dart';
import 'constants/spring_constants.dart';

class SmoothAnimationsCore {
  /// Create optimized AnimationController with proper disposal tracking
  static AnimationController createController({
    required TickerProvider vsync,
    Duration duration = AnimationDurations.normal,
    Duration? reverseDuration,
    double initialValue = 0.0,
    double lowerBound = 0.0,
    double upperBound = 1.0,
    AnimationBehavior animationBehavior = AnimationBehavior.normal,
  }) {
    return AnimationController(
      vsync: vsync,
      duration: duration,
      reverseDuration: reverseDuration,
      value: initialValue,
      lowerBound: lowerBound,
      upperBound: upperBound,
      animationBehavior: animationBehavior,
    );
  }

  /// Create spring simulation for natural motion
  static SpringSimulation createSpringSimulation({
    required double start,
    required double end,
    required double velocity,
    SpringDescription spring = SpringConstants.smooth,
  }) {
    return SpringSimulation(
      spring,
      start,
      end,
      velocity,
    );
  }
}
