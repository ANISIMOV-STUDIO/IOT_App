/// Skeleton Card Widget
/// Loading placeholder with shimmer effect
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/app_radius.dart';
import 'shimmer_loading.dart';

class SkeletonCard extends StatelessWidget {
  final double? width;
  final double? height;

  const SkeletonCard({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 120.h,
      padding: AppTheme.cardPadding,
      decoration: AppTheme.roundedCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerCircle(size: 40.w),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: 120.w,
                      height: 16.h,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ShimmerBox(
                      width: 80.w,
                      height: 12.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          ShimmerBox(
            width: double.infinity,
            height: 12.h,
          ),
        ],
      ),
    );
  }
}

class SkeletonDeviceCard extends StatelessWidget {
  const SkeletonDeviceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.cardPadding,
      decoration: AppTheme.deviceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and name
          Row(
            children: [
              ShimmerBox(
                width: 48.w,
                height: 48.h,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: 100.w,
                      height: 18.h,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    ShimmerBox(
                      width: 60.w,
                      height: 14.h,
                    ),
                  ],
                ),
              ),
              ShimmerBox(
                width: 40.w,
                height: 24.h,
                borderRadius: BorderRadius.circular(AppRadius.roundR),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // Temperature display
          Center(
            child: ShimmerBox(
              width: 120.w,
              height: 48.h,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (index) => ShimmerBox(
                width: 70.w,
                height: 36.h,
                borderRadius: BorderRadius.circular(AppRadius.mdR),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      child: Row(
        children: [
          ShimmerCircle(size: 48.w),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: double.infinity,
                  height: 16.h,
                ),
                const SizedBox(height: AppSpacing.xs),
                ShimmerBox(
                  width: 150.w,
                  height: 12.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
