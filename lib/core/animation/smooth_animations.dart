/// Smooth Animations System
///
/// Water-smooth 60 FPS animation system with spring physics
/// Inspired by iOS, Telegram, and modern Material Design 3
///
/// Features:
/// - Spring physics for natural, bouncy animations
/// - Optimized AnimationController management
/// - Micro-interactions and staggered animations
/// - Performance-first architecture with RepaintBoundary
library;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

// Export constants
export 'constants/spring_constants.dart';
export 'constants/animation_durations.dart';
export 'constants/smooth_curves.dart';

// Export widgets
export 'widgets/smooth_fade_in.dart';
export 'widgets/smooth_slide.dart';
export 'widgets/smooth_scale.dart';
export 'widgets/shimmer_effect.dart';
export 'widgets/micro_interaction.dart';

// Import for internal use
import 'constants/animation_durations.dart';
import 'constants/smooth_curves.dart';
import 'widgets/smooth_fade_in.dart';
import 'widgets/smooth_slide.dart';
import 'widgets/smooth_scale.dart';
import 'widgets/shimmer_effect.dart';
import 'smooth_animations_core.dart';

/// Smooth Animations - Core animation utilities facade
class SmoothAnimations {
  /// Smooth fade in animation widget
  static Widget fadeIn({
    required Widget child,
    Duration duration = AnimationDurations.normal,
    Duration? delay,
    Curve curve = SmoothCurves.easeOut,
    bool addRepaintBoundary = true,
  }) {
    return SmoothFadeIn(
      duration: duration,
      delay: delay,
      curve: curve,
      addRepaintBoundary: addRepaintBoundary,
      child: child,
    );
  }

  /// Smooth slide animation widget
  static Widget slideIn({
    required Widget child,
    Offset begin = const Offset(0, 0.05),
    Offset end = Offset.zero,
    Duration duration = AnimationDurations.normal,
    Duration? delay,
    Curve curve = SmoothCurves.emphasized,
    bool addRepaintBoundary = true,
  }) {
    return SmoothSlide(
      begin: begin,
      end: end,
      duration: duration,
      delay: delay,
      curve: curve,
      addRepaintBoundary: addRepaintBoundary,
      child: child,
    );
  }

  /// Smooth scale animation widget
  static Widget scaleIn({
    required Widget child,
    double begin = 0.95,
    double end = 1.0,
    Duration duration = AnimationDurations.normal,
    Duration? delay,
    Curve curve = SmoothCurves.emphasized,
    bool addRepaintBoundary = true,
  }) {
    return SmoothScale(
      begin: begin,
      end: end,
      duration: duration,
      delay: delay,
      curve: curve,
      addRepaintBoundary: addRepaintBoundary,
      child: child,
    );
  }

  /// Shimmer loading animation for skeleton screens
  static Widget shimmer({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return ShimmerEffect(
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
      child: child,
    );
  }

  /// Staggered list animation
  static List<Widget> staggeredList({
    required List<Widget> children,
    Duration staggerDelay = AnimationDurations.staggerMedium,
    Duration itemDuration = AnimationDurations.normal,
    Curve curve = SmoothCurves.emphasized,
    bool fadeIn = true,
    bool slideIn = true,
    bool scaleIn = false,
  }) {
    return List.generate(children.length, (index) {
      final delay = staggerDelay * index;
      Widget child = children[index];

      if (scaleIn) {
        child = SmoothScale(
          begin: 0.95,
          end: 1.0,
          duration: itemDuration,
          delay: delay,
          curve: curve,
          addRepaintBoundary: true,
          child: child,
        );
      }

      if (slideIn) {
        child = SmoothSlide(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
          duration: itemDuration,
          delay: delay,
          curve: curve,
          addRepaintBoundary: true,
          child: child,
        );
      }

      if (fadeIn) {
        child = SmoothFadeIn(
          duration: itemDuration,
          delay: delay,
          curve: curve,
          addRepaintBoundary: true,
          child: child,
        );
      }

      return child;
    });
  }

  /// Pulse animation for attention-grabbing
  static Widget pulse({
    required Widget child,
    required AnimationController controller,
    double minScale = 0.95,
    double maxScale = 1.05,
    Curve curve = Curves.easeInOut,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: minScale, end: maxScale).animate(
        CurvedAnimation(parent: controller, curve: curve),
      ),
      child: child,
    );
  }

  /// Delegated methods from core
  static AnimationController createController({
    required TickerProvider vsync,
    Duration duration = AnimationDurations.normal,
    Duration? reverseDuration,
    double initialValue = 0.0,
    double lowerBound = 0.0,
    double upperBound = 1.0,
    AnimationBehavior animationBehavior = AnimationBehavior.normal,
  }) {
    return SmoothAnimationsCore.createController(
      vsync: vsync,
      duration: duration,
      reverseDuration: reverseDuration,
      initialValue: initialValue,
      lowerBound: lowerBound,
      upperBound: upperBound,
      animationBehavior: animationBehavior,
    );
  }

  static SpringSimulation createSpringSimulation({
    required double start,
    required double end,
    required double velocity,
    SpringDescription spring = const SpringDescription(
      mass: 1.0,
      stiffness: 180.0,
      damping: 22.0,
    ),
  }) {
    return SmoothAnimationsCore.createSpringSimulation(
      start: start,
      end: end,
      velocity: velocity,
      spring: spring,
    );
  }
}