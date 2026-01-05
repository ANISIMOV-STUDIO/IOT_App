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
  final VoidCallback? onHeatingTempIncrease;
  final VoidCallback? onHeatingTempDecrease;
  final VoidCallback? onCoolingTempIncrease;
  final VoidCallback? onCoolingTempDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final ValueChanged<String>? onModeChanged;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  final bool compact;
  final bool isPowerLoading;

  const MobileLayout({
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
    this.compact = true,
    this.isPowerLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: UnitControlCard(
        unit: unit,
        onTemperatureIncrease: onTemperatureIncrease != null
            ? () => onTemperatureIncrease!(unit.temp + 1)
            : null,
        onTemperatureDecrease: onTemperatureDecrease != null
            ? () => onTemperatureDecrease!(unit.temp - 1)
            : null,
        onHeatingTempIncrease: onHeatingTempIncrease,
        onHeatingTempDecrease: onHeatingTempDecrease,
        onCoolingTempIncrease: onCoolingTempIncrease,
        onCoolingTempDecrease: onCoolingTempDecrease,
        onSupplyFanChanged: onSupplyFanChanged,
        onExhaustFanChanged: onExhaustFanChanged,
        onModeChanged: onModeChanged,
        onPowerToggle: onPowerToggle,
        onSettingsTap: onSettingsTap,
        isPowerLoading: isPowerLoading,
      ),
    );
  }
}
