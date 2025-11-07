/// Glassmorphism & Frosted Glass Components (2025)
///
/// Modern UI trend: blur, transparency, shimmer effects
/// Based on Apple's Liquid Glass and latest design systems
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'radius.dart';
import 'spacing.dart';

/// Glassmorphism Container with BackdropFilter blur
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurSigma;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16.0,
    this.blurSigma = HvacColors.blurMedium,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? HvacColors.glassShimmerBase,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? HvacColors.glassBorder,
                width: borderWidth,
              ),
              boxShadow: boxShadow,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Glass Card with frosted effect for widgets
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool enableBlur;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.enableBlur = true,
  });

  @override
  Widget build(BuildContext context) {
    if (enableBlur) {
      return GlassContainer(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(HvacSpacing.lg),
        margin: margin,
        borderRadius: HvacRadius.lg,
        blurSigma: HvacColors.blurMedium,
        backgroundColor: HvacColors.backgroundCard.withValues(alpha: 0.7),
        borderColor: HvacColors.glassBorder,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        child: child,
      );
    } else {
      // Fallback without blur for performance
      return Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(HvacSpacing.lg),
        margin: margin,
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(HvacRadius.lg),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      );
    }
  }
}

/// Shimmer Animation Widget (white light sweeping effect)
class ShimmerAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;
  final bool enabled;

  const ShimmerAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor = HvacColors.glassShimmerBase,
    this.highlightColor = HvacColors.glassShimmerHighlight,
    this.enabled = true,
  });

  @override
  State<ShimmerAnimation> createState() => _ShimmerAnimationState();
}

class _ShimmerAnimationState extends State<ShimmerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _controller.repeat();
    } else if (!widget.enabled && oldWidget.enabled) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [
                0.0,
                0.5,
                1.0,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
              ),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

/// Gradient transform for shimmer sliding effect
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * slidePercent,
      0.0,
      0.0,
    );
  }
}

/// White Glass Button with shimmer
class GlassButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool enableShimmer;
  final double? width;

  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.enableShimmer = true,
    this.width,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: 18.0,
            color: HvacColors.glassWhite,
          ),
          SizedBox(width: 8.0),
        ],
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: HvacColors.glassWhite,
          ),
        ),
      ],
    );

    if (widget.enableShimmer && !_isHovered) {
      content = ShimmerAnimation(child: content);
    }

    return MouseRegion(
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: GlassContainer(
          width: widget.width,
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 12.0,
          ),
          borderRadius: 12.0,
          blurSigma: _isHovered ? HvacColors.blurHeavy : HvacColors.blurMedium,
          backgroundColor: _isHovered
              ? HvacColors.glassShimmerHighlight
              : HvacColors.glassShimmerBase,
          borderColor: HvacColors.glassBorder,
          child: content,
        ),
      ),
    );
  }
}

/// Frosted Glass AppBar
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: HvacColors.blurMedium,
          sigmaY: HvacColors.blurMedium,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: HvacColors.backgroundDark.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(
                color: HvacColors.glassBorder,
                width: 1,
              ),
            ),
          ),
          child: AppBar(
            title: Text(title),
            centerTitle: centerTitle,
            actions: actions,
            leading: leading,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

/// Helper: Check if device can handle blur efficiently
class GlassHelper {
  static bool canUseBlur(BuildContext context) {
    // For production: check device capabilities
    // For now: always return true (can be optimized later)
    return true;
  }

  static double getOptimalBlur(BuildContext context) {
    // Adjust blur based on device performance
    // Lower-end devices get less blur
    return HvacColors.blurMedium;
  }
}
