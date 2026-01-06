/// Operation Graph Widgets - UI components for operation graph
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import 'breez_card.dart';

/// Statistic badge showing min/max/avg values
class GraphStatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const GraphStatBadge({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.indicator),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
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
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const GraphMetricTab({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return BreezButton(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      backgroundColor: isSelected
          ? AppColors.accent.withValues(alpha: 0.15)
          : Colors.transparent,
      hoverColor: isSelected
          ? AppColors.accent.withValues(alpha: 0.25)
          : colors.buttonBg,
      border: Border.all(
        color: isSelected ? AppColors.accent.withValues(alpha: 0.4) : colors.border,
        width: 1,
      ),
      shadows: isSelected
          ? [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: 8,
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
            size: 20,
            color: isSelected ? AppColors.accent : colors.textMuted,
          ),
          const SizedBox(height: 3),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 8,
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
