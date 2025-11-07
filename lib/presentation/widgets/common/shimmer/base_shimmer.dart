/// Base Shimmer Component
/// Core shimmer wrapper with customizable gradient
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Base shimmer wrapper with customizable gradient
class BaseShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;
  final ShimmerDirection? direction;
  final bool enabled;

  const BaseShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period,
    this.direction,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return Shimmer.fromColors(
      baseColor: baseColor ?? HvacColors.backgroundCard,
      highlightColor: highlightColor ??
          HvacColors.backgroundCardBorder.withValues(alpha: 0.6),
      period: period ?? const Duration(milliseconds: 1500),
      direction: direction ?? ShimmerDirection.ltr,
      child: child,
    );
  }
}
