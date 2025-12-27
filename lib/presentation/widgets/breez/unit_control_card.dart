/// Unit Control Card - Wrapper for MainTempCard with unified behavior
library;

import 'package:flutter/material.dart';
import '../../../domain/entities/unit_state.dart';
import 'main_temp_card.dart';

/// Unified unit control card for all layouts
class UnitControlCard extends StatelessWidget {
  final UnitState unit;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final ValueChanged<String>? onModeChanged;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  final bool showControls;
  final bool showModeSelector;

  const UnitControlCard({
    super.key,
    required this.unit,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onModeChanged,
    this.onPowerToggle,
    this.onSettingsTap,
    this.showControls = false,
    this.showModeSelector = false,
  });

  @override
  Widget build(BuildContext context) {
    return MainTempCard(
      unitName: unit.name,
      temperature: unit.temp,
      status: unit.power ? 'В работе' : 'Выключен',
      humidity: unit.humidity,
      airflow: unit.airflowRate,
      filterPercent: unit.filterPercent,
      isPowered: unit.power,
      supplyFan: unit.supplyFan,
      exhaustFan: unit.exhaustFan,
      onPowerToggle: onPowerToggle,
      onSupplyFanChanged: onSupplyFanChanged,
      onExhaustFanChanged: onExhaustFanChanged,
      onSettingsTap: onSettingsTap,
      showControls: showControls,
      selectedMode: unit.mode,
      onModeChanged: onModeChanged,
      showModeSelector: showModeSelector,
    );
  }
}
