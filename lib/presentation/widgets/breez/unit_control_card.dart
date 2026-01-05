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
  final ValueChanged<String>? onModeChanged;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  final bool isPowerLoading;

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
    this.onModeChanged,
    this.onPowerToggle,
    this.onSettingsTap,
    this.isPowerLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Определяем доступное пространство
        final height = constraints.maxHeight;

        // Компактный режим: нет места для controls и mode selector
        // Обычно когда карточка в списке или маленький экран
        final isCompact = height < 400;

        // Показываем controls если есть обработчики и достаточно места
        final showControls = !isCompact &&
            (onPowerToggle != null || onSettingsTap != null);

        // Показываем mode selector если есть обработчик и достаточно места
        final showModeSelector = !isCompact && onModeChanged != null;

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
          showControls: showControls,
          selectedMode: unit.mode,
          onModeChanged: onModeChanged,
          showModeSelector: showModeSelector,
          isPowerLoading: isPowerLoading,
          sensorUnit: unit,
        );
      },
    );
  }
}
