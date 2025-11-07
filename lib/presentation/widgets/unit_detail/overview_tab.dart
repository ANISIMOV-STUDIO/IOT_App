/// Overview Tab Widget
///
/// Main orchestrator for unit detail screen overview tab
/// Composes all overview components into a scrollable layout
library;

import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Temperature Display with Gradient Border
          OverviewHeroTemperature(unit: unit),
          const SizedBox(height: 20.0),

          // Temperature Chart
          OverviewTemperatureChart(unit: unit),
          const SizedBox(height: 20.0),

          // Status card
          OverviewStatusCard(unit: unit),
          const SizedBox(height: 20.0),

          // Quick stats
          OverviewQuickStats(unit: unit),
          const SizedBox(height: 20.0),

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
          const SizedBox(height: 20.0),

          // Fan speeds card
          OverviewFanSpeeds(unit: unit),
          const SizedBox(height: 20.0),

          // Maintenance card
          const OverviewMaintenanceCard(),
        ],
      ),
    );
  }
}
