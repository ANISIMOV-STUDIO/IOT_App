/// Mobile Layout - Single column layout for mobile devices
library;

import 'package:flutter/material.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../widgets/breez/breez.dart';

/// Mobile layout (single column)
class MobileLayout extends StatelessWidget {
  final UnitState unit;
  final ValueChanged<int>? onTemperatureIncrease;
  final ValueChanged<int>? onTemperatureDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final ValueChanged<String>? onModeChanged;
  final VoidCallback? onPowerToggle;
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
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Climate card
          SizedBox(
            height: 480,
            child: ClimateCard(
              unitName: unit.name,
              isPowered: unit.power,
              temperature: unit.temp,
              supplyFan: unit.supplyFan,
              exhaustFan: unit.exhaustFan,
              filterPercent: unit.filterPercent,
              airflowRate: unit.airflowRate,
              onTemperatureIncrease: onTemperatureIncrease,
              onTemperatureDecrease: onTemperatureDecrease,
              onSupplyFanChanged: onSupplyFanChanged,
              onExhaustFanChanged: onExhaustFanChanged,
              onPowerTap: onPowerToggle,
            ),
          ),

          const SizedBox(height: 12),

          // Mode selector
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: unit.power ? 1.0 : 0.3,
            child: IgnorePointer(
              ignoring: !unit.power,
              child: ModeSelector(
                unitName: unit.name,
                selectedMode: unit.mode,
                onModeChanged: onModeChanged,
                compact: compact,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
