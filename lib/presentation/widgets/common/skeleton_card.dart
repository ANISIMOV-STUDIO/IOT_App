/// Skeleton Card Widget
/// Loading placeholder with shimmer effect
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

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
      height: height ?? 120.0,
      padding: HvacSpacing.cardPadding,
      decoration: HvacTheme.roundedCard(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerCircle(size: 40.0),
              SizedBox(width: HvacSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: 120.0,
                      height: 16.0,
                    ),
                    SizedBox(height: HvacSpacing.sm),
                    ShimmerBox(
                      width: 80.0,
                      height: 12.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          ShimmerBox(
            width: double.infinity,
            height: 12.0,
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
      padding: HvacSpacing.cardPadding,
      decoration: HvacTheme.deviceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and name
          Row(
            children: [
              const ShimmerBox(
                width: 48.0,
                height: 48.0,
              ),
              const SizedBox(width: HvacSpacing.md),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: 100.0,
                      height: 18.0,
                    ),
                    SizedBox(height: HvacSpacing.xs),
                    ShimmerBox(
                      width: 60.0,
                      height: 14.0,
                    ),
                  ],
                ),
              ),
              ShimmerBox(
                width: 40.0,
                height: 24.0,
                borderRadius: BorderRadius.circular(HvacRadius.roundR),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.lg),
          // Temperature display
          const Center(
            child: ShimmerBox(
              width: 120.0,
              height: 48.0,
            ),
          ),
          const SizedBox(height: HvacSpacing.lg),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (index) => ShimmerBox(
                width: 70.0,
                height: 36.0,
                borderRadius: BorderRadius.circular(HvacRadius.mdR),
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
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: HvacSpacing.sm,
        horizontal: HvacSpacing.md,
      ),
      child: Row(
        children: [
          ShimmerCircle(size: 48.0),
          SizedBox(width: HvacSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: double.infinity,
                  height: 16.0,
                ),
                SizedBox(height: HvacSpacing.xs),
                ShimmerBox(
                  width: 150.0,
                  height: 12.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
