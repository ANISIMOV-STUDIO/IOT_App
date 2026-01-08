/// Sensors Grid Widget - displays all HVAC sensors in a grid layout
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../generated/l10n/app_localizations.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для SensorsGrid
abstract class _SensorGridConstants {
  static const double iconSize = 20.0;
  static const double valueFontSize = 13.0;
  static const double labelFontSize = 9.0;
  static const double labelLineHeight = 1.2;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Grid of HVAC sensors (4 rows x 3 columns)
class SensorsGrid extends StatelessWidget {
  final UnitState unit;

  const SensorsGrid({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = BreezColors.of(context);

    // Row 1: Outdoor temp, Indoor temp, Supply temp after recup
    // Row 2: Supply temp, CO2, Recuperator efficiency
    // Row 3: Free cooling, Heater performance, Cooler status
    // Row 4: Duct pressure, Humidity, (empty)

    final sensors = [
      // Row 1
      _SensorData(Icons.thermostat_outlined, '${unit.outsideTemp}°', l10n.outdoorTemp),
      _SensorData(Icons.home_outlined, '${unit.indoorTemp}°', l10n.indoorTemp),
      _SensorData(Icons.air, '${unit.supplyTempAfterRecup}°', l10n.supplyTempAfterRecup),
      // Row 2
      _SensorData(Icons.thermostat, '${unit.supplyTemp}°', l10n.supplyTemp),
      _SensorData(Icons.cloud_outlined, '${unit.co2Level} ppm', l10n.co2Level),
      _SensorData(Icons.recycling, '${unit.recuperatorEfficiency}%', l10n.recuperatorEfficiency),
      // Row 3
      _SensorData(Icons.ac_unit, '${unit.freeCooling} м³/ч', l10n.freeCooling),
      _SensorData(Icons.local_fire_department_outlined, '${unit.heaterPerformance}%', l10n.heaterPerformance),
      _SensorData(Icons.severe_cold, '${unit.coolerStatus}%', l10n.coolerStatus),
      // Row 4
      _SensorData(Icons.speed, '${unit.ductPressure} Па', l10n.ductPressure),
      _SensorData(Icons.water_drop_outlined, '${unit.humidity}%', l10n.relativeHumidity),
    ];

    return Column(
      children: [
        for (int row = 0; row < 4; row++)
          Padding(
            padding: EdgeInsets.only(
              bottom: row < 3 ? AppSpacing.md : 0,
            ),
            child: Row(
              children: [
                for (int col = 0; col < 3; col++)
                  Expanded(
                    child: _buildSensorCell(
                      context,
                      colors,
                      row * 3 + col < sensors.length ? sensors[row * 3 + col] : null,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSensorCell(BuildContext context, BreezColors colors, _SensorData? sensor) {
    if (sensor == null) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: '${sensor.label}: ${sensor.value}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            sensor.icon,
            size: _SensorGridConstants.iconSize,
            color: AppColors.accent,
          ),
          SizedBox(height: AppSpacing.xxs),
          Text(
            sensor.value,
            style: TextStyle(
              fontSize: _SensorGridConstants.valueFontSize,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          SizedBox(height: AppSpacing.xxs / 2),
          Text(
            sensor.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: _SensorGridConstants.labelFontSize,
              color: colors.textMuted,
              height: _SensorGridConstants.labelLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _SensorData {
  final IconData icon;
  final String value;
  final String label;

  const _SensorData(this.icon, this.value, this.label);
}
