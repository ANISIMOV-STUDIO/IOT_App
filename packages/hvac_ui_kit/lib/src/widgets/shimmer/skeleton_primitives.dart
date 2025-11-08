/// Skeleton Primitive Components
/// Basic skeleton shapes for building complex loading states
library;

import 'package:flutter/material.dart';
import '../../theme/radius.dart';

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
                : (borderRadius ?? BorderRadius.circular(HvacRadius.sm)),
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle));
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
              lineWidth = 0.6; // Last line typically shorter
            } else {
              lineWidth = (0.8 + (index % 2) * 0.2);
            }
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: index < lines - 1 ? spacing : 0,
            ),
            child: SkeletonContainer(
              width: lineWidth,
              height: height,
              borderRadius: HvacRadius.xsRadius,
            ),
          );
        }));
  }
}
