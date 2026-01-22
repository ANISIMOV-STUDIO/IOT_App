/// Operation Graph Widgets - UI components for operation graph
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/graph_data.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _GraphWidgetConstants {
  // Badge - using design system font sizes
  static const double badgeLabelFontSize = AppFontSizes.micro; // 8
  static const double badgeValueFontSize = AppFontSizes.captionSmall; // 11
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
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
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

// =============================================================================
// MULTI-SERIES LEGEND
// =============================================================================

/// Legend widget for multi-series graph
///
/// Shows series labels with color indicators and allows toggling visibility.
class GraphSeriesLegend extends StatelessWidget {

  const GraphSeriesLegend({
    required this.series,
    required this.onToggleVisibility,
    super.key,
  });

  /// List of all series
  final List<GraphSeries> series;

  /// Callback when a series visibility is toggled
  final void Function(String seriesId, {required bool isVisible}) onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xxs,
      children: series.map((s) => _LegendItem(
        label: s.label ?? _getDefaultLabel(s.metric),
        color: s.color,
        isVisible: s.isVisible,
        onTap: () => onToggleVisibility(s.id, isVisible: !s.isVisible),
        colors: colors,
      )).toList(),
    );
  }

  String _getDefaultLabel(GraphMetric metric) {
    const labelMap = <GraphMetric, String>{
      GraphMetric.temperature: 'Temp',
      GraphMetric.humidity: 'Humid',
      GraphMetric.airflow: 'Air',
    };
    return labelMap[metric] ?? '';
  }
}

/// Individual legend item with color indicator
class _LegendItem extends StatelessWidget {

  const _LegendItem({
    required this.label,
    required this.color,
    required this.isVisible,
    required this.onTap,
    required this.colors,
  });

  final String label;
  final Color color;
  final bool isVisible;
  final VoidCallback onTap;
  final BreezColors colors;

  @override
  Widget build(BuildContext context) => Semantics(
      toggled: isVisible,
      label: '$label series',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: isVisible
                ? color.withValues(alpha: AppColors.opacityLight)
                : colors.buttonBg,
            borderRadius: BorderRadius.circular(AppRadius.indicator),
            border: Border.all(
              color: isVisible
                  ? color.withValues(alpha: AppColors.opacityLow)
                  : colors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Color indicator
              Container(
                width: AppSpacing.xs,
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  color: isVisible ? color : colors.textMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              // Label
              Text(
                label,
                style: TextStyle(
                  fontSize: _GraphWidgetConstants.badgeValueFontSize,
                  fontWeight: FontWeight.w600,
                  color: isVisible ? color : colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
