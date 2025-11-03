/// Shimmer Loading Card
/// Skeleton UI component for loading states
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Shimmer loading card for skeleton UI
class ShimmerLoadingCard extends StatelessWidget {
  const ShimmerLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: HvacSpacing.md.w,
        vertical: HvacSpacing.sm.h,
      ),
      padding: EdgeInsets.all(HvacSpacing.lg.w),
      decoration: BoxDecoration(
        color: HvacColors.cardDark,
        borderRadius: BorderRadius.circular(HvacRadius.lg.r),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.white24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(HvacRadius.xs.r),
                      ),
                    ),
                    SizedBox(height: HvacSpacing.xs.h),
                    Container(
                      width: 100.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(HvacRadius.xs.r),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 50.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: HvacSpacing.lg.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                3,
                (index) => Container(
                  width: 60.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(HvacRadius.sm.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}