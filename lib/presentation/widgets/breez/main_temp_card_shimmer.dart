/// Main Temperature Card Shimmer - Loading skeleton for MainTempCard
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';

/// Shimmer loading state for MainTempCard
class MainTempCardShimmer extends StatelessWidget {
  const MainTempCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase,
      highlightColor: isDark ? AppColors.darkShimmerHighlight : AppColors.lightShimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          const _HeaderShimmer(),
          const SizedBox(height: 40),
          // Temperature shimmer
          const _TemperatureShimmer(),
          const SizedBox(height: 40),
          // Stats shimmer
          const _StatsShimmer(),
        ],
      ),
    );
  }
}

/// Header shimmer placeholder
class _HeaderShimmer extends StatelessWidget {
  const _HeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 11,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.indicator),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 13,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.indicator),
              ),
            ),
          ],
        ),
        Container(
          width: 80,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ],
    );
  }
}

/// Temperature shimmer placeholder
class _TemperatureShimmer extends StatelessWidget {
  const _TemperatureShimmer();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 120,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 140,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.indicator),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stats shimmer placeholder
class _StatsShimmer extends StatelessWidget {
  const _StatsShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        3,
        (index) => Column(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 60,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.indicator),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 50,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.indicator),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
