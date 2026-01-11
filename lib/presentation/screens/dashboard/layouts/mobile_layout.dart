/// Mobile Layout - Main control card + tabs for modes/schedule/alarms
///
/// Big Tech pattern: минимальный код, переиспользование виджетов
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../../domain/entities/alarm_info.dart';
import '../../../../domain/entities/mode_settings.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../widgets/breez/breez.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для MobileLayout
abstract class _MobileLayoutConstants {
  /// Фиксированная высота TabBarView (режимы/расписание/аварии)
  static const double tabContentHeight = 150.0;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

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
  final bool isScheduleEnabled;
  final bool isScheduleLoading;
  final VoidCallback? onScheduleToggle;
  /// Ожидание подтверждения изменения температуры
  final bool isPendingTemperature;

  final Map<String, TimerSettings>? timerSettings;
  final DaySettingsCallback? onTimerSettingsChanged;
  final Map<String, AlarmInfo> activeAlarms;
  final VoidCallback? onAlarmsSeeHistory;
  final bool isOnline;

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
    this.isScheduleEnabled = false,
    this.isScheduleLoading = false,
    this.onScheduleToggle,
    this.isPendingTemperature = false,
    this.timerSettings,
    this.onTimerSettingsChanged,
    this.activeAlarms = const {},
    this.onAlarmsSeeHistory,
    this.isOnline = true,
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
    // Если offline — не показываем количество аварий
    final alarmCount = widget.isOnline ? widget.activeAlarms.length : 0;

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
            child: UnitControlCard(
              unit: widget.unit,
              onHeatingTempIncrease: widget.isOnline ? widget.onHeatingTempIncrease : null,
              onHeatingTempDecrease: widget.isOnline ? widget.onHeatingTempDecrease : null,
              onCoolingTempIncrease: widget.isOnline ? widget.onCoolingTempIncrease : null,
              onCoolingTempDecrease: widget.isOnline ? widget.onCoolingTempDecrease : null,
              onSupplyFanChanged: widget.isOnline ? widget.onSupplyFanChanged : null,
              onExhaustFanChanged: widget.isOnline ? widget.onExhaustFanChanged : null,
              onPowerToggle: widget.isOnline ? widget.onPowerToggle : null,
              onSettingsTap: widget.onSettingsTap,
              isPowerLoading: widget.isPowerLoading,
              isScheduleEnabled: widget.isScheduleEnabled,
              isScheduleLoading: widget.isScheduleLoading,
              onScheduleToggle: widget.isOnline ? widget.onScheduleToggle : null,
              isOnline: widget.isOnline,
              isPendingTemperature: widget.isPendingTemperature,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Tabs + Content в одной карточке
          BreezCard(
            padding: EdgeInsets.all(AppSpacing.xs),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tab bar (сегментированный контрол)
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

                const SizedBox(height: AppSpacing.xs),

                // Tab content
                SizedBox(
                  height: _MobileLayoutConstants.tabContentHeight,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Режимы работы
                      ModeGrid(
                        selectedMode: widget.unit.mode,
                        onModeChanged: widget.isOnline ? widget.onModeChanged : null,
                        showCard: false,
                        isEnabled: widget.isOnline,
                      ),
                      // Schedule
                      DailyScheduleWidget(
                        timerSettings: widget.timerSettings,
                        onDaySettingsChanged: widget.isOnline ? widget.onTimerSettingsChanged : null,
                        compact: true,
                        showCard: false,
                        isEnabled: widget.isOnline,
                      ),
                      // Alarms
                      UnitAlarmsWidget(
                        alarms: widget.isOnline ? widget.activeAlarms : const {},
                        onSeeHistory: widget.onAlarmsSeeHistory,
                        compact: true,
                        showCard: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
