/// Home Dashboard Layout Widgets
///
/// Mobile and desktop layout components for the home dashboard
/// Part of home_screen.dart refactoring to respect 300-line limit
library;

import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/automation_rule.dart';
import '../../../domain/entities/mode_preset.dart';
import 'home_room_preview.dart';
import 'home_automation_section.dart';
import 'home_sidebar.dart';
import 'home_notifications_panel.dart';

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
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeRoomPreview(
            currentUnit: currentUnit,
            selectedUnit: selectedUnit,
            onPowerChanged: onPowerChanged,
            onDetailsPressed: onDetailsPressed,
          ),
          SizedBox(height: AppSpacing.lgV),
          buildControlCards(currentUnit, context),
          SizedBox(height: AppSpacing.lgV),
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

/// Desktop layout for home dashboard
class HomeDesktopLayout extends StatelessWidget {
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

  const HomeDesktopLayout({
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
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main content area
        Expanded(
          flex: 7,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeRoomPreview(
                  currentUnit: currentUnit,
                  selectedUnit: selectedUnit,
                  onPowerChanged: onPowerChanged,
                  onDetailsPressed: onDetailsPressed,
                ),
                SizedBox(height: AppSpacing.lgV),
                buildControlCards(currentUnit, context),
                SizedBox(height: AppSpacing.lgV),
                HomeAutomationSection(
                  currentUnit: currentUnit,
                  onRuleToggled: onRuleToggled,
                  onManageRules: onManageRules,
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: AppSpacing.lgR),

        // Sidebar
        HomeSidebar(
          currentUnit: currentUnit,
          onPresetSelected: onPresetSelected,
          onPowerAllOn: onPowerAllOn,
          onPowerAllOff: onPowerAllOff,
          onSyncSettings: onSyncSettings,
          onApplyScheduleToAll: onApplyScheduleToAll,
          notificationsPanel: currentUnit != null
              ? HomeNotificationsPanel(unit: currentUnit!)
              : const SizedBox.shrink(),
        ),
      ],
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
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lgR,
        vertical: AppSpacing.lgV,
      ),
      child: ResponsiveUtils.isMobile(context)
          ? HomeMobileLayout(
              currentUnit: currentUnit,
              units: units,
              selectedUnit: selectedUnit,
              onPowerChanged: onPowerChanged,
              onDetailsPressed: onDetailsPressed,
              buildControlCards: buildControlCards,
              onRuleToggled: onRuleToggled,
              onManageRules: onManageRules,
            )
          : HomeDesktopLayout(
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
            ),
    );
  }
}