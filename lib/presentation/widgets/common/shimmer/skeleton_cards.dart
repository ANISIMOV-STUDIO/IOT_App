/// Skeleton Card Components
/// Pre-built skeleton cards for common UI patterns
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'base_shimmer.dart';
import 'skeleton_primitives.dart';

/// Device card skeleton loader
class DeviceCardSkeleton extends StatelessWidget {
  const DeviceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: Container(
        padding: const EdgeInsets.all(HvacSpacing.lg),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.lg),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonContainer(
                  width: 48.0,
                  height: 48.0,
                  isCircle: true,
                ),
                const SizedBox(width: HvacSpacing.md),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonText(width: 150.0, height: 18),
                      SizedBox(height: HvacSpacing.xs),
                      SkeletonText(width: 100.0, height: 14),
                    ],
                  ),
                ),
                SkeletonContainer(
                  width: 60.0,
                  height: 32.0,
                  borderRadius: HvacRadius.lgRadius,
                ),
              ],
            ),
            const SizedBox(height: HvacSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                3,
                (index) => const Column(
                  children: [
                    SkeletonContainer(
                      width: 60.0,
                      height: 32.0,
                    ),
                    SizedBox(height: HvacSpacing.xs),
                    SkeletonText(width: 50.0, height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chart skeleton loader
class ChartSkeleton extends StatelessWidget {
  final double? height;

  const ChartSkeleton({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: Container(
        height: height ?? 200.0,
        padding: const EdgeInsets.all(HvacSpacing.lg),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.lg),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonText(width: 120.0, height: 16),
            const SizedBox(height: HvacSpacing.md),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: const SkeletonContainer(
                        height: double.infinity,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(4.0),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Analytics card skeleton
class AnalyticsCardSkeleton extends StatelessWidget {
  const AnalyticsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: Container(
        padding: const EdgeInsets.all(HvacSpacing.lg),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.lg),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SkeletonContainer(
                  width: 32.0,
                  height: 32.0,
                  borderRadius: HvacRadius.smRadius,
                ),
                const SizedBox(width: HvacSpacing.sm),
                const SkeletonText(width: 100.0, height: 14),
              ],
            ),
            const SizedBox(height: HvacSpacing.md),
            const SkeletonText(width: 80.0, height: 32),
            const SizedBox(height: HvacSpacing.xs),
            const SkeletonText(width: 60.0, height: 12),
          ],
        ),
      ),
    );
  }
}