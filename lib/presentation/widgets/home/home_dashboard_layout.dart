/// Home Dashboard Layout Widgets
///
/// Mobile and tablet layout components for the home dashboard
/// Part of home_screen.dart refactoring to respect 300-line limit
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/automation_rule.dart';
import '../../../domain/entities/mode_preset.dart';
import 'home_room_preview.dart';
import 'home_automation_section.dart';
import 'home_tablet_layout.dart';

/// Mobile layout for home dashboard
class HomeMobileLayout extends StatelessWidget {
  final HvacUnit? currentUnit;
  final List<HvacUnit> units;
  final String? selectedUnit;
  final Function(bool) onPowerChanged;
  final VoidCallback? onDetailsPressed;
  final Function(HvacUnit?, BuildContext) buildControlCards;
  final Function(AutomationRule) onRuleToggled;
  final VoidCallback onManageRules;

  const HomeMobileLayout({
    super.key,
    required this.currentUnit,
    required this.units,
    required this.selectedUnit,
    required this.onPowerChanged,
    required this.onDetailsPressed,
    required this.buildControlCards,
    required this.onRuleToggled,
    required this.onManageRules,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: PerformanceUtils.getOptimalScrollPhysics(
        bouncing: true,
        alwaysScrollable: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeRoomPreview(
            currentUnit: currentUnit,
            selectedUnit: selectedUnit,
            onPowerChanged: onPowerChanged,
            onDetailsPressed: onDetailsPressed,
          ),
          const SizedBox(height: HvacSpacing.lgV),
          buildControlCards(currentUnit, context),
          const SizedBox(height: HvacSpacing.lgV),
          HomeAutomationSection(
            currentUnit: currentUnit,
            onRuleToggled: onRuleToggled,
            onManageRules: onManageRules,
          ),
        ],
      ),
    );
  }
}

/// Dashboard wrapper that handles responsive layout selection
class HomeDashboard extends StatelessWidget {
  final HvacUnit? currentUnit;
  final List<HvacUnit> units;
  final String? selectedUnit;
  final Function(bool) onPowerChanged;
  final VoidCallback? onDetailsPressed;
  final Function(HvacUnit?, BuildContext) buildControlCards;
  final Function(AutomationRule) onRuleToggled;
  final VoidCallback onManageRules;
  final Function(ModePreset) onPresetSelected;
  final VoidCallback onPowerAllOn;
  final VoidCallback onPowerAllOff;
  final VoidCallback onSyncSettings;
  final VoidCallback onApplyScheduleToAll;
  final VoidCallback? onSchedulePressed;

  const HomeDashboard({
    super.key,
    required this.currentUnit,
    required this.units,
    required this.selectedUnit,
    required this.onPowerChanged,
    required this.onDetailsPressed,
    required this.buildControlCards,
    required this.onRuleToggled,
    required this.onManageRules,
    required this.onPresetSelected,
    required this.onPowerAllOn,
    required this.onPowerAllOff,
    required this.onSyncSettings,
    required this.onApplyScheduleToAll,
    this.onSchedulePressed,
  });

  @override
  Widget build(BuildContext context) {
    // Adaptive padding based on device type
    final width = MediaQuery.of(context).size.width;
    final EdgeInsets padding;
    if (width < 600) {
      padding = const EdgeInsets.symmetric(
        horizontal: HvacSpacing.mdR,
        vertical: HvacSpacing.mdV,
      );
    } else if (width >= 1024) {
      // Desktop: very compact padding
      padding = const EdgeInsets.symmetric(
        horizontal: HvacSpacing.lgR,
        vertical: HvacSpacing.mdV,
      );
    } else {
      padding = const EdgeInsets.symmetric(
        horizontal: HvacSpacing.lgR,
        vertical: HvacSpacing.lgV,
      );
    }

    // Desktop: fixed width container centered
    if (width >= 1024) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1800),
          child: Padding(
            padding: padding,
            child: _buildLayout(context),
          ),
        ),
      );
    }

    // Mobile/Tablet: full width with padding
    return Padding(
      padding: padding,
      child: _buildLayout(context),
    );
  }

  Widget _buildLayout(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return HomeMobileLayout(
        currentUnit: currentUnit,
        units: units,
        selectedUnit: selectedUnit,
        onPowerChanged: onPowerChanged,
        onDetailsPressed: onDetailsPressed,
        buildControlCards: buildControlCards,
        onRuleToggled: onRuleToggled,
        onManageRules: onManageRules,
      );
    } else {
      // TABLET/DESKTOP LAYOUT
      return HomeTabletLayout(
        currentUnit: currentUnit,
        units: units,
        selectedUnit: selectedUnit,
        onPowerChanged: onPowerChanged,
        onDetailsPressed: onDetailsPressed,
        buildControlCards: buildControlCards,
        onRuleToggled: onRuleToggled,
        onManageRules: onManageRules,
        onPresetSelected: onPresetSelected,
        onPowerAllOn: onPowerAllOn,
        onPowerAllOff: onPowerAllOff,
        onSyncSettings: onSyncSettings,
        onApplyScheduleToAll: onApplyScheduleToAll,
        onSchedulePressed: onSchedulePressed,
      );
    }
  }
}