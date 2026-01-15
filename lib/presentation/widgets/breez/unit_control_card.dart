/// Карточка управления устройством - обёртка для MainTempCard
library;

import 'package:flutter/material.dart';
import '../../../core/services/quick_sensors_service.dart';
import '../../../domain/entities/unit_state.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'main_temp_card.dart';

/// Унифицированная карточка управления для всех layout-ов
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

  /// Ожидание подтверждения изменения температуры нагрева
  final bool isPendingHeatingTemperature;

  /// Ожидание подтверждения изменения температуры охлаждения
  final bool isPendingCoolingTemperature;

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
    this.isPendingHeatingTemperature = false,
    this.isPendingCoolingTemperature = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Конвертируем ключи сенсоров в типы
    final selectedSensors = QuickSensorsService.fromKeys(unit.quickSensors);

    return MainTempCard(
      unitName: unit.name,
      temperature: unit.temp,
      heatingTemp: unit.heatingTemp,
      coolingTemp: unit.coolingTemp,
      status: unit.power ? l10n.statusRunning : l10n.statusStopped,
      humidity: unit.humidity,
      outsideTemp: unit.outsideTemp,
      indoorTemp: unit.indoorTemp,
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
      showStats: true,
      isOnline: isOnline,
      isPendingHeatingTemperature: isPendingHeatingTemperature,
      isPendingCoolingTemperature: isPendingCoolingTemperature,
      selectedSensors: selectedSensors,
      sensorUnit: unit,
      deviceTime: unit.deviceTime,
    );
  }
}
