/// Analytics Animated Chart Wrapper Widget
///
/// Provides entrance animation for chart widgets
/// Single Responsibility: Animation orchestration for charts
library;

import 'package:flutter/material.dart';

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

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 150)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
