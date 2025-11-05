/// Home Sidebar Widget
///
/// Right sidebar with presets, group controls, and notifications
/// FIXED: Uses responsive width (320.0) instead of hard-coded 320
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/mode_preset.dart';
import '../../bloc/hvac_list/hvac_list_bloc.dart';
import '../../bloc/hvac_list/hvac_list_state.dart';
import '../quick_presets_panel.dart';
import '../group_control_panel.dart';

class HomeSidebar extends StatelessWidget {
  final HvacUnit? currentUnit;
  final ValueChanged<ModePreset> onPresetSelected;
  final VoidCallback onPowerAllOn;
  final VoidCallback onPowerAllOff;
  final VoidCallback onSyncSettings;
  final VoidCallback onApplyScheduleToAll;
  final Widget notificationsPanel;

  const HomeSidebar({
    super.key,
    this.currentUnit,
    required this.onPresetSelected,
    required this.onPowerAllOn,
    required this.onPowerAllOff,
    required this.onSyncSettings,
    required this.onApplyScheduleToAll,
    required this.notificationsPanel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // CRITICAL FIX: Use responsive width instead of hard-coded 320
      width: ResponsiveUtils.isMobile(context) ? double.infinity : 320.0,
      child: BlocBuilder<HvacListBloc, HvacListState>(
        builder: (context, state) {
          if (state is HvacListLoaded && currentUnit != null) {
            return Column(
              children: [
                // Quick presets panel
                QuickPresetsPanel(
                  onPresetSelected: onPresetSelected,
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 100.ms)
                    .slideX(begin: 0.2, end: 0),

                const SizedBox(height: 20.0),

                // Group control panel
                if (state.units.length > 1)
                  GroupControlPanel(
                    units: state.units,
                    onPowerAllOn: onPowerAllOn,
                    onPowerAllOff: onPowerAllOff,
                    onSyncSettings: onSyncSettings,
                    onApplyScheduleToAll: onApplyScheduleToAll,
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 200.ms)
                      .slideX(begin: 0.2, end: 0),

                if (state.units.length > 1) const SizedBox(height: 20.0),

                // Notifications panel
                Expanded(
                  child: notificationsPanel
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 300.ms)
                      .slideX(begin: 0.2, end: 0),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
