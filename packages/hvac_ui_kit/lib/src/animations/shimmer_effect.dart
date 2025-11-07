/// Shimmer Loading Effect
///
/// Shimmer animation for skeleton loading states
library;

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'smooth_animations.dart';

/// Shimmer effect for loading states
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
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
    final baseColor = widget.baseColor ?? Colors.grey.shade300;
    final highlightColor = widget.highlightColor ?? Colors.grey.shade100;

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
                  baseColor,
                  highlightColor,
                  baseColor,
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
