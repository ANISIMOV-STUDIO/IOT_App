/// Skeleton List Components
/// List item skeleton loaders
library;

import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import 'base_shimmer.dart';
import 'skeleton_primitives.dart';

/// List item skeleton loader
class ListItemSkeleton extends StatelessWidget {
  final bool showAvatar;
  final bool showSubtitle;
  final bool showTrailing;

  const ListItemSkeleton({
    super.key,
    this.showAvatar = true,
    this.showSubtitle = true,
    this.showTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: HvacSpacing.md,
          vertical: HvacSpacing.sm,
        ),
        child: Row(
          children: [
            if (showAvatar) ...[
              const SkeletonContainer(
                width: 40.0,
                height: 40.0,
                isCircle: true,
              ),
              const SizedBox(width: HvacSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonText(width: 180.0, height: 16),
                  if (showSubtitle) ...[
                    const SizedBox(height: HvacSpacing.xs),
                    const SkeletonText(width: 120.0, height: 14),
                  ],
                ],
              ),
            ),
            if (showTrailing)
              const SkeletonContainer(
                width: 24.0,
                height: 24.0,
              ),
          ],
        ),
      ),
    );
  }
}
