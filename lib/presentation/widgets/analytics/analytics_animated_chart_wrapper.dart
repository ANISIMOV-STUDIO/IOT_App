/// Analytics Animated Chart Wrapper Widget
///
/// Provides entrance animation for chart widgets using HVAC UI Kit
/// Single Responsibility: Animation orchestration for charts
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class AnalyticsAnimatedChartWrapper extends StatelessWidget {
  final int index;
  final Widget child;
  final bool isLoading;

  const AnalyticsAnimatedChartWrapper({
    super.key,
    required this.index,
    required this.child,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return child;
    }

    // Use staggered animation with delay based on index
    final delay = Duration(milliseconds: index * 150);

    return SmoothAnimations.slideIn(
      duration: AnimationDurations.slow,
      delay: delay,
      begin: const Offset(0, 0.08), // 20px equivalent at standard height
      child: SmoothAnimations.fadeIn(
        duration: AnimationDurations.slow,
        delay: delay,
        child: child,
      ),
    );
  }
}
