/// Environment card - combined temperature, humidity, CO2 display
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';

/// Combined environment metrics card
/// Shows temperature, humidity, and CO2 in a clean, unified layout
class EnvironmentCard extends StatelessWidget {
  final double? temperature;
  final int? humidity;
  final int? co2;
  final String temperatureLabel;
  final String humidityLabel;
  final String co2Label;

  const EnvironmentCard({
    super.key,
    this.temperature,
    this.humidity,
    this.co2,
    this.temperatureLabel = 'Температура',
    this.humidityLabel = 'Влажность',
    this.co2Label = 'CO₂',
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
            children: [
              Icon(
                Icons.sensors,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Показатели среды',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.foreground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Metrics row
          Expanded(
            child: Row(
              children: [
                // Temperature
                Expanded(
                  child: _MetricItem(
                    icon: Icons.thermostat_outlined,
                    value: temperature != null ? '${temperature!.round()}°' : '--',
                    label: temperatureLabel,
                    color: _getTemperatureColor(temperature),
                  ),
                ),

                // Divider
                Container(
                  width: 1,
                  height: 48,
                  color: theme.colorScheme.border,
                ),

                // Humidity
                Expanded(
                  child: _MetricItem(
                    icon: Icons.water_drop_outlined,
                    value: humidity != null ? '$humidity%' : '--',
                    label: humidityLabel,
                    color: _getHumidityColor(humidity),
                  ),
                ),

                // Divider
                Container(
                  width: 1,
                  height: 48,
                  color: theme.colorScheme.border,
                ),

                // CO2
                Expanded(
                  child: _MetricItem(
                    icon: Icons.cloud_outlined,
                    value: co2 != null ? '$co2' : '--',
                    label: co2Label,
                    unit: 'ppm',
                    color: _getCo2Color(co2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTemperatureColor(double? temp) {
    if (temp == null) return Colors.grey;
    if (temp < 18) return AppColors.cooling;
    if (temp > 26) return AppColors.heating;
    return AppColors.success;
  }

  Color _getHumidityColor(int? humidity) {
    if (humidity == null) return Colors.grey;
    if (humidity < 30 || humidity > 70) return AppColors.warning;
    return AppColors.info;
  }

  Color _getCo2Color(int? co2) {
    if (co2 == null) return Colors.grey;
    if (co2 < 800) return AppColors.success;
    if (co2 < 1200) return AppColors.warning;
    return AppColors.error;
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String? unit;
  final Color color;

  const _MetricItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            if (unit != null)
              Text(
                ' $unit',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
      ],
    );
  }
}
