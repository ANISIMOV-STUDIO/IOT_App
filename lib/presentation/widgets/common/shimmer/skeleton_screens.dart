/// Skeleton Screen Components
/// Complete skeleton screens for loading states
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'base_shimmer.dart';
import 'skeleton_primitives.dart';
import 'skeleton_cards.dart';

/// Home dashboard skeleton
class HomeDashboardSkeleton extends StatelessWidget {
  const HomeDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(HvacSpacing.md.w),
      child: Column(
        children: [
          // Temperature card skeleton
          BaseShimmer(
            child: Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: HvacColors.backgroundCard,
                borderRadius: BorderRadius.circular(HvacRadius.xl.r),
                border: Border.all(
                  color: HvacColors.backgroundCardBorder,
                  width: 1,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SkeletonContainer(
                      width: 120.r,
                      height: 120.r,
                      isCircle: true,
                    ),
                    SizedBox(height: HvacSpacing.md.h),
                    SkeletonText(width: 100.w, height: 16),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: HvacSpacing.lg.h),

          // Stats row skeleton
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  child: const AnalyticsCardSkeleton(),
                ),
              ),
            ),
          ),
          SizedBox(height: HvacSpacing.lg.h),

          // Chart skeleton
          const ChartSkeleton(),
          SizedBox(height: HvacSpacing.lg.h),

          // Device list skeleton
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: HvacSpacing.md.h),
              child: const DeviceCardSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}