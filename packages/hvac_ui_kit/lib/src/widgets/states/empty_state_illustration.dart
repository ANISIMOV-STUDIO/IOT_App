/// Empty State Illustration
///
/// Animated illustration component for empty states
library;

import 'package:flutter/material.dart';

/// Animated illustration widget for empty states
class EmptyStateIllustration extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool showAnimation;
  final double size;

  const EmptyStateIllustration({
    super.key,
    required this.icon,
    required this.color,
    this.showAnimation = true,
    this.size = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: iconSize * 1.5,
            height: iconSize * 1.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background pulse animation
                if (showAnimation)
                  _PulseAnimation(color: color, iconSize: iconSize),
                Icon(
                  icon,
                  size: iconSize * 0.7,
                  color: color,
                  semanticLabel: 'Empty state icon',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Pulse animation for background
class _PulseAnimation extends StatefulWidget {
  final Color color;
  final double iconSize;

  const _PulseAnimation({
    required this.color,
    required this.iconSize,
  });

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pulseValue = 0.5 + _controller.value * 0.5;
        return Container(
          width: widget.iconSize * 1.3 * pulseValue,
          height: widget.iconSize * 1.3 * pulseValue,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withValues(alpha: 0.05 * (2 - pulseValue)),
          ),
        );
      },
    );
  }
}
