/// Enhanced Shimmer Loading Components
/// Big Tech level skeleton screens with smooth animations
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';

/// Base shimmer wrapper with customizable gradient
class EnhancedShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;
  final ShimmerDirection? direction;
  final bool enabled;

  const EnhancedShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period,
    this.direction,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return Shimmer.fromColors(
      baseColor: baseColor ?? AppTheme.backgroundCard,
      highlightColor: highlightColor ??
          AppTheme.backgroundCardBorder.withValues(alpha: 0.6),
      period: period ?? const Duration(milliseconds: 1500),
      direction: direction ?? ShimmerDirection.ltr,
      child: child,
    );
  }
}

/// Skeleton container for generic shapes
class SkeletonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;
  final bool isCircle;

  const SkeletonContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isCircle
            ? null
            : (borderRadius ?? BorderRadius.circular(AppRadius.smR)),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }
}

/// Text skeleton with realistic width variations
class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final int lines;
  final double spacing;
  final bool randomWidth;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 14.0,
    this.lines = 1,
    this.spacing = 8.0,
    this.randomWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        double lineWidth = width ?? double.infinity;

        if (randomWidth && width == null) {
          // Create realistic text width variations
          if (index == lines - 1) {
            lineWidth = 0.6.sw; // Last line typically shorter
          } else {
            lineWidth = (0.8 + (index % 2) * 0.2).sw;
          }
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: index < lines - 1 ? spacing.h : 0,
          ),
          child: SkeletonContainer(
            width: lineWidth,
            height: height.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}

/// Device card skeleton loader
class DeviceCardSkeleton extends StatelessWidget {
  const DeviceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return EnhancedShimmer(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lgR),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(AppRadius.lgR),
          border: Border.all(
            color: AppTheme.backgroundCardBorder,
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
                SizedBox(width: AppSpacing.mdR),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonText(width: 150.w, height: 18),
                      SizedBox(height: AppSpacing.xsR),
                      SkeletonText(width: 100.w, height: 14),
                    ],
                  ),
                ),
                SkeletonContainer(
                  width: 60.w,
                  height: 32.h,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lgR),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, (index) => Column(
                children: [
                  SkeletonContainer(
                    width: 60.w,
                    height: 32.h,
                  ),
                  SizedBox(height: AppSpacing.xsR),
                  SkeletonText(width: 50.w, height: 12),
                ],
              )),
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
    return EnhancedShimmer(
      child: Container(
        height: height ?? 200.h,
        padding: EdgeInsets.all(AppSpacing.lgR),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(AppRadius.lgR),
          border: Border.all(
            color: AppTheme.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonText(width: 120.w, height: 16),
            SizedBox(height: AppSpacing.mdR),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  final heights = [0.3, 0.5, 0.7, 0.4, 0.8, 0.6, 0.5];
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
    return EnhancedShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.mdR,
          vertical: AppSpacing.smR,
        ),
        child: Row(
          children: [
            if (showAvatar) ...[
              SkeletonContainer(
                width: 40.r,
                height: 40.r,
                isCircle: true,
              ),
              SizedBox(width: AppSpacing.mdR),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonText(width: 180.w, height: 16),
                  if (showSubtitle) ...[
                    SizedBox(height: AppSpacing.xsR),
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

/// Analytics card skeleton
class AnalyticsCardSkeleton extends StatelessWidget {
  const AnalyticsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return EnhancedShimmer(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lgR),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(AppRadius.lgR),
          border: Border.all(
            color: AppTheme.backgroundCardBorder,
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
                  borderRadius: BorderRadius.circular(8.r),
                ),
                SizedBox(width: AppSpacing.smR),
                SkeletonText(width: 100.w, height: 14),
              ],
            ),
            SizedBox(height: AppSpacing.mdR),
            SkeletonText(width: 80.w, height: 32),
            SizedBox(height: AppSpacing.xsR),
            SkeletonText(width: 60.w, height: 12),
          ],
        ),
      ),
    );
  }
}

/// Home dashboard skeleton
class HomeDashboardSkeleton extends StatelessWidget {
  const HomeDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.mdR),
      child: Column(
        children: [
          // Temperature card skeleton
          EnhancedShimmer(
            child: Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: AppTheme.backgroundCard,
                borderRadius: BorderRadius.circular(AppRadius.xlR),
                border: Border.all(
                  color: AppTheme.backgroundCardBorder,
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
                    SizedBox(height: AppSpacing.mdR),
                    SkeletonText(width: 100.w, height: 16),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lgR),

          // Stats row skeleton
          Row(
            children: List.generate(3, (index) => Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: const AnalyticsCardSkeleton(),
              ),
            )),
          ),
          SizedBox(height: AppSpacing.lgR),

          // Chart skeleton
          const ChartSkeleton(),
          SizedBox(height: AppSpacing.lgR),

          // Device list skeleton
          ...List.generate(3, (index) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.mdR),
            child: const DeviceCardSkeleton(),
          )),
        ],
      ),
    );
  }
}

/// Pulse animation skeleton
class PulseSkeleton extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const PulseSkeleton({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<PulseSkeleton> createState() => _PulseSkeletonState();
}

class _PulseSkeletonState extends State<PulseSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: widget.child,
      ),
    );
  }
}