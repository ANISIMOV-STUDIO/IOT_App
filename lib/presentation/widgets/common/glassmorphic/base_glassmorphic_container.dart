/// Base Glassmorphic Container
/// Core glassmorphic effect with optimized blur for web performance
library;

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Base glassmorphic container with optimized blur effects
/// Provides foundation for all glassmorphic card variants
class BaseGlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final double blurAmount;
  final double borderOpacity;
  final Color? backgroundColor;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final bool enableWebOptimization;

  const BaseGlassmorphicContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.blurAmount = 10.0,
    this.borderOpacity = 0.1,
    this.backgroundColor,
    this.gradient,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.enableWebOptimization = true,
  });

  /// Optimized blur value for web platform
  double get _optimizedBlurAmount {
    if (!enableWebOptimization) return blurAmount;
    // Reduce blur on web for better performance
    return kIsWeb ? blurAmount * 0.7 : blurAmount;
  }

  /// Get responsive border radius
  BorderRadius get _responsiveBorderRadius {
    return borderRadius ?? BorderRadius.circular(HvacRadius.lg.r);
  }

  /// Build optimized backdrop filter
  Widget _buildBackdropFilter(Widget child) {
    // Skip blur on web if amount is too high for performance
    if (kIsWeb && _optimizedBlurAmount > 20) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor?.withValues(alpha: 0.9) ??
              HvacColors.backgroundCard.withValues(alpha: 0.9),
          gradient: gradient,
          borderRadius: _responsiveBorderRadius,
        ),
        padding: padding ?? EdgeInsets.all(HvacSpacing.lg.w),
        child: child,
      );
    }

    return ClipRRect(
      borderRadius: _responsiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: _optimizedBlurAmount,
          sigmaY: _optimizedBlurAmount,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ??
                HvacColors.backgroundCard.withValues(alpha: 0.7),
            gradient: gradient,
            borderRadius: _responsiveBorderRadius,
          ),
          padding: padding ?? EdgeInsets.all(HvacSpacing.lg.w),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.w,
      height: height?.h,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: _responsiveBorderRadius,
        border: border ??
            Border.all(
              color: HvacColors.textPrimary.withValues(alpha: borderOpacity),
              width: 1.w,
            ),
        boxShadow: boxShadow,
      ),
      child: _buildBackdropFilter(child),
    );
  }
}

/// Configuration for glassmorphic effects
class GlassmorphicConfig {
  final double blurAmount;
  final double borderOpacity;
  final Color backgroundColor;
  final bool enableWebOptimization;

  const GlassmorphicConfig({
    this.blurAmount = 10.0,
    this.borderOpacity = 0.1,
    this.backgroundColor = HvacColors.backgroundCard,
    this.enableWebOptimization = true,
  });

  /// Light theme configuration
  static const light = GlassmorphicConfig(
    blurAmount: 8.0,
    borderOpacity: 0.08,
    backgroundColor: HvacColors.backgroundCard,
  );

  /// Dark theme configuration
  static const dark = GlassmorphicConfig(
    blurAmount: 12.0,
    borderOpacity: 0.15,
    backgroundColor: HvacColors.backgroundDark,
  );

  /// Web optimized configuration
  static const web = GlassmorphicConfig(
    blurAmount: 6.0,
    borderOpacity: 0.1,
    enableWebOptimization: true,
  );
}