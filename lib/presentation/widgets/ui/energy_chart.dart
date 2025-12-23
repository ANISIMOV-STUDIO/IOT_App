/// Energy Chart - Bar chart for energy consumption
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'app_card.dart';

/// Energy data point
class EnergyDataPoint {
  final String label;
  final double value;

  const EnergyDataPoint({
    required this.label,
    required this.value,
  });
}

/// Energy chart card with bar chart
class EnergyChartCard extends StatelessWidget {
  final String title;
  final List<EnergyDataPoint> data;
  final String? unit;
  final double? maxValue;

  const EnergyChartCard({
    super.key,
    this.title = 'Энергопотребление',
    required this.data,
    this.unit = 'кВт⋅ч',
    this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final max = maxValue ?? data.map((d) => d.value).reduce((a, b) => a > b ? a : b);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.asMap().entries.map((entry) {
                final index = entry.key;
                final point = entry.value;
                final isLast = index == data.length - 1;
                final height = max > 0 ? (point.value / max) : 0.0;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: isLast ? 0 : 8),
                    child: _BarItem(
                      label: point.label,
                      value: point.value,
                      height: height,
                      unit: unit,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final String label;
  final double value;
  final double height;
  final String? unit;

  const _BarItem({
    required this.label,
    required this.value,
    required this.height,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Value label
        Text(
          '${value.toStringAsFixed(0)}${unit != null ? ' $unit' : ''}',
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        // Bar
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: height.clamp(0.05, 1.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.primary,
                      AppColors.accent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Month label
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
