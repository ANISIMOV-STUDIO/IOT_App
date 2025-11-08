/// Skeleton Screen Components
/// Complete skeleton screens for loading states
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import 'base_shimmer.dart';
import 'skeleton_primitives.dart';
import 'skeleton_cards.dart';

/// Home dashboard skeleton
class HomeDashboardSkeleton extends StatelessWidget {
  const HomeDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(HvacSpacing.md),
      child: Column(
        children: [
          // Temperature card skeleton
          BaseShimmer(
            child: Container(
              height: 200.0,
              decoration: BoxDecoration(
                color: HvacColors.backgroundCard,
                borderRadius: BorderRadius.circular(HvacRadius.xl),
                border: Border.all(
                  color: HvacColors.backgroundCardBorder,
                  width: 1,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonContainer(
                      width: 120.0,
                      height: 120.0,
                      isCircle: true,
                    ),
                    SizedBox(height: HvacSpacing.md),
                    SkeletonText(width: 100.0, height: 16),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: HvacSpacing.lg),

          // Stats row skeleton
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: const AnalyticsCardSkeleton(),
                ),
              ),
            ),
          ),
          const SizedBox(height: HvacSpacing.lg),

          // Chart skeleton
          const ChartSkeleton(),
          const SizedBox(height: HvacSpacing.lg),

          // Device list skeleton
          ...List.generate(
            3,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: HvacSpacing.md),
              child: DeviceCardSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}
