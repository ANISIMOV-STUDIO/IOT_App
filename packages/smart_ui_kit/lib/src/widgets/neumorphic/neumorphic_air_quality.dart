import 'package:flutter/material.dart';
import 'neumorphic_theme_wrapper.dart';
import '../../theme/tokens/neumorphic_colors.dart';
import '../../theme/tokens/neumorphic_spacing.dart';
import 'neumorphic_compat.dart';

/// Air Quality Card - Shows CO2, pollutants, and quality status
class NeumorphicAirQualityCard extends StatelessWidget {
  final AirQualityLevel level;
  final int co2Ppm;
  final int pollutantsAqi;

  const NeumorphicAirQualityCard({
    super.key,
    required this.level,
    required this.co2Ppm,
    required this.pollutantsAqi,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Air Quality',
              style: theme.typography.titleLarge,
            ),
            Text(
              level.label,
              style: theme.typography.titleMedium.copyWith(
                color: _getLevelColor(),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: NeumorphicSpacing.md),
        
        // Stats row
        Row(
          children: [
            // CO2
            Expanded(
              child: _buildStatCard(
                theme,
                icon: Icons.cloud_outlined,
                label: 'CO₂',
                value: co2Ppm.toString(),
                unit: 'ppm',
                status: _getCO2Status(),
              ),
            ),
            
            const SizedBox(width: NeumorphicSpacing.sm),
            
            // Pollutants
            Expanded(
              child: _buildStatCard(
                theme,
                icon: Icons.blur_on,
                label: 'Pollutants',
                value: pollutantsAqi.toString(),
                unit: 'AQI',
                status: _getPollutantsStatus(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    NeumorphicThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required String status,
  }) {
    return NeumorphicCard(
      padding: const EdgeInsets.all(NeumorphicSpacing.md),
      variant: NeumorphicCardVariant.flat,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: theme.colors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(
                status,
                style: theme.typography.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: NeumorphicSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(label, style: theme.typography.bodySmall),
              const Spacer(),
              Text(value, style: theme.typography.numericMedium),
              Text(unit, style: theme.typography.unit),
            ],
          ),
        ],
      ),
    );
  }

  Color _getLevelColor() {
    switch (level) {
      case AirQualityLevel.excellent:
        return NeumorphicColors.airQualityExcellent;
      case AirQualityLevel.good:
        return NeumorphicColors.airQualityGood;
      case AirQualityLevel.moderate:
        return NeumorphicColors.airQualityModerate;
      case AirQualityLevel.poor:
        return NeumorphicColors.airQualityPoor;
      case AirQualityLevel.hazardous:
        return NeumorphicColors.airQualityHazardous;
    }
  }

  String _getCO2Status() {
    if (co2Ppm < 600) return 'Excellent';
    if (co2Ppm < 800) return 'Good';
    if (co2Ppm < 1000) return 'Moderate';
    return 'Poor';
  }

  String _getPollutantsStatus() {
    if (pollutantsAqi < 50) return 'Excellent';
    if (pollutantsAqi < 100) return 'Good';
    if (pollutantsAqi < 150) return 'Moderate';
    return 'Poor';
  }
}

enum AirQualityLevel {
  excellent('Excellent'),
  good('Good'),
  moderate('Moderate'),
  poor('Poor'),
  hazardous('Hazardous');

  final String label;
  const AirQualityLevel(this.label);
}
