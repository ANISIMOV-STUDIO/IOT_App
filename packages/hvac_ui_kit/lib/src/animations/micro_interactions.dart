/// Micro-Interaction Components
///
/// Subtle animations for buttons and interactive elements
library;

import 'package:flutter/material.dart';
import 'animation_durations.dart';
import 'spring_curves.dart';
import 'smooth_animations.dart';

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

/// Pulse animation for attention-grabbing elements
class PulseAnimation extends StatelessWidget {
  final Widget child;
  final AnimationController controller;
  final double minScale;
  final double maxScale;
  final Curve curve;

  const PulseAnimation({
    super.key,
    required this.child,
    required this.controller,
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: minScale, end: maxScale).animate(
        CurvedAnimation(parent: controller, curve: curve),
      ),
      child: child,
    );
  }
}
