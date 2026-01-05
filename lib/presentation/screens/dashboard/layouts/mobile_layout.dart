/// Mobile Layout - Big Tech pattern with internal tabs
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../../domain/entities/alarm_info.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../widgets/breez/breez.dart';

/// Mobile layout with UnitControlCard + internal tabs (Big Tech pattern)
class MobileLayout extends StatefulWidget {
  final UnitState unit;
  final ValueChanged<int>? onTemperatureIncrease;
  final ValueChanged<int>? onTemperatureDecrease;
  final VoidCallback? onHeatingTempIncrease;
  final VoidCallback? onHeatingTempDecrease;
  final VoidCallback? onCoolingTempIncrease;
  final VoidCallback? onCoolingTempDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final ValueChanged<String>? onModeChanged;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  final bool compact;
  final bool isPowerLoading;

  // Data for tabs
  final List<ScheduleEntry> schedule;
  final Map<String, AlarmInfo> activeAlarms;
  final VoidCallback? onScheduleSeeAll;
  final VoidCallback? onAlarmsSeeHistory;

  const MobileLayout({
    super.key,
    required this.unit,
    this.onTemperatureIncrease,
    this.onTemperatureDecrease,
    this.onHeatingTempIncrease,
    this.onHeatingTempDecrease,
    this.onCoolingTempIncrease,
    this.onCoolingTempDecrease,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onModeChanged,
    this.onPowerToggle,
    this.onSettingsTap,
    this.compact = true,
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
  String? _activePresetId;

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
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Column(
        children: [
          // Main control card (takes most space)
          Expanded(
            flex: 5,
            child: UnitControlCard(
              unit: widget.unit,
              onTemperatureIncrease: widget.onTemperatureIncrease != null
                  ? () => widget.onTemperatureIncrease!(widget.unit.temp + 1)
                  : null,
              onTemperatureDecrease: widget.onTemperatureDecrease != null
                  ? () => widget.onTemperatureDecrease!(widget.unit.temp - 1)
                  : null,
              onHeatingTempIncrease: widget.onHeatingTempIncrease,
              onHeatingTempDecrease: widget.onHeatingTempDecrease,
              onCoolingTempIncrease: widget.onCoolingTempIncrease,
              onCoolingTempDecrease: widget.onCoolingTempDecrease,
              onSupplyFanChanged: widget.onSupplyFanChanged,
              onExhaustFanChanged: widget.onExhaustFanChanged,
              onModeChanged: widget.onModeChanged,
              onPowerToggle: widget.onPowerToggle,
              onSettingsTap: widget.onSettingsTap,
              isPowerLoading: widget.isPowerLoading,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Tab bar
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppRadius.cardSmall),
              border: Border.all(color: colors.border),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.cardSmall - 2),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(4),
              dividerColor: Colors.transparent,
              labelColor: AppColors.accent,
              unselectedLabelColor: colors.textMuted,
              labelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.tune, size: 14),
                      const SizedBox(width: 4),
                      Text(l10n.presets.toUpperCase()),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, size: 14),
                      const SizedBox(width: 4),
                      Text(l10n.schedule.toUpperCase()),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.activeAlarms.isEmpty
                            ? Icons.check_circle_outline
                            : Icons.warning_amber_rounded,
                        size: 14,
                        color: widget.activeAlarms.isEmpty
                            ? null
                            : AppColors.accentRed,
                      ),
                      const SizedBox(width: 4),
                      Text(l10n.alarms.toUpperCase()),
                      if (widget.activeAlarms.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${widget.activeAlarms.length}',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Tab content (fixed height area)
          Expanded(
            flex: 2,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Presets tab
                PresetsWidget(
                  presets: DefaultPresets.getAll(l10n),
                  activePresetId: _activePresetId,
                  onPresetSelected: (id) => setState(() => _activePresetId = id),
                ),

                // Schedule tab
                _MobileScheduleWidget(
                  entries: widget.schedule,
                  onSeeAll: widget.onScheduleSeeAll,
                ),

                // Alarms tab
                _MobileAlarmsWidget(
                  alarms: widget.activeAlarms,
                  onSeeHistory: widget.onAlarmsSeeHistory,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact schedule widget for mobile tab
class _MobileScheduleWidget extends StatelessWidget {
  final List<ScheduleEntry> entries;
  final VoidCallback? onSeeAll;

  const _MobileScheduleWidget({
    required this.entries,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: entries.isEmpty
          ? _buildEmptyState(colors, l10n)
          : Column(
              children: [
                // Schedule rows
                Expanded(
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: entries.take(2).length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return _ScheduleRowCompact(entry: entry);
                    },
                  ),
                ),

                // See all button
                if (entries.length > 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: BreezSeeMoreButton(
                      label: l10n.allCount(entries.length - 2),
                      onTap: onSeeAll,
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BreezColors colors, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 28,
            color: AppColors.accent.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noSchedule,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact schedule row
class _ScheduleRowCompact extends StatelessWidget {
  final ScheduleEntry entry;

  const _ScheduleRowCompact({required this.entry});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: entry.isActive
            ? AppColors.accent.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        border: entry.isActive
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              entry.day,
              style: TextStyle(
                fontSize: 11,
                fontWeight: entry.isActive ? FontWeight.w600 : FontWeight.w500,
                color: entry.isActive ? AppColors.accent : colors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              entry.mode,
              style: TextStyle(
                fontSize: 11,
                color: colors.textMuted,
              ),
            ),
          ),
          Text(
            '${entry.tempDay}° / ${entry.tempNight}°',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: entry.isActive ? AppColors.accent : colors.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact alarms widget for mobile tab
class _MobileAlarmsWidget extends StatelessWidget {
  final Map<String, AlarmInfo> alarms;
  final VoidCallback? onSeeHistory;

  const _MobileAlarmsWidget({
    required this.alarms,
    this.onSeeHistory,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final alarmsList = alarms.entries.toList();

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: alarmsList.isEmpty
          ? _buildNoAlarms(colors, l10n)
          : Column(
              children: [
                // Alarms list
                Expanded(
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: alarmsList.take(2).length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final alarm = alarmsList[index];
                      return _AlarmRowCompact(
                        code: alarm.value.code.toString(),
                        description: alarm.value.description,
                      );
                    },
                  ),
                ),

                // See history button
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: BreezSeeMoreButton(
                    label: alarmsList.isEmpty
                        ? l10n.alarmHistory
                        : l10n.allAlarms,
                    extraCount:
                        alarmsList.length > 2 ? alarmsList.length - 2 : null,
                    onTap: onSeeHistory,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNoAlarms(BreezColors colors, AppLocalizations l10n) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 28,
                  color: AppColors.accentGreen,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.noAlarms,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        BreezSeeMoreButton(
          label: l10n.alarmHistory,
          onTap: onSeeHistory,
        ),
      ],
    );
  }
}

/// Compact alarm row
class _AlarmRowCompact extends StatelessWidget {
  final String code;
  final String description;

  const _AlarmRowCompact({
    required this.code,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        border: Border.all(
          color: AppColors.accentRed.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 14,
            color: AppColors.accentRed,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accentRed.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.accentRed,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: colors.text,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
