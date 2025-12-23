/// Energy statistics card
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../charts/energy_chart.dart';

/// Card showing energy consumption statistics
class EnergyStatsCard extends StatelessWidget {
  final double totalKwh;
  final int totalHours;
  final List<double> hourlyData;
  final String periodLabel;

  // Labels
  final String title;
  final String spentLabel;
  final String hoursLabel;

  const EnergyStatsCard({
    super.key,
    required this.totalKwh,
    required this.totalHours,
    required this.hourlyData,
    this.periodLabel = 'Сегодня',
    this.title = 'Статистика использования',
    this.spentLabel = 'Всего потрачено',
    this.hoursLabel = 'Всего часов',
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.foreground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              ShadBadge(
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                foregroundColor: AppColors.primary,
                child: Text(periodLabel),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Stats row
          Row(
            children: [
              _MiniStat(
                label: spentLabel,
                value: totalKwh.toStringAsFixed(1),
                unit: 'кВт⋅ч',
              ),
              const SizedBox(width: 24),
              _MiniStat(
                label: hoursLabel,
                value: '$totalHours',
                unit: 'ч',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Chart
          Expanded(
            child: EnergyConsumptionChart(
              hourlyData: hourlyData.isNotEmpty
                  ? hourlyData
                  : EnergyChartData.generateSampleHourlyData(),
              height: 60,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.foreground,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
