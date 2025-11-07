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
import 'dart:math' as math;

import 'animation_durations.dart';
import 'spring_curves.dart';

/// Smooth Animations - Core animation utilities
class SmoothAnimations {
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

  /// Smooth fade in animation widget
  static Widget fadeIn({
    required Widget child,
    Duration duration = AnimationDurations.normal,
    Duration? delay,
    Curve curve = SmoothCurves.easeOut,
    bool addRepaintBoundary = true,
  }) {
    return _SmoothFadeIn(
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
    return _SmoothSlide(
      begin: begin,
      end: end,
      duration: duration,
      delay: delay,
      curve: curve,
      addRepaintBoundary: addRepaintBoundary,
      child: child,
    );
  }

  /// Smooth scale animation widget with spring physics
  static Widget scaleIn({
    required Widget child,
    double begin = 0.95,
    double end = 1.0,
    Duration duration = AnimationDurations.normal,
    Duration? delay,
    Curve curve = SmoothCurves.emphasized,
    bool addRepaintBoundary = true,
  }) {
    return _SmoothScale(
      begin: begin,
      end: end,
      duration: duration,
      delay: delay,
      curve: curve,
      addRepaintBoundary: addRepaintBoundary,
      child: child,
    );
  }

  /// Spring-based scale animation for micro-interactions
  static Widget springScale({
    required Widget child,
    required AnimationController controller,
    double begin = 1.0,
    double end = 0.95,
    SpringDescription spring = SpringConstants.bouncy,
  }) {
    return _SpringScaleTransition(
      controller: controller,
      begin: begin,
      end: end,
      spring: spring,
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
        child = _SmoothScale(
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
        child = _SmoothSlide(
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
        child = _SmoothFadeIn(
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

  /// Shimmer loading animation for skeleton screens
  static Widget shimmer({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return _ShimmerEffect(
      baseColor: baseColor ?? Colors.grey.shade300,
      highlightColor: highlightColor ?? Colors.grey.shade100,
      duration: duration,
      child: child,
    );
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
}

/// Smooth fade in implementation
class _SmoothFadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration? delay;
  final Curve curve;
  final bool addRepaintBoundary;

  const _SmoothFadeIn({
    required this.child,
    required this.duration,
    this.delay,
    required this.curve,
    required this.addRepaintBoundary,
  });

  @override
  State<_SmoothFadeIn> createState() => _SmoothFadeInState();
}

class _SmoothFadeInState extends State<_SmoothFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = SmoothAnimations.createController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.delay != null) {
      Future.delayed(widget.delay!, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = FadeTransition(
      opacity: _animation,
      child: widget.child,
    );

    if (widget.addRepaintBoundary) {
      result = RepaintBoundary(child: result);
    }

    return result;
  }
}

/// Smooth slide implementation
class _SmoothSlide extends StatefulWidget {
  final Widget child;
  final Offset begin;
  final Offset end;
  final Duration duration;
  final Duration? delay;
  final Curve curve;
  final bool addRepaintBoundary;

  const _SmoothSlide({
    required this.child,
    required this.begin,
    required this.end,
    required this.duration,
    this.delay,
    required this.curve,
    required this.addRepaintBoundary,
  });

  @override
  State<_SmoothSlide> createState() => _SmoothSlideState();
}

class _SmoothSlideState extends State<_SmoothSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = SmoothAnimations.createController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<Offset>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.delay != null) {
      Future.delayed(widget.delay!, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = SlideTransition(
      position: _animation,
      child: widget.child,
    );

    if (widget.addRepaintBoundary) {
      result = RepaintBoundary(child: result);
    }

    return result;
  }
}

/// Smooth scale implementation
class _SmoothScale extends StatefulWidget {
  final Widget child;
  final double begin;
  final double end;
  final Duration duration;
  final Duration? delay;
  final Curve curve;
  final bool addRepaintBoundary;

  const _SmoothScale({
    required this.child,
    required this.begin,
    required this.end,
    required this.duration,
    this.delay,
    required this.curve,
    required this.addRepaintBoundary,
  });

  @override
  State<_SmoothScale> createState() => _SmoothScaleState();
}

class _SmoothScaleState extends State<_SmoothScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = SmoothAnimations.createController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.delay != null) {
      Future.delayed(widget.delay!, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = ScaleTransition(
      scale: _animation,
      child: widget.child,
    );

    if (widget.addRepaintBoundary) {
      result = RepaintBoundary(child: result);
    }

    return result;
  }
}

/// Spring scale transition with physics
class _SpringScaleTransition extends StatelessWidget {
  final AnimationController controller;
  final double begin;
  final double end;
  final SpringDescription spring;
  final Widget child;

  const _SpringScaleTransition({
    required this.controller,
    required this.begin,
    required this.end,
    required this.spring,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final simulation = SmoothAnimations.createSpringSimulation(
      start: begin,
      end: end,
      velocity: 0.0,
      spring: spring,
    );

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Transform.scale(
            scale: simulation.x(controller.value),
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}

/// Shimmer effect for loading states
class _ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const _ShimmerEffect({
    required this.child,
    required this.baseColor,
    required this.highlightColor,
    required this.duration,
  });

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SmoothAnimations.createController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                colors: [
                  widget.baseColor,
                  widget.highlightColor,
                  widget.baseColor,
                ],
                stops: [
                  math.max(0.0, _controller.value - 0.3),
                  _controller.value,
                  math.min(1.0, _controller.value + 0.3),
                ],
              ).createShader(bounds);
            },
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Micro-interaction wrapper for buttons and interactive elements
class MicroInteraction extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double scaleFactor;
  final SpringDescription spring;
  final bool enableHaptic;

  const MicroInteraction({
    super.key,
    required this.child,
    this.onTap,
    this.duration = AnimationDurations.microFast,
    this.scaleFactor = 0.95,
    this.spring = SpringConstants.snappy,
    this.enableHaptic = true,
  });

  @override
  State<MicroInteraction> createState() => _MicroInteractionState();
}

class _MicroInteractionState extends State<MicroInteraction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = SmoothAnimations.createController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: SmoothCurves.emphasized,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}
