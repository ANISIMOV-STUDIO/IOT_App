/// Air Quality Tab Widget
///
/// Air quality tab showing air quality metrics, airflow animation, and recommendations
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../air_quality_indicator.dart';
import '../airflow_animation.dart';
import '../animated_stat_card.dart';

class AirQualityTab extends StatelessWidget {
  final HvacUnit unit;

  const AirQualityTab({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data for air quality
    const airQualityLevel = AirQualityLevel.good;
    const co2Level = 650;
    const pm25Level = 12.5;
    const vocLevel = 180.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Air quality indicator
          const AirQualityIndicator(
            level: airQualityLevel,
            co2Level: co2Level,
            pm25Level: pm25Level,
            vocLevel: vocLevel,
          ),

          const SizedBox(height: 20.0),

          // Airflow animation
          AirflowAnimation(
            isActive: unit.power,
            speed: unit.supplyFanSpeed ?? 0,
          ),

          const SizedBox(height: 20.0),

          // Stats with animation
          const Text(
            'Текущие показатели',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: AnimatedStatCard(
                  label: 'Температура',
                  value: '${unit.supplyAirTemp?.toInt() ?? 0}°C',
                  icon: Icons.thermostat,
                  color: HvacColors.primaryOrange,
                  trend: '+0.5°C',
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: AnimatedStatCard(
                  label: 'Влажность',
                  value: '${unit.humidity.toInt()}%',
                  icon: Icons.water_drop,
                  color: HvacColors.info,
                  trend: '-2%',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: AnimatedStatCard(
                  label: 'Приточный',
                  value: '${unit.supplyFanSpeed ?? 0}%',
                  icon: Icons.air,
                  color: HvacColors.success,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: AnimatedStatCard(
                  label: 'Вытяжной',
                  value: '${unit.exhaustFanSpeed ?? 0}%',
                  icon: Icons.air,
                  color: HvacColors.warning,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20.0),

          // Recommendations
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: HvacColors.info.withValues(alpha: 0.1),
              borderRadius: HvacRadius.mdRadius,
              border: Border.all(
                color: HvacColors.info.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: HvacColors.info,
                  size: 24.0,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Рекомендация',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: HvacColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Качество воздуха хорошее. Рекомендуем поддерживать текущий режим вентиляции.',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: HvacColors.textSecondary,
                        ),
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
}
