/// Skeleton List Components
/// List item skeleton loaders
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
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
        padding: EdgeInsets.symmetric(
          horizontal: HvacSpacing.md.w,
          vertical: HvacSpacing.sm.h,
        ),
        child: Row(
          children: [
            if (showAvatar) ...[
              SkeletonContainer(
                width: 40.r,
                height: 40.r,
                isCircle: true,
              ),
              SizedBox(width: HvacSpacing.md.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonText(width: 180.w, height: 16),
                  if (showSubtitle) ...[
                    SizedBox(height: HvacSpacing.xs.h),
                    SkeletonText(width: 120.w, height: 14),
                  ],
                ],
              ),
            ),
            if (showTrailing)
              SkeletonContainer(
                width: 24.r,
                height: 24.r,
              ),
          ],
        ),
      ),
    );
  }
}