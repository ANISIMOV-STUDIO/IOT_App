/// Slide and Scale Animation Components
///
/// Smooth slide and scale animations with spring physics support
library;

import 'package:flutter/material.dart';
import 'animation_durations.dart';
import 'spring_curves.dart';
import 'smooth_animations.dart';

/// Smooth slide animation widget
class SmoothSlide extends StatefulWidget {
  final Widget child;
  final Offset begin;
  final Offset end;
  final Duration duration;
  final Duration? delay;
  final Curve curve;
  final bool addRepaintBoundary;

  const SmoothSlide({
    super.key,
    required this.child,
    this.begin = const Offset(0, 0.05),
    this.end = Offset.zero,
    this.duration = AnimationDurations.normal,
    this.delay,
    this.curve = SmoothCurves.emphasized,
    this.addRepaintBoundary = true,
  });

  @override
  State<SmoothSlide> createState() => _SmoothSlideState();
}

class _SmoothSlideState extends State<SmoothSlide>
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

/// Smooth scale animation widget
class SmoothScale extends StatefulWidget {
  final Widget child;
  final double begin;
  final double end;
  final Duration duration;
  final Duration? delay;
  final Curve curve;
  final bool addRepaintBoundary;

  const SmoothScale({
    super.key,
    required this.child,
    this.begin = 0.95,
    this.end = 1.0,
    this.duration = AnimationDurations.normal,
    this.delay,
    this.curve = SmoothCurves.emphasized,
    this.addRepaintBoundary = true,
  });

  @override
  State<SmoothScale> createState() => _SmoothScaleState();
}

class _SmoothScaleState extends State<SmoothScale>
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
class SpringScaleTransition extends StatelessWidget {
  final AnimationController controller;
  final double begin;
  final double end;
  final SpringDescription spring;
  final Widget child;

  const SpringScaleTransition({
    super.key,
    required this.controller,
    required this.child,
    this.begin = 1.0,
    this.end = 0.95,
    this.spring = SpringConstants.bouncy,
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
