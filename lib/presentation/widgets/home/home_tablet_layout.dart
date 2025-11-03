/// Home Tablet Layout Widget - Compact Version
///
/// Optimized layout for tablet devices (600-1200px width)
/// Uses 2-column grid with extracted components
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/automation_rule.dart';
import '../../../domain/entities/mode_preset.dart';
import 'home_room_preview.dart';
import 'home_automation_section.dart';
import 'home_notifications_panel.dart';
import 'tablet_quick_actions.dart';
import 'tablet_presets_panel.dart';

/// Tablet layout for home dashboard - 2 column optimized
class HomeTabletLayout extends StatelessWidget {
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

  const HomeTabletLayout({
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isSmallTablet = screenWidth < 900;

    if (isDesktop) {
      return _buildDesktopLayout(context);
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildRoomPreviewSection(),
          const SizedBox(height: HvacSpacing.xlV),
          _buildTwoColumnLayout(context, isSmallTablet),
          const SizedBox(height: HvacSpacing.xlV),
          HomeAutomationSection(
            currentUnit: currentUnit,
            onRuleToggled: onRuleToggled,
            onManageRules: onManageRules,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top row: Room Preview spans 2 columns, Right column for Quick Actions + Presets
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room Preview - 2 columns wide
              Expanded(
                flex: 5,
                child: _buildRoomPreviewSection(),
              ),
              const SizedBox(width: HvacSpacing.lgR),
              // Right column: Quick Actions + Presets
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    TabletQuickActions(
                      onPowerAllOn: onPowerAllOn,
                      onPowerAllOff: onPowerAllOff,
                      onSyncSettings: onSyncSettings,
                      onApplyScheduleToAll: onApplyScheduleToAll,
                    ),
                    const SizedBox(height: HvacSpacing.lgV),
                    TabletPresetsPanel(
                      onPresetSelected: onPresetSelected,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.lgV),
          // Bottom row: 3 columns - Control Cards, Automation, Notifications
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Control Cards
              Expanded(
                flex: 3,
                child: buildControlCards(currentUnit, context),
              ),
              const SizedBox(width: HvacSpacing.lgR),
              // Middle: Automation
              Expanded(
                flex: 2,
                child: HomeAutomationSection(
                  currentUnit: currentUnit,
                  onRuleToggled: onRuleToggled,
                  onManageRules: onManageRules,
                ),
              ),
              const SizedBox(width: HvacSpacing.lgR),
              // Right: Notifications
              Expanded(
                flex: 2,
                child: currentUnit != null
                    ? HomeNotificationsPanel(unit: currentUnit!)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomPreviewSection() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 320.h,
      ),
      child: HomeRoomPreview(
        currentUnit: currentUnit,
        selectedUnit: selectedUnit,
        onPowerChanged: onPowerChanged,
        onDetailsPressed: onDetailsPressed,
      ),
    );
  }

  Widget _buildTwoColumnLayout(BuildContext context, bool isSmallTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: isSmallTablet ? 1 : 3,
          child: _buildLeftColumn(context, isSmallTablet),
        ),
        const SizedBox(width: HvacSpacing.xlR),
        Expanded(
          flex: isSmallTablet ? 1 : 2,
          child: _buildRightColumn(isSmallTablet),
        ),
      ],
    );
  }

  Widget _buildLeftColumn(BuildContext context, bool isSmallTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildControlCards(currentUnit, context),
        if (isSmallTablet) ...[
          const SizedBox(height: HvacSpacing.lgV),
          TabletQuickActions(
            onPowerAllOn: onPowerAllOn,
            onPowerAllOff: onPowerAllOff,
            onSyncSettings: onSyncSettings,
            onApplyScheduleToAll: onApplyScheduleToAll,
          ),
        ],
      ],
    );
  }

  Widget _buildRightColumn(bool isSmallTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isSmallTablet) ...[
          TabletQuickActions(
            onPowerAllOn: onPowerAllOn,
            onPowerAllOff: onPowerAllOff,
            onSyncSettings: onSyncSettings,
            onApplyScheduleToAll: onApplyScheduleToAll,
          ),
          const SizedBox(height: HvacSpacing.lgV),
        ],
        TabletPresetsPanel(
          onPresetSelected: onPresetSelected,
        ),
        const SizedBox(height: HvacSpacing.lgV),
        if (currentUnit != null)
          HomeNotificationsPanel(unit: currentUnit!),
      ],
    );
  }
}