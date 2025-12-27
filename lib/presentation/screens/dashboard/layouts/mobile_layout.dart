/// Mobile Layout - Single column layout for mobile devices (no-scroll)
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../widgets/breez/breez.dart';

/// Mobile layout (single column, no scroll)
class MobileLayout extends StatelessWidget {
  final UnitState unit;
  final ValueChanged<int>? onTemperatureIncrease;
  final ValueChanged<int>? onTemperatureDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final ValueChanged<String>? onModeChanged;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  final bool compact;

  const MobileLayout({
    super.key,
    required this.unit,
    this.onTemperatureIncrease,
    this.onTemperatureDecrease,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onModeChanged,
    this.onPowerToggle,
    this.onSettingsTap,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: MainTempCard(
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
        showControls: true,
        selectedMode: unit.mode,
        onModeChanged: onModeChanged,
        showModeSelector: true,
      ),
    );
  }
}
