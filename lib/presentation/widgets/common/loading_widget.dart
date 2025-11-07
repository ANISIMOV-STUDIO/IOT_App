import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Comprehensive loading widget with multiple display modes
class LoadingWidget extends StatelessWidget {
  final LoadingType type;
  final String? message;
  final double? size;
  final Color? color;
  final bool showMessage;
  final Widget? customChild;

  const LoadingWidget({
    super.key,
    this.type = LoadingType.circular,
    this.message,
    this.size,
    this.color,
    this.showMessage = true,
    this.customChild,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    final effectiveSize = size ??
        ResponsiveUtils.getResponsiveValue(
          context,
          mobile: 48.0,
          tablet: 56.0,
          desktop: 64.0,
        );

    return Semantics(
      label: message ?? 'Loading content',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLoadingIndicator(
              context,
              theme,
              effectiveColor,
              effectiveSize,
            ),
            if (showMessage && message != null) ...[
              const SizedBox(height: HvacSpacing.md),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: ResponsiveUtils.scaledFontSize(context, 14),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(
    BuildContext context,
    ThemeData theme,
    Color color,
    double size,
  ) {
    switch (type) {
      case LoadingType.circular:
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: ResponsiveUtils.getResponsiveValue(
              context,
              mobile: 3.0,
              tablet: 3.5,
              desktop: 4.0,
            ),
          ),
        );

      case LoadingType.linear:
        return SizedBox(
          width: size * 3,
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: ResponsiveUtils.getResponsiveValue(
              context,
              mobile: 4.0,
              tablet: 5.0,
              desktop: 6.0,
            ),
          ),
        );

      case LoadingType.shimmer:
        return customChild != null
            ? _buildShimmer(context, theme, customChild!)
            : _buildDefaultShimmer(context, theme, size);

      case LoadingType.dots:
        return _buildDotsLoader(context, color, size);

      case LoadingType.pulse:
        return _buildPulseLoader(context, color, size);
    }
  }

  Widget _buildShimmer(BuildContext context, ThemeData theme, Widget child) {
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surface,
      highlightColor: theme.colorScheme.surface.withValues(alpha: 0.3),
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }

  Widget _buildDefaultShimmer(
      BuildContext context, ThemeData theme, double size) {
    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surface,
      highlightColor: theme.colorScheme.surface.withValues(alpha: 0.3),
      period: const Duration(milliseconds: 1500),
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: HvacSpacing.xs),
            width: size * 4,
            height: ResponsiveUtils.getResponsiveValue(
              context,
              mobile: 16.0,
              tablet: 18.0,
              desktop: 20.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(HvacSpacing.xs),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDotsLoader(BuildContext context, Color color, double size) {
    return SizedBox(
      width: size * 2,
      height: size / 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3,
          (index) => TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600 + (index * 200)),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.5 + (value * 0.5),
                child: Container(
                  width: size / 4,
                  height: size / 4,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.3 + (value * 0.7)),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPulseLoader(BuildContext context, Color color, double size) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      onEnd: () {},
      builder: (context, value, child) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3 * value),
                blurRadius: size * value * 0.3,
                spreadRadius: size * value * 0.1,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: size * 0.6,
              height: size * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Loading overlay widget for full-screen loading
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;
  final Color? backgroundColor;
  final LoadingType loadingType;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.backgroundColor,
    this.loadingType = LoadingType.circular,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: backgroundColor ??
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
              child: LoadingWidget(
                type: loadingType,
                message: message,
                showMessage: message != null,
              ),
            ),
          ),
      ],
    );
  }
}

/// Types of loading indicators
enum LoadingType {
  circular,
  linear,
  shimmer,
  dots,
  pulse,
}
