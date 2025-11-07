import 'package:flutter/material.dart';
import '../animation_durations.dart';
import '../spring_curves.dart';
import '../smooth_animations.dart';

/// Smooth slide implementation
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