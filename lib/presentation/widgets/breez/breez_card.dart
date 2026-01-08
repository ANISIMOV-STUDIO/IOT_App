/// BREEZ Card & Core Components
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';

// Re-export button components for backwards compatibility
export 'breez_button.dart';
export 'breez_icon_button.dart';
export 'breez_dialog_button.dart';
export 'breez_settings_tile.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezCard
abstract class _CardConstants {
  static const double defaultPadding = 24.0; // = AppSpacing.xl - 8
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double disabledOpacity = 0.3;
  static const double titleFontSize = 10.0;
  static const double descriptionFontSize = 12.0;
  static const double titleLetterSpacing = 2.0;
  static const double shimmerHeight = 100.0;
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
  final Widget child;
  final EdgeInsets? padding;
  final bool disabled;
  final bool isLoading;
  final String? title;
  final String? description;

  const BreezCard({
    super.key,
    required this.child,
    this.padding,
    this.disabled = false,
    this.isLoading = false,
    this.title,
    this.description,
  });

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
                              padding: EdgeInsets.only(bottom: AppSpacing.xxs),
                              child: Text(
                                (title ?? '').toUpperCase(),
                                style: TextStyle(
                                  fontSize: _CardConstants.titleFontSize,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: _CardConstants.titleLetterSpacing,
                                  color: colors.text,
                                ),
                              ),
                            ),
                          if (description != null)
                            Padding(
                              padding: EdgeInsets.only(bottom: AppSpacing.md),
                              child: Text(
                                description ?? '',
                                style: TextStyle(
                                  fontSize: _CardConstants.descriptionFontSize,
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

  Widget _buildShimmer(BuildContext context, BreezColors colors, bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase,
      highlightColor: isDark ? AppColors.darkShimmerHighlight : AppColors.lightShimmerHighlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              width: 80,
              height: _CardConstants.titleFontSize,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.indicator),
              ),
            ),
          if (title != null) SizedBox(height: AppSpacing.xxs),
          if (description != null)
            Container(
              width: 120,
              height: _CardConstants.descriptionFontSize,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.indicator),
              ),
            ),
          if (description != null) SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            height: _CardConstants.shimmerHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
          ),
        ],
      ),
    );
  }
}

/// Status indicator dot
class StatusDot extends StatelessWidget {
  final bool isActive;
  final double size;

  const StatusDot({
    super.key,
    required this.isActive,
    this.size = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
}

/// Label with uppercase styling
class BreezLabel extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;

  const BreezLabel(
    this.text, {
    super.key,
    this.fontSize = 8,
    this.color,
    this.fontWeight = FontWeight.w900,
  });

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
