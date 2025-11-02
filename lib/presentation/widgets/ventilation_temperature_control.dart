/// Ventilation Temperature Control Widget
///
/// Compact card for temperature monitoring and setpoints
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/hvac_unit.dart';

class VentilationTemperatureControl extends StatelessWidget {
  final HvacUnit unit;

  const VentilationTemperatureControl({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.deviceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.info.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.thermostat,
                  color: AppTheme.info,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Температуры',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Мониторинг и уставки',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Temperature indicators
          Row(
            children: [
              Expanded(
                child: _buildTempIndicator(
                  'Приток',
                  unit.supplyAirTemp,
                  Icons.air,
                  AppTheme.info,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTempIndicator(
                  'В помещении',
                  unit.roomTemp,
                  Icons.home,
                  AppTheme.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildTempIndicator(
                  'На улице',
                  unit.outdoorTemp,
                  Icons.wb_sunny,
                  AppTheme.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTempIndicator(
                  'Влажность',
                  unit.humidity,
                  Icons.water_drop,
                  AppTheme.modeCool,
                  suffix: '%',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Setpoints
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSetpoint(
                    'Нагрев',
                    unit.heatingTemp,
                    Icons.whatshot,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppTheme.backgroundCardBorder,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                Expanded(
                  child: _buildSetpoint(
                    'Охлаждение',
                    unit.coolingTemp,
                    Icons.ac_unit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempIndicator(
    String label,
    double? value,
    IconData icon,
    Color color, {
    String suffix = '°C',
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value != null ? '${value.toStringAsFixed(1)}$suffix' : '--',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetpoint(String label, double? value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value != null ? '${value.toStringAsFixed(0)}°C' : '--',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryOrange,
          ),
        ),
      ],
    );
  }
}
