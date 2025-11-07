/// HVAC UI Kit - Gradient Borders
///
/// Beautiful gradient borders for accent elements
library;

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/radius.dart';

/// Gradient border container
class HvacGradientBorder extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const HvacGradientBorder({
    super.key,
    required this.child,
    required this.gradientColors,
    this.borderWidth = 2.0,
    this.borderRadius,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: begin,
          end: end,
        ),
        borderRadius: borderRadius ?? HvacRadius.mdRadius,
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: borderRadius != null
              ? BorderRadius.circular(
                  (borderRadius as BorderRadius).topLeft.x - borderWidth)
              : BorderRadius.circular(HvacRadius.md - borderWidth),
        ),
        child: child,
      ),
    );
  }
}

/// Orange-Blue gradient border (HVAC branded)
class HvacBrandedBorder extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final BorderRadius? borderRadius;

  const HvacBrandedBorder({
    super.key,
    required this.child,
    this.borderWidth = 2.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return HvacGradientBorder(
      gradientColors: const [
        HvacColors.primaryOrange,
        HvacColors.primaryBlue,
      ],
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      child: child,
    );
  }
}

/// Animated gradient border (rotates)
class HvacAnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final Duration duration;

  const HvacAnimatedGradientBorder({
    super.key,
    required this.child,
    required this.gradientColors,
    this.borderWidth = 2.0,
    this.borderRadius,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<HvacAnimatedGradientBorder> createState() =>
      _HvacAnimatedGradientBorderState();
}

class _HvacAnimatedGradientBorderState
    extends State<HvacAnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: HvacGradientBorder(
            gradientColors: widget.gradientColors,
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius,
            child: Transform.rotate(
              angle: -_controller.value * 2 * 3.14159,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

/// Success gradient border
class HvacSuccessBorder extends StatelessWidget {
  final Widget child;
  final double borderWidth;

  const HvacSuccessBorder({
    super.key,
    required this.child,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return HvacGradientBorder(
      gradientColors: [
        HvacColors.success,
        HvacColors.success.withValues(alpha:0.6),
      ],
      borderWidth: borderWidth,
      child: child,
    );
  }
}

/// Warning gradient border
class HvacWarningBorder extends StatelessWidget {
  final Widget child;
  final double borderWidth;

  const HvacWarningBorder({
    super.key,
    required this.child,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return HvacGradientBorder(
      gradientColors: [
        HvacColors.warning,
        HvacColors.warning.withValues(alpha:0.6),
      ],
      borderWidth: borderWidth,
      child: child,
    );
  }
}

/// Error gradient border
class HvacErrorBorder extends StatelessWidget {
  final Widget child;
  final double borderWidth;

  const HvacErrorBorder({
    super.key,
    required this.child,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return HvacGradientBorder(
      gradientColors: [
        HvacColors.error,
        HvacColors.error.withValues(alpha:0.6),
      ],
      borderWidth: borderWidth,
      child: child,
    );
  }
}
