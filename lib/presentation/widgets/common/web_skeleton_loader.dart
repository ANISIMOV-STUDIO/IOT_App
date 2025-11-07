/// Web Skeleton Loader - Advanced skeleton loading states for web
///
/// Provides smooth skeleton loaders with shimmer effects optimized for web
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Enhanced skeleton loader with customizable shimmer effect
class WebSkeletonLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final ShimmerDirection direction;

  const WebSkeletonLoader({
    super.key,
    required this.child,
    required this.isLoading,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
  });

  @override
  State<WebSkeletonLoader> createState() => _WebSkeletonLoaderState();
}

class _WebSkeletonLoaderState extends State<WebSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(WebSkeletonLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final baseColor =
        widget.baseColor ?? HvacColors.backgroundCard.withValues(alpha: 0.3);
    final highlightColor =
        widget.highlightColor ?? HvacColors.glassShimmerHighlight;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: widget.direction == ShimmerDirection.ltr
                  ? Alignment.topLeft
                  : Alignment.topCenter,
              end: widget.direction == ShimmerDirection.ltr
                  ? Alignment.centerRight
                  : Alignment.bottomCenter,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [
                0.0,
                0.5,
                1.0,
              ],
              transform: _SlideGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlideGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

enum ShimmerDirection { ltr, ttb }

/// Skeleton shapes for common UI elements
class WebSkeletonShapes {
  /// Skeleton for card
  static Widget card({
    double? width,
    double? height = 200,
    double borderRadius = 12,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  /// Skeleton for text line
  static Widget text({
    double? width,
    double height = 16,
    double borderRadius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  /// Skeleton for circle (avatar, icon)
  static Widget circle({
    double size = 48,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: HvacColors.backgroundCard,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Skeleton for button
  static Widget button({
    double width = 120,
    double height = 44,
    double borderRadius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  /// HVAC Card skeleton
  static Widget hvacCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.lgRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(width: 120, height: 20),
              circle(size: 40),
            ],
          ),
          const SizedBox(height: 16),
          text(width: 80, height: 14),
          const SizedBox(height: 8),
          text(width: double.infinity, height: 12),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(width: 60, height: 14),
              text(width: 60, height: 14),
            ],
          ),
        ],
      ),
    );
  }

  /// Dashboard stat card skeleton
  static Widget statCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(width: 80, height: 14),
              circle(size: 32),
            ],
          ),
          const SizedBox(height: 12),
          text(width: 100, height: 24),
          const SizedBox(height: 4),
          text(width: 60, height: 12),
        ],
      ),
    );
  }
}

/// Skeleton list builder
class WebSkeletonList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  const WebSkeletonList({
    super.key,
    this.itemCount = 5,
    required this.itemBuilder,
    this.padding,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        return WebSkeletonLoader(
          isLoading: true,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

/// Skeleton grid builder
class WebSkeletonGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry? padding;

  const WebSkeletonGrid({
    super.key,
    this.itemCount = 6,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: 1.2,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return WebSkeletonLoader(
          isLoading: true,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

/// Usage example widget
class WebSkeletonLoaderExample extends StatelessWidget {
  const WebSkeletonLoaderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Single card with shimmer
        WebSkeletonLoader(
          isLoading: true,
          child: WebSkeletonShapes.hvacCard(),
        ),
        const SizedBox(height: 20),

        // List of skeleton cards
        Expanded(
          child: WebSkeletonList(
            itemCount: 5,
            itemBuilder: (context, index) => WebSkeletonShapes.hvacCard(),
          ),
        ),

        // Grid of skeleton stat cards
        Expanded(
          child: WebSkeletonGrid(
            itemCount: 4,
            crossAxisCount: 2,
            itemBuilder: (context, index) => WebSkeletonShapes.statCard(),
          ),
        ),
      ],
    );
  }
}
