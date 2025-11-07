/// Fade Animation Components
///
/// Smooth fade in/out animations with configurable delays and curves
library;

import 'package:flutter/material.dart';
import 'animation_durations.dart';
import 'spring_curves.dart';
import 'smooth_animations.dart';

/// Smooth fade in animation widget
class SmoothFadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration? delay;
  final Curve curve;
  final bool addRepaintBoundary;

  const SmoothFadeIn({
    super.key,
    required this.child,
    this.duration = AnimationDurations.normal,
    this.delay,
    this.curve = SmoothCurves.easeOut,
    this.addRepaintBoundary = true,
  });

  @override
  State<SmoothFadeIn> createState() => _SmoothFadeInState();
}

class _SmoothFadeInState extends State<SmoothFadeIn>
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
