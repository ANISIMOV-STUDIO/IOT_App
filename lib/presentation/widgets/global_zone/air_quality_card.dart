/// Air quality card
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';

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
    final t = NeumorphicTheme.of(context);
    final qualityLabel = _getQualityLabel(co2Ppm);
    final qualityColor = _getCo2Color(co2Ppm);

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: t.typography.titleLarge),
              NeumorphicBadge(
                text: qualityLabel,
                color: qualityColor,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Content
          Expanded(
            child: Row(
              children: [
                // CO2 gauge
                Expanded(
                  flex: 2,
                  child: _Co2Gauge(co2: co2Ppm, color: qualityColor),
                ),
                const SizedBox(width: 16),
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
            ),
          ),
        ],
      ),
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
    if (ppm < 600) return NeumorphicColors.airQualityExcellent;
    if (ppm < 800) return NeumorphicColors.airQualityGood;
    if (ppm < 1000) return NeumorphicColors.airQualityModerate;
    return NeumorphicColors.airQualityPoor;
  }

  Color _getPm25Color(double pm25) {
    if (pm25 <= 12) return NeumorphicColors.airQualityGood;
    if (pm25 <= 35) return NeumorphicColors.airQualityModerate;
    return NeumorphicColors.airQualityPoor;
  }

  Color _getVocColor(double voc) {
    if (voc <= 0.5) return NeumorphicColors.airQualityExcellent;
    if (voc <= 1.0) return NeumorphicColors.airQualityGood;
    return NeumorphicColors.airQualityModerate;
  }
}

class _Co2Gauge extends StatelessWidget {
  final int co2;
  final Color color;

  const _Co2Gauge({required this.co2, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = NeumorphicTheme.of(context);
    final percentage = ((2000 - co2) / 2000).clamp(0.0, 1.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percentage,
                strokeWidth: 6,
                backgroundColor: t.colors.textTertiary.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(color),
              ),
              Text(
                '$co2',
                style: t.typography.numericMedium.copyWith(color: color),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text('CO₂ ppm', style: t.typography.labelSmall),
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
    final t = NeumorphicTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: t.typography.bodyMedium),
        Row(
          children: [
            Text(
              value,
              style: t.typography.titleMedium.copyWith(color: color),
            ),
            const SizedBox(width: 4),
            Text(unit, style: t.typography.bodySmall),
          ],
        ),
      ],
    );
  }
}
