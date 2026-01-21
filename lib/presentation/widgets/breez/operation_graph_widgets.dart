/// Operation Graph Widgets - UI components for operation graph
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _GraphWidgetConstants {
  // Badge
  static const double badgeLabelFontSize = 9;
  static const double badgeValueFontSize = 11;
  static const double badgePaddingH = 8;
  static const double badgePaddingV = 4;

  // Metric tab
  static const double tabIconSize = 20;
  static const double tabLabelFontSize = 8;
  static const double tabPaddingH = 14;
  static const double tabPaddingV = 4;
  static const double tabIconLabelGap = 3;
}

/// Statistic badge showing min/max/avg values
class GraphStatBadge extends StatelessWidget {

  const GraphStatBadge({
    required this.label, required this.value, required this.color, super.key,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _GraphWidgetConstants.badgePaddingH,
        vertical: _GraphWidgetConstants.badgePaddingV,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppColors.opacityLight),
        borderRadius: BorderRadius.circular(AppRadius.indicator),
        border: Border.all(
          color: color.withValues(alpha: AppColors.opacityLow),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: _GraphWidgetConstants.badgeLabelFontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            value,
            style: TextStyle(
              fontSize: _GraphWidgetConstants.badgeValueFontSize,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Metric selection tab for switching between temperature/humidity/airflow
class GraphMetricTab extends StatelessWidget {

  const GraphMetricTab({
    required this.icon, required this.label, super.key,
    this.isSelected = false,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return BreezButton(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: _GraphWidgetConstants.tabPaddingH,
        vertical: _GraphWidgetConstants.tabPaddingV,
      ),
      backgroundColor: isSelected
          ? AppColors.accent.withValues(alpha: AppColors.opacitySubtle)
          : Colors.transparent,
      hoverColor: isSelected
          ? AppColors.accent.withValues(alpha: AppColors.opacityLow)
          : colors.buttonBg,
      border: Border.all(
        color: isSelected ? AppColors.accent.withValues(alpha: AppColors.opacityStrong) : colors.border,
      ),
      shadows: isSelected
          ? [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: AppColors.opacityLow),
                blurRadius: AppSpacing.xs,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: _GraphWidgetConstants.tabIconSize,
            color: isSelected ? AppColors.accent : colors.textMuted,
          ),
          const SizedBox(height: _GraphWidgetConstants.tabIconLabelGap),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: _GraphWidgetConstants.tabLabelFontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: isSelected ? AppColors.accent : colors.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
