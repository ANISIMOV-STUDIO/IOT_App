/// Unit Control Card - Wrapper for MainTempCard with unified behavior
library;

import 'package:flutter/material.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'main_temp_card.dart';

/// Unified unit control card for all layouts (adaptive)
class UnitControlCard extends StatelessWidget {
  final UnitState unit;
  final VoidCallback? onTemperatureIncrease;
  final VoidCallback? onTemperatureDecrease;
  final VoidCallback? onHeatingTempIncrease;
  final VoidCallback? onHeatingTempDecrease;
  final VoidCallback? onCoolingTempIncrease;
  final VoidCallback? onCoolingTempDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  final bool isPowerLoading;
  final bool isScheduleEnabled;
  final bool isScheduleLoading;
  final VoidCallback? onScheduleToggle;
  final bool isOnline;

  const UnitControlCard({
    super.key,
    required this.unit,
    this.onTemperatureIncrease,
    this.onTemperatureDecrease,
    this.onHeatingTempIncrease,
    this.onHeatingTempDecrease,
    this.onCoolingTempIncrease,
    this.onCoolingTempDecrease,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onPowerToggle,
    this.onSettingsTap,
    this.isPowerLoading = false,
    this.isScheduleEnabled = false,
    this.isScheduleLoading = false,
    this.onScheduleToggle,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Единый виджет управления - всегда показывает controls, без показателей
    return MainTempCard(
      unitName: unit.name,
      temperature: unit.temp,
      heatingTemp: unit.heatingTemp,
      coolingTemp: unit.coolingTemp,
      status: unit.power ? l10n.statusRunning : l10n.statusStopped,
      humidity: unit.humidity,
      airflow: unit.airflowRate,
      filterPercent: unit.filterPercent,
      isPowered: unit.power,
      supplyFan: unit.supplyFan,
      exhaustFan: unit.exhaustFan,
      onPowerToggle: onPowerToggle,
      onHeatingTempIncrease: onHeatingTempIncrease,
      onHeatingTempDecrease: onHeatingTempDecrease,
      onCoolingTempIncrease: onCoolingTempIncrease,
      onCoolingTempDecrease: onCoolingTempDecrease,
      onSupplyFanChanged: onSupplyFanChanged,
      onExhaustFanChanged: onExhaustFanChanged,
      onSettingsTap: onSettingsTap,
      showControls: true,
      isPowerLoading: isPowerLoading,
      isScheduleEnabled: isScheduleEnabled,
      isScheduleLoading: isScheduleLoading,
      onScheduleToggle: onScheduleToggle,
      showStats: false, // Без показателей - единообразно на всех платформах
      isOnline: isOnline,
    );
  }
}
