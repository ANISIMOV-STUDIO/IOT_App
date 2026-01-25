/// Карточка управления устройством - обёртка для MainTempCard
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/services/quick_sensors_service.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/main_temp_card.dart';

/// Унифицированная карточка управления для всех layout-ов
///
/// Отображает readonly данные с устройства:
/// - temperatureSetpoint — уставка температуры с пульта
/// - actualSupplyFan — актуальные обороты приточного вентилятора
/// - actualExhaustFan — актуальные обороты вытяжного вентилятора
///
/// Изменение параметров происходит через режимы (Settings → Modes)
class UnitControlCard extends StatelessWidget {

  const UnitControlCard({
    required this.unit, super.key,
    this.onPowerToggle,
    this.onSettingsTap,
    this.onSyncTap,
    this.isSyncing = false,
    this.isPowerLoading = false,
    this.isScheduleEnabled = false,
    this.isScheduleLoading = false,
    this.onScheduleToggle,
    this.isOnline = true,
  });
  final UnitState unit;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  /// Callback для принудительного обновления данных
  final VoidCallback? onSyncTap;
  /// Флаг синхронизации (для анимации вращения иконки)
  final bool isSyncing;
  final bool isPowerLoading;
  final bool isScheduleEnabled;
  final bool isScheduleLoading;
  final VoidCallback? onScheduleToggle;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Конвертируем ключи сенсоров в типы
    final selectedSensors = QuickSensorsService.fromKeys(unit.quickSensors);

    return MainTempCard(
      unitName: unit.name,
      temperature: unit.temp,
      // Уставка температуры с пульта (readonly)
      temperatureSetpoint: unit.temperatureSetpoint,
      // Текущий режим работы
      currentMode: unit.mode,
      status: unit.power ? l10n.statusRunning : l10n.statusStopped,
      humidity: unit.humidity,
      outsideTemp: unit.outsideTemp,
      indoorTemp: unit.indoorTemp,
      airflow: 0,
      filterPercent: unit.filterPercent,
      isPowered: unit.power,
      // Актуальные обороты вентиляторов (readonly)
      supplyFan: unit.actualSupplyFan,
      exhaustFan: unit.actualExhaustFan,
      onPowerToggle: onPowerToggle,
      onSettingsTap: onSettingsTap,
      showControls: true,
      isPowerLoading: isPowerLoading,
      isScheduleEnabled: isScheduleEnabled,
      isScheduleLoading: isScheduleLoading,
      onScheduleToggle: onScheduleToggle,
      isOnline: isOnline,
      selectedSensors: selectedSensors,
      sensorUnit: unit,
      updatedAt: unit.updatedAt,
      onSyncTap: onSyncTap,
      isSyncing: isSyncing,
    );
  }
}
