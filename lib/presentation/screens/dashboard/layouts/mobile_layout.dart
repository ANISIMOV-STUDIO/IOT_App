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
    return Padding(
      padding: EdgeInsets.all(AppSpacing.sm),
      child: Column(
        children: [
          // Climate card - takes most of the space
          Expanded(
            flex: 5,
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

          SizedBox(height: AppSpacing.sm),

          // Mode selector - compact row at bottom
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: unit.power ? 1.0 : 0.3,
            child: IgnorePointer(
              ignoring: !unit.power,
              child: ModeSelector(
                unitName: unit.name,
                selectedMode: unit.mode,
                onModeChanged: onModeChanged,
                compact: true, // Always compact on mobile
              ),
            ),
          ),
        ],
      ),
    );
  }
}
