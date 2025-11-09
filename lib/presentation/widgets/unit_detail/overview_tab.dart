/// Overview Tab Widget
///
/// Main orchestrator for unit detail screen overview tab
/// Composes all overview components into a scrollable layout
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../bloc/hvac_list/hvac_list_bloc.dart';
import '../../bloc/hvac_list/hvac_list_event.dart';
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
              context.read<HvacListBloc>().add(
                    UpdateDevicePowerEvent(
                      deviceId: unit.id,
                      power: !unit.power,
                    ),
                  );
            },
            onModeTap: () {
              _showModeSelector(context);
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

  /// Show mode selector dialog
  void _showModeSelector(BuildContext context) {
    final modes = ['Heat', 'Cool', 'Auto', 'Fan', 'Dry'];
    final currentMode = unit.mode;

    showDialog(
      context: context,
      builder: (dialogContext) => HvacAlertDialog(
        title: 'Select Mode',
        contentWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: modes.map((mode) {
            final isSelected = mode == currentMode;
            return HvacListTile(
              title: Text(mode),
              leading: Icon(
                _getModeIcon(mode),
                color: isSelected ? HvacColors.primaryOrange : null,
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: HvacColors.primaryOrange)
                  : null,
              onTap: () {
                context.read<HvacListBloc>().add(
                      UpdateDeviceModeEvent(
                        deviceId: unit.id,
                        mode: mode,
                      ),
                    );
                Navigator.of(dialogContext).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Get icon for mode
  IconData _getModeIcon(String mode) {
    switch (mode) {
      case 'Heat':
        return Icons.local_fire_department;
      case 'Cool':
        return Icons.ac_unit;
      case 'Auto':
        return Icons.autorenew;
      case 'Fan':
        return Icons.air;
      case 'Dry':
        return Icons.water_drop;
      default:
        return Icons.settings;
    }
  }
}
