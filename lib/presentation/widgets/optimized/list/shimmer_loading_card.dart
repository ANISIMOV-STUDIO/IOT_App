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
      margin: const EdgeInsets.symmetric(
        horizontal: HvacSpacing.md,
        vertical: HvacSpacing.sm,
      ),
      padding: const EdgeInsets.all(HvacSpacing.lg),
      decoration: BoxDecoration(
        color: HvacColors.cardDark,
        borderRadius: BorderRadius.circular(HvacRadius.lg),
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
                      width: 150.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(HvacRadius.xs),
                      ),
                    ),
                    const SizedBox(height: HvacSpacing.xs),
                    Container(
                      width: 100.0,
                      height: 14.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(HvacRadius.xs),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 50.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: HvacRadius.lgRadius,
                  ),
                ),
              ],
            ),
            const SizedBox(height: HvacSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                3,
                (index) => Container(
                  width: 60.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(HvacRadius.sm),
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