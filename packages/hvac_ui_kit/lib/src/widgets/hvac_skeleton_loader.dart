/// HVAC UI Kit - Skeleton Loader
///
/// Modern loading state using Skeletonizer
library;

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../theme/colors.dart';

/// Skeleton loader with HVAC styling
class HvacSkeletonLoader extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const HvacSkeletonLoader({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      effect: const ShimmerEffect(
        baseColor: HvacColors.backgroundCard,
        highlightColor: HvacColors.backgroundElevated,
        duration: Duration(milliseconds: 1000),
      ),
      child: child,
    );
  }
}

/// Skeleton loader with pulse effect
class HvacSkeletonPulse extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const HvacSkeletonPulse({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      effect: const PulseEffect(
        from: HvacColors.backgroundCard,
        to: HvacColors.backgroundElevated,
        duration: Duration(milliseconds: 800),
      ),
      child: child,
    );
  }
}

/// Skeleton loader with fade effect
class HvacSkeletonFade extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const HvacSkeletonFade({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: child,
    );
  }
}
