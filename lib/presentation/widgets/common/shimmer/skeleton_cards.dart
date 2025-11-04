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
        padding: EdgeInsets.all(HvacSpacing.lg.w),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.lg.r),
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
                  width: 48.r,
                  height: 48.r,
                  isCircle: true,
                ),
                SizedBox(width: HvacSpacing.md.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonText(width: 150.w, height: 18),
                      SizedBox(height: HvacSpacing.xs.h),
                      SkeletonText(width: 100.w, height: 14),
                    ],
                  ),
                ),
                SkeletonContainer(
                  width: 60.w,
                  height: 32.h,
                  borderRadius: HvacRadius.lgRadius,
                ),
              ],
            ),
            SizedBox(height: HvacSpacing.lg.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                3,
                (index) => Column(
                  children: [
                    SkeletonContainer(
                      width: 60.w,
                      height: 32.h,
                    ),
                    SizedBox(height: HvacSpacing.xs.h),
                    SkeletonText(width: 50.w, height: 12),
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
        height: height ?? 200.h,
        padding: EdgeInsets.all(HvacSpacing.lg.w),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.lg.r),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonText(width: 120.w, height: 16),
            SizedBox(height: HvacSpacing.md.h),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      child: SkeletonContainer(
                        height: double.infinity,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(4.r),
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
        padding: EdgeInsets.all(HvacSpacing.lg.w),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.lg.r),
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
                  width: 32.r,
                  height: 32.r,
                  borderRadius: HvacRadius.smRadius,
                ),
                SizedBox(width: HvacSpacing.sm.w),
                SkeletonText(width: 100.w, height: 14),
              ],
            ),
            SizedBox(height: HvacSpacing.md.h),
            SkeletonText(width: 80.w, height: 32),
            SizedBox(height: HvacSpacing.xs.h),
            SkeletonText(width: 60.w, height: 12),
          ],
        ),
      ),
    );
  }
}