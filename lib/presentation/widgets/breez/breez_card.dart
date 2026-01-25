/// BREEZ Card & Core Components
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:shimmer/shimmer.dart';

// Re-export button components for backwards compatibility
export 'breez_button.dart';
export 'breez_dialog_button.dart';
export 'breez_icon_button.dart';
export 'breez_settings_tile.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezCard
abstract class _CardConstants {
  static const double defaultPadding = AppSpacing.lgx; // 24px
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double disabledOpacity = 0.3;
  static const double titleLetterSpacing = 2;
  static const double shimmerHeight = 100;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// BREEZ styled card using Material Card
///
/// Поддерживает:
/// - Disabled state с opacity
/// - Loading state с shimmer
/// - Опциональные title и description
/// - Accessibility через Semantics
class BreezCard extends StatelessWidget {

  const BreezCard({
    required this.child, super.key,
    this.padding,
    this.disabled = false,
    this.isLoading = false,
    this.title,
    this.description,
  });
  final Widget child;
  final EdgeInsets? padding;
  final bool disabled;
  final bool isLoading;
  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      container: true,
      label: title,
      child: AnimatedOpacity(
        duration: _CardConstants.animationDuration,
        opacity: disabled ? _CardConstants.disabledOpacity : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: colors.border),
          ),
          padding: padding ?? const EdgeInsets.all(_CardConstants.defaultPadding),
          child: IgnorePointer(
            ignoring: disabled,
            child: isLoading
                ? _buildShimmer(context, colors, isDark)
                : (title != null || description != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
                              child: Text(
                                (title ?? '').toUpperCase(),
                                style: TextStyle(
                                  fontSize: AppFontSizes.tiny,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: _CardConstants.titleLetterSpacing,
                                  color: colors.text,
                                ),
                              ),
                            ),
                          if (description != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.md),
                              child: Text(
                                description ?? '',
                                style: TextStyle(
                                  fontSize: AppFontSizes.caption,
                                  color: colors.textMuted,
                                ),
                              ),
                            ),
                          child,
                        ],
                      )
                    : child),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context, BreezColors colors, bool isDark) => Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase,
      highlightColor: isDark ? AppColors.darkShimmerHighlight : AppColors.lightShimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              width: 80,
              height: AppFontSizes.tiny,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.indicator),
              ),
            ),
          if (title != null) const SizedBox(height: AppSpacing.xxs),
          if (description != null)
            Container(
              width: 120,
              height: AppFontSizes.caption,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.indicator),
              ),
            ),
          if (description != null) const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            height: _CardConstants.shimmerHeight,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
          ),
        ],
      ),
    );
}

/// Status indicator dot
class StatusDot extends StatelessWidget {

  const StatusDot({
    required this.isActive, super.key,
    this.size = 6,
  });
  final bool isActive;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isActive ? AppColors.accentGreen : AppColors.accentRed,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.accentGreen.withValues(alpha: 0.5),
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
    );
}

/// Label with uppercase styling
class BreezLabel extends StatelessWidget {

  const BreezLabel(
    this.text, {
    super.key,
    this.fontSize = 8,
    this.color,
    this.fontWeight = FontWeight.w900,
  });
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: 2,
        color: color ?? colors.textMuted,
      ),
    );
  }
}
