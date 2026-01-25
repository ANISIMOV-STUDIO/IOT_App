/// Sensors Grid Widget - displays all HVAC sensors in a grid layout
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для SensorsGrid
abstract class _SensorGridConstants {
  static const double labelLineHeight = 1.2;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Grid of HVAC sensors (4 rows x 3 columns)
class SensorsGrid extends StatelessWidget {

  const SensorsGrid({
    required this.unit,
    super.key,
  });
  final UnitState unit;

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
      _SensorData(Icons.thermostat_outlined, unit.outsideTemp != null ? '${unit.outsideTemp!.toStringAsFixed(1)}°C' : '—', l10n.outdoorTemp),
      _SensorData(Icons.home_outlined, unit.indoorTemp != null ? '${unit.indoorTemp!.toStringAsFixed(1)}°C' : '—', l10n.indoorTemp),
      _SensorData(Icons.air, unit.recuperatorTemperature != null ? '${unit.recuperatorTemperature!.toStringAsFixed(1)}°C' : '—', l10n.recuperatorTemperature),
      // Row 2
      _SensorData(Icons.thermostat, unit.supplyTemp != null ? '${unit.supplyTemp!.toStringAsFixed(1)}°C' : '—', l10n.supplyTemp),
      _SensorData(Icons.cloud_outlined, unit.coIndicator != null ? '${unit.coIndicator}' : '—', l10n.coIndicator),
      _SensorData(Icons.recycling, unit.recuperatorEfficiency != null ? '${unit.recuperatorEfficiency}%' : '—', l10n.recuperatorEfficiency),
      // Row 3
      _SensorData(Icons.ac_unit, unit.freeCooling ? 'ON' : 'OFF', l10n.freeCooling),
      _SensorData(Icons.local_fire_department_outlined, unit.heaterPower != null ? '${unit.heaterPower}%' : '—', l10n.heater),
      _SensorData(Icons.severe_cold, unit.coolerStatus ?? '—', l10n.coolerStatus),
      // Row 4
      _SensorData(Icons.speed, unit.ductPressure != null ? '${unit.ductPressure} Па' : '—', l10n.ductPressure),
      _SensorData(Icons.water_drop_outlined, unit.humidity != null ? '${unit.humidity}%' : '—', l10n.relativeHumidity),
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
            size: AppIconSizes.standard,
            color: colors.accent,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            sensor.value,
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs / 2),
          Text(
            sensor.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFontSizes.badge,
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

  const _SensorData(this.icon, this.value, this.label);
  final IconData icon;
  final String value;
  final String label;
}
