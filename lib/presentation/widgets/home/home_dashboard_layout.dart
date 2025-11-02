/// Home Dashboard Layout Widgets
///
/// Mobile, tablet and desktop layout components for the home dashboard
/// Part of home_screen.dart refactoring to respect 300-line limit
library;

import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/ui_constants.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/automation_rule.dart';
import '../../../domain/entities/mode_preset.dart';
import 'home_room_preview.dart';
import 'home_automation_section.dart';
import 'home_sidebar.dart';
import 'home_notifications_panel.dart';
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
/// IMPORTANT: No scroll on desktop - content fits viewport (best practice)
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
    // Desktop layout: NO SCROLL - content fits within viewport
    // Following Material Design 3 and modern desktop UI best practices
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeDesktop = constraints.maxWidth >= UIConstants.breakpointLargeDesktop;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main content area - NO SCROLLING
            Expanded(
              flex: isLargeDesktop ? 8 : 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Room preview - fixed size, no scroll
                  HomeRoomPreview(
                    currentUnit: currentUnit,
                    selectedUnit: selectedUnit,
                    onPowerChanged: onPowerChanged,
                    onDetailsPressed: onDetailsPressed,
                  ),

                  SizedBox(height: AppSpacing.lgV),

                  // Control cards - fills remaining space
                  Expanded(
                    child: buildControlCards(currentUnit, context),
                  ),

                  SizedBox(height: AppSpacing.lgV),

                  // Automation section - compact on desktop
                  HomeAutomationSection(
                    currentUnit: currentUnit,
                    onRuleToggled: onRuleToggled,
                    onManageRules: onManageRules,
                  ),
                ],
              ),
            ),

            SizedBox(width: AppSpacing.lgR),

            // Sidebar - fixed width, scrollable if needed
            SizedBox(
              width: isLargeDesktop ? 380 : 320,
              child: HomeSidebar(
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
            ),
          ],
        );
      },
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
    // Adaptive padding based on device type
    final EdgeInsets padding;
    if (ResponsiveUtils.isMobile(context)) {
      padding = EdgeInsets.symmetric(
        horizontal: AppSpacing.mdR,
        vertical: AppSpacing.mdV,
      );
    } else if (ResponsiveUtils.isTablet(context)) {
      padding = EdgeInsets.symmetric(
        horizontal: AppSpacing.lgR,
        vertical: AppSpacing.lgV,
      );
    } else {
      padding = EdgeInsets.symmetric(
        horizontal: AppSpacing.xlR,
        vertical: AppSpacing.xlV,
      );
    }

    return Padding(
      padding: padding,
      child: _buildLayout(context),
    );
  }

  Widget _buildLayout(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
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
    } else if (ResponsiveUtils.isTablet(context)) {
      // TABLET LAYOUT - NEW!
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
      );
    } else {
      return HomeDesktopLayout(
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
      );
    }
  }
}