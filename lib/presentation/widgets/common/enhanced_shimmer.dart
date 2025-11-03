/// Enhanced Shimmer Loading Components
/// Big Tech level skeleton screens with smooth animations
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
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
      baseColor: baseColor ?? HvacColors.backgroundCard,
      highlightColor: highlightColor ??
          HvacColors.backgroundCardBorder.withValues(alpha: 0.6),
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
            : (borderRadius ?? BorderRadius.circular(HvacRadius.smR)),
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
        padding: const EdgeInsets.all(HvacSpacing.lgR),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.lgR),
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
                const SizedBox(width: HvacSpacing.mdR),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonText(width: 150.w, height: 18),
                      const SizedBox(height: HvacSpacing.xsR),
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
            const SizedBox(height: HvacSpacing.lgR),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, (index) => Column(
                children: [
                  SkeletonContainer(
                    width: 60.w,
                    height: 32.h,
                  ),
                  const SizedBox(height: HvacSpacing.xsR),
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
        padding: const EdgeInsets.all(HvacSpacing.lgR),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.lgR),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonText(width: 120.w, height: 16),
            const SizedBox(height: HvacSpacing.mdR),
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
        padding: const EdgeInsets.symmetric(
          horizontal: HvacSpacing.mdR,
          vertical: HvacSpacing.smR,
        ),
        child: Row(
          children: [
            if (showAvatar) ...[
              SkeletonContainer(
                width: 40.r,
                height: 40.r,
                isCircle: true,
              ),
              const SizedBox(width: HvacSpacing.mdR),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonText(width: 180.w, height: 16),
                  if (showSubtitle) ...[
                    const SizedBox(height: HvacSpacing.xsR),
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
        padding: const EdgeInsets.all(HvacSpacing.lgR),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.lgR),
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
                  borderRadius: BorderRadius.circular(8.r),
                ),
                const SizedBox(width: HvacSpacing.smR),
                SkeletonText(width: 100.w, height: 14),
              ],
            ),
            const SizedBox(height: HvacSpacing.mdR),
            SkeletonText(width: 80.w, height: 32),
            const SizedBox(height: HvacSpacing.xsR),
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
      padding: const EdgeInsets.all(HvacSpacing.mdR),
      child: Column(
        children: [
          // Temperature card skeleton
          EnhancedShimmer(
            child: Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: HvacColors.backgroundCard,
                borderRadius: BorderRadius.circular(HvacRadius.xlR),
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
                    const SizedBox(height: HvacSpacing.mdR),
                    SkeletonText(width: 100.w, height: 16),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: HvacSpacing.lgR),

          // Stats row skeleton
          Row(
            children: List.generate(3, (index) => Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: const AnalyticsCardSkeleton(),
              ),
            )),
          ),
          const SizedBox(height: HvacSpacing.lgR),

          // Chart skeleton
          const ChartSkeleton(),
          const SizedBox(height: HvacSpacing.lgR),

          // Device list skeleton
          ...List.generate(3, (index) => const Padding(
            padding: EdgeInsets.only(bottom: HvacSpacing.mdR),
            child: DeviceCardSkeleton(),
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