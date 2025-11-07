import 'package:flutter/material.dart';
import '../smooth_animations.dart';
import '../spring_curves.dart';

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
