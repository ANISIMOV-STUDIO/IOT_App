/// Shimmer Loading Widget
/// Provides shimmer effect for loading states
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';

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
      baseColor: AppTheme.backgroundCard,
      highlightColor: AppTheme.backgroundCardBorder,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(borderRadius.r),
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
      baseColor: AppTheme.backgroundCard,
      highlightColor: AppTheme.backgroundCardBorder,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.mdR),
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
      baseColor: AppTheme.backgroundCard,
      highlightColor: AppTheme.backgroundCardBorder,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppTheme.backgroundCard,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
