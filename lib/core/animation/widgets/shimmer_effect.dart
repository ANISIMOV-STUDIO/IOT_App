/// Shimmer effect for loading states
library;

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../smooth_animations_core.dart';

class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const ShimmerEffect({
    super.key,
    required this.child,
    Color? baseColor,
    Color? highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  })  : baseColor = baseColor ?? const Color(0xFFE0E0E0),
        highlightColor = highlightColor ?? const Color(0xFFF5F5F5);

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SmoothAnimationsCore.createController(
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
