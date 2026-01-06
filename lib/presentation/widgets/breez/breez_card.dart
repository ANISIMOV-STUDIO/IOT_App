/// BREEZ Card & Core Components
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';

// Re-export button components for backwards compatibility
export 'breez_button.dart';
export 'breez_icon_button.dart';
export 'breez_dialog_button.dart';
export 'breez_settings_tile.dart';

/// BREEZ styled card using Material Card
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

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: disabled ? 0.3 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: colors.border),
        ),
        padding: padding ?? const EdgeInsets.all(24),
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
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              (title ?? '').toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: colors.text,
                              ),
                            ),
                          ),
                        if (description != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              description ?? '',
                              style: TextStyle(
                                fontSize: 12,
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
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.indicator),
              ),
            ),
          if (title != null) const SizedBox(height: 4),
          if (description != null)
            Container(
              width: 120,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.indicator),
              ),
            ),
          if (description != null) const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 100,
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
