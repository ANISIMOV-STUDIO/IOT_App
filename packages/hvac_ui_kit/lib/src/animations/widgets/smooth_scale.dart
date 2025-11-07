import 'package:flutter/material.dart';
import '../animation_durations.dart';
import '../spring_curves.dart';
import '../smooth_animations.dart';

/// Smooth scale implementation
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