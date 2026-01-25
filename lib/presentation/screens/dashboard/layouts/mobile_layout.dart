/// Mobile Layout - Main control card + tabs for modes/schedule/alarms
///
/// Big Tech pattern: минимальный код, переиспользование виджетов
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/alarm_info.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';
import 'package:hvac_control/domain/entities/unit_state.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для MobileLayout
abstract class _MobileLayoutConstants {
  /// Фиксированная высота TabBarView (режимы/расписание/аварии)
  static const double tabContentHeight = 150;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Mobile layout: UnitControlCard + 3 tabs (Modes, Schedule, Alarms)
class MobileLayout extends StatefulWidget {

  const MobileLayout({
    required this.unit,
    super.key,
    this.onModeTap,
    this.onPowerToggle,
    this.onSettingsTap,
    this.isPowerLoading = false,
    this.isScheduleEnabled = false,
    this.isScheduleLoading = false,
    this.onScheduleToggle,
    this.isPendingOperatingMode = false,
    this.timerSettings,
    this.onTimerSettingsChanged,
    this.activeAlarms = const {},
    this.onAlarmsSeeHistory,
    this.onAlarmsReset,
    this.isOnline = true,
    this.onSyncTap,
    this.isSyncing = false,
  });
  final UnitState unit;

  /// Callback при нажатии на режим (открывает модалку настроек)
  final ModeCallback? onModeTap;

  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  final bool isPowerLoading;
  final bool isScheduleEnabled;
  final bool isScheduleLoading;
  final VoidCallback? onScheduleToggle;
  /// Ожидание подтверждения смены режима работы
  final bool isPendingOperatingMode;

  final Map<String, TimerSettings>? timerSettings;
  final DaySettingsCallback? onTimerSettingsChanged;
  final Map<String, AlarmInfo> activeAlarms;
  final VoidCallback? onAlarmsSeeHistory;
  final VoidCallback? onAlarmsReset;
  final bool isOnline;
  /// Callback для принудительного обновления данных
  final VoidCallback? onSyncTap;
  /// Флаг синхронизации (для анимации вращения иконки)
  final bool isSyncing;

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
              onPowerToggle: widget.isOnline ? widget.onPowerToggle : null,
              onSettingsTap: widget.onSettingsTap,
              onSyncTap: widget.onSyncTap,
              isSyncing: widget.isSyncing,
              isPowerLoading: widget.isPowerLoading,
              isScheduleEnabled: widget.isScheduleEnabled,
              isScheduleLoading: widget.isScheduleLoading,
              onScheduleToggle: widget.isOnline ? widget.onScheduleToggle : null,
              isOnline: widget.isOnline,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Tabs + Content в одной карточке
          BreezCard(
            padding: const EdgeInsets.all(AppSpacing.xs),
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

                // Tab content (свайп между вкладками)
                SizedBox(
                  height: _MobileLayoutConstants.tabContentHeight,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Режимы работы
                      ModeGrid(
                        selectedMode: widget.unit.mode,
                        onModeTap: widget.isOnline ? widget.onModeTap : null,
                        showCard: false,
                        isEnabled: widget.isOnline,
                        isPending: widget.isPendingOperatingMode,
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
                        onResetAlarms: widget.isOnline ? widget.onAlarmsReset : null,
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
