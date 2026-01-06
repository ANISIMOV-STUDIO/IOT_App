/// Mobile Layout - Main control card + tabs for modes/schedule/alarms
///
/// Big Tech pattern: минимальный код, переиспользование виджетов
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../../domain/entities/alarm_info.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../widgets/breez/breez.dart';

/// Mobile layout: UnitControlCard + 3 tabs (Modes, Schedule, Alarms)
class MobileLayout extends StatefulWidget {
  final UnitState unit;
  final VoidCallback? onHeatingTempIncrease;
  final VoidCallback? onHeatingTempDecrease;
  final VoidCallback? onCoolingTempIncrease;
  final VoidCallback? onCoolingTempDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final ValueChanged<String>? onModeChanged;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  final bool isPowerLoading;
  final List<ScheduleEntry> schedule;
  final Map<String, AlarmInfo> activeAlarms;
  final VoidCallback? onScheduleSeeAll;
  final VoidCallback? onAlarmsSeeHistory;

  const MobileLayout({
    super.key,
    required this.unit,
    this.onHeatingTempIncrease,
    this.onHeatingTempDecrease,
    this.onCoolingTempIncrease,
    this.onCoolingTempDecrease,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onModeChanged,
    this.onPowerToggle,
    this.onSettingsTap,
    this.isPowerLoading = false,
    this.schedule = const [],
    this.activeAlarms = const {},
    this.onScheduleSeeAll,
    this.onAlarmsSeeHistory,
  });

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final alarmCount = widget.activeAlarms.length;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Column(
        children: [
          // Main control card (единый виджет для всех платформ)
          Expanded(
            flex: 5,
            child: UnitControlCard(
              unit: widget.unit,
              onHeatingTempIncrease: widget.onHeatingTempIncrease,
              onHeatingTempDecrease: widget.onHeatingTempDecrease,
              onCoolingTempIncrease: widget.onCoolingTempIncrease,
              onCoolingTempDecrease: widget.onCoolingTempDecrease,
              onSupplyFanChanged: widget.onSupplyFanChanged,
              onExhaustFanChanged: widget.onExhaustFanChanged,
              onPowerToggle: widget.onPowerToggle,
              onSettingsTap: widget.onSettingsTap,
              isPowerLoading: widget.isPowerLoading,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Tab bar (using reusable MobileTabBar)
          MobileTabBar(
            controller: _tabController,
            tabs: [
              MobileTab(icon: Icons.tune, label: l10n.modes),
              MobileTab(icon: Icons.calendar_today, label: l10n.schedule),
              MobileTab(
                icon: alarmCount == 0 ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                label: l10n.alarms,
                badgeCount: alarmCount,
                iconColor: alarmCount > 0 ? AppColors.accentRed : null,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Tab content
          Expanded(
            flex: 2,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Режимы работы (using reusable ModeGrid)
                ModeGrid(
                  selectedMode: widget.unit.mode,
                  onModeChanged: widget.onModeChanged,
                  isEnabled: widget.unit.power,
                ),
                // Schedule
                ScheduleWidget(
                  entries: widget.schedule,
                  onSeeAll: widget.onScheduleSeeAll,
                  compact: true,
                ),
                // Alarms
                UnitAlarmsWidget(
                  alarms: widget.activeAlarms,
                  onSeeHistory: widget.onAlarmsSeeHistory,
                  compact: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
