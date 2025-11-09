/// Overview Tab Widget
///
/// Main orchestrator for unit detail screen overview tab
/// Composes all overview components into a scrollable layout
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import 'overview/overview_hero_temperature.dart';
import 'overview/overview_temperature_chart.dart';
import 'overview/overview_status_card.dart';
import 'overview/overview_quick_stats.dart';
import 'overview/overview_control_buttons.dart';
import 'overview/overview_fan_speeds.dart';
import 'overview/overview_maintenance_card.dart';

class OverviewTab extends StatelessWidget {
  final HvacUnit unit;

  const OverviewTab({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(HvacSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Temperature Display with Gradient Border
          OverviewHeroTemperature(unit: unit),
          const HvacGap.lg(),

          // Temperature Chart
          OverviewTemperatureChart(unit: unit),
          const HvacGap.lg(),

          // Status card
          OverviewStatusCard(unit: unit),
          const HvacGap.lg(),

          // Quick stats
          OverviewQuickStats(unit: unit),
          const HvacGap.lg(),

          // Control Buttons with Neumorphic Design
          OverviewControlButtons(
            unit: unit,
            onPowerTap: () {
              // TODO: Implement power toggle via BLoC
            },
            onModeTap: () {
              // TODO: Implement mode selector via BLoC
            },
          ),
          const HvacGap.lg(),

          // Fan speeds card
          OverviewFanSpeeds(unit: unit),
          const HvacGap.lg(),

          // Maintenance card
          const OverviewMaintenanceCard(),
        ],
      ),
    );
  }
}
