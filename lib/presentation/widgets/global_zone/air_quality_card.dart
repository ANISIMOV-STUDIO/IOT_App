/// Air quality card
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';

/// Card showing indoor air quality metrics
class AirQualityCard extends StatelessWidget {
  final int co2Ppm;
  final double pm25;
  final double voc;
  final String title;

  const AirQualityCard({
    super.key,
    required this.co2Ppm,
    this.pm25 = 12,
    this.voc = 0.3,
    this.title = 'Качество воздуха',
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final qualityLabel = _getQualityLabel(co2Ppm);
    final qualityColor = _getCo2Color(co2Ppm);

    return ShadCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 200;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: isCompact ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.foreground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ShadBadge(
                    backgroundColor: qualityColor.withValues(alpha: 0.15),
                    foregroundColor: qualityColor,
                    child: Text(qualityLabel),
                  ),
                ],
              ),
              SizedBox(height: isCompact ? 8 : 12),

              // Content
              Expanded(
                child: isCompact
                    ? _buildCompactContent(theme, qualityColor)
                    : _buildFullContent(theme, qualityColor),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCompactContent(ShadThemeData theme, Color qualityColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$co2Ppm',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: qualityColor,
            ),
          ),
          Text(
            'CO₂ ppm',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullContent(ShadThemeData theme, Color qualityColor) {
    return Row(
      children: [
        // CO2 gauge
        Expanded(
          flex: 2,
          child: _Co2Gauge(co2: co2Ppm, color: qualityColor),
        ),
        const SizedBox(width: 12),
        // Additional metrics
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MetricRow(
                label: 'PM2.5',
                value: pm25.toString(),
                unit: 'μg/m³',
                color: _getPm25Color(pm25),
              ),
              const SizedBox(height: 8),
              _MetricRow(
                label: 'VOC',
                value: voc.toString(),
                unit: 'ppm',
                color: _getVocColor(voc),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getQualityLabel(int co2) {
    if (co2 < 600) return 'Отлично';
    if (co2 < 800) return 'Хорошо';
    if (co2 < 1000) return 'Умеренно';
    if (co2 < 1500) return 'Плохо';
    return 'Опасно';
  }

  Color _getCo2Color(int ppm) {
    if (ppm < 600) return AppColors.success;
    if (ppm < 800) return AppColors.airGood;
    if (ppm < 1000) return AppColors.warning;
    return AppColors.error;
  }

  Color _getPm25Color(double pm25) {
    if (pm25 <= 12) return AppColors.airGood;
    if (pm25 <= 35) return AppColors.warning;
    return AppColors.error;
  }

  Color _getVocColor(double voc) {
    if (voc <= 0.5) return AppColors.success;
    if (voc <= 1.0) return AppColors.airGood;
    return AppColors.warning;
  }
}

class _Co2Gauge extends StatelessWidget {
  final int co2;
  final Color color;

  const _Co2Gauge({required this.co2, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final percentage = ((2000 - co2) / 2000).clamp(0.0, 1.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percentage,
                strokeWidth: 4,
                backgroundColor: theme.colorScheme.muted.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation(color),
              ),
              Text(
                '$co2',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        Text(
          'CO₂',
          style: TextStyle(
            fontSize: 10,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.foreground,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
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
