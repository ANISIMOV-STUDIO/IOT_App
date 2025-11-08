/// Animated divider with gradient effects and web optimization
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

/// Divider style options
enum HvacDividerStyle { gradient, solid, primary, dashed }

/// Premium divider with gradient and animation support
class HvacDivider extends StatelessWidget {
  final double height;
  final EdgeInsets? margin;
  final Gradient? gradient;
  final bool animate;
  final HvacDividerStyle style;

  const HvacDivider({
    super.key,
    this.height = 1.0,
    this.margin,
    this.gradient,
    this.animate = true,
    this.style = HvacDividerStyle.gradient,
  });

  @override
  Widget build(BuildContext context) {
    Widget divider = Container(
        height: height,
        margin: margin ?? const EdgeInsets.symmetric(vertical: HvacSpacing.md),
        decoration: BoxDecoration(
            gradient: _buildGradient(), borderRadius: HvacRadius.fullRadius));

    if (animate) {
      divider = divider
          .animate()
          .fadeIn(duration: 600.ms, curve: Curves.easeOut)
          .scaleX(begin: 0, end: 1, duration: 800.ms, curve: Curves.easeOut)
          .then()
          .shimmer(
              duration: 2000.ms,
              delay: 500.ms,
              color: HvacColors.primaryOrange.withValues(alpha: 0.05));
    }
    return divider;
  }

  Gradient _buildGradient() {
    if (gradient != null) return gradient!;

    const bc = HvacColors.backgroundCardBorder;
    const pc = HvacColors.primaryOrange;
    const s = [0.0, 0.2, 0.8, 1.0];

    switch (style) {
      case HvacDividerStyle.gradient:
        return LinearGradient(colors: [
          Colors.transparent,
          bc.withValues(alpha: 0.5),
          bc.withValues(alpha: 0.5),
          Colors.transparent
        ], stops: s);
      case HvacDividerStyle.solid:
        return LinearGradient(colors: [
          bc.withValues(alpha: 0.3),
          bc.withValues(alpha: 0.3),
        ]);
      case HvacDividerStyle.primary:
        return LinearGradient(colors: [
          Colors.transparent,
          pc.withValues(alpha: 0.3),
          pc.withValues(alpha: 0.3),
          Colors.transparent
        ], stops: s);
      case HvacDividerStyle.dashed:
        return LinearGradient(colors: [
          bc.withValues(alpha: 0.4),
          bc.withValues(alpha: 0.4),
        ]);
    }
  }
}

/// Vertical divider variant
class HvacVerticalDivider extends StatelessWidget {
  final double width;
  final double? height;
  final EdgeInsets? margin;
  final Gradient? gradient;
  final bool animate;
  final HvacDividerStyle style;

  const HvacVerticalDivider({
    super.key,
    this.width = 1.0,
    this.height,
    this.margin,
    this.gradient,
    this.animate = true,
    this.style = HvacDividerStyle.gradient,
  });

  @override
  Widget build(BuildContext context) {
    Widget divider = Container(
        width: width,
        height: height,
        margin:
            margin ?? const EdgeInsets.symmetric(horizontal: HvacSpacing.md),
        decoration: BoxDecoration(
            gradient: _buildGradient(), borderRadius: HvacRadius.fullRadius));

    if (animate) {
      divider = divider
          .animate()
          .fadeIn(duration: 600.ms)
          .scaleY(begin: 0, end: 1, duration: 800.ms);
    }
    return divider;
  }

  Gradient _buildGradient() {
    if (gradient != null) return gradient!;

    const bc = HvacColors.backgroundCardBorder;
    if (style == HvacDividerStyle.gradient) {
      return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            bc.withValues(alpha: 0.5),
            bc.withValues(alpha: 0.5),
            Colors.transparent
          ],
          stops: const [
            0.0,
            0.2,
            0.8,
            1.0
          ]);
    }
    return LinearGradient(colors: [
      bc.withValues(alpha: 0.3),
      bc.withValues(alpha: 0.3),
    ]);
  }
}
