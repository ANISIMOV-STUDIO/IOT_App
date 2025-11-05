/// Shimmer Loading Widget
/// Provides shimmer effect for loading states
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: HvacColors.backgroundCard,
      highlightColor: HvacColors.backgroundCardBorder,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: HvacColors.backgroundCard,
      highlightColor: HvacColors.backgroundCardBorder,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: borderRadius ?? BorderRadius.circular(HvacRadius.mdR),
        ),
      ),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  final double size;

  const ShimmerCircle({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: HvacColors.backgroundCard,
      highlightColor: HvacColors.backgroundCardBorder,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: HvacColors.backgroundCard,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
