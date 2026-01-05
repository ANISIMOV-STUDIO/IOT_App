/// Mobile Layout - Restructured with 4 tabs
///
/// Compact main card + tabs for Controls, Sensors, Schedule, Alarms
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../../domain/entities/alarm_info.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../widgets/breez/breez.dart';

/// Mobile layout with compact header + 4 tabs
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        children: [
          // Compact header card
          _CompactHeaderCard(
            unit: widget.unit,
            onPowerToggle: widget.onPowerToggle,
            onSettingsTap: widget.onSettingsTap,
            isPowerLoading: widget.isPowerLoading,
            alarmCount: widget.activeAlarms.length,
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
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.tune, size: 14),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          l10n.controls.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sensors, size: 14),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          l10n.sensors.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, size: 14),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          l10n.schedule.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
                      if (widget.activeAlarms.isNotEmpty) ...[
                        const SizedBox(width: 3),
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

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Controls tab
                _ControlsTab(
                  unit: widget.unit,
                  onHeatingTempIncrease: widget.onHeatingTempIncrease,
                  onHeatingTempDecrease: widget.onHeatingTempDecrease,
                  onCoolingTempIncrease: widget.onCoolingTempIncrease,
                  onCoolingTempDecrease: widget.onCoolingTempDecrease,
                  onSupplyFanChanged: widget.onSupplyFanChanged,
                  onExhaustFanChanged: widget.onExhaustFanChanged,
                  onModeChanged: widget.onModeChanged,
                ),

                // Sensors tab
                _SensorsTab(unit: widget.unit),

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

          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

/// Compact header card - unit name, status, main temps, power
class _CompactHeaderCard extends StatelessWidget {
  final UnitState unit;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onSettingsTap;
  final bool isPowerLoading;
  final int alarmCount;

  const _CompactHeaderCard({
    required this.unit,
    this.onPowerToggle,
    this.onSettingsTap,
    this.isPowerLoading = false,
    this.alarmCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final poweredGradient = isDark
        ? AppColors.darkCardGradientColors
        : AppColors.lightCardGradientColors;
    final offGradient = [colors.card, colors.card];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: unit.power ? poweredGradient : offGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: unit.power
              ? AppColors.accent.withValues(alpha: 0.3)
              : colors.border,
        ),
        boxShadow: unit.power
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Top row: Unit name + controls
          Row(
            children: [
              // Unit name
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        unit.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.text,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: colors.textMuted,
                    ),
                  ],
                ),
              ),

              // Alarm badge
              if (alarmCount > 0)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    border: Border.all(
                      color: AppColors.accentRed.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 10,
                        color: AppColors.accentRed,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '$alarmCount',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentRed,
                        ),
                      ),
                    ],
                  ),
                ),

              // Settings button
              BreezIconButton(
                icon: Icons.settings_outlined,
                size: 28,
                onTap: onSettingsTap,
              ),
              const SizedBox(width: 6),

              // Power button
              isPowerLoading
                  ? const SizedBox(
                      width: 28,
                      height: 28,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.accent,
                        ),
                      ),
                    )
                  : BreezIconButton(
                      icon: Icons.power_settings_new,
                      size: 28,
                      iconColor: unit.power
                          ? AppColors.accentRed
                          : AppColors.accentGreen,
                      onTap: onPowerToggle,
                    ),
            ],
          ),

          const SizedBox(height: 12),

          // Main temperature display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Indoor temp (big)
              _TempDisplay(
                label: l10n.indoorTemp,
                value: unit.indoorTemp,
                icon: Icons.home_outlined,
                isPrimary: true,
              ),

              // Divider
              Container(
                width: 1,
                height: 50,
                color: colors.border,
              ),

              // Outdoor temp
              _TempDisplay(
                label: l10n.outdoorTemp,
                value: unit.outsideTemp,
                icon: Icons.thermostat_outlined,
                isPrimary: false,
              ),

              // Divider
              Container(
                width: 1,
                height: 50,
                color: colors.border,
              ),

              // Status
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: unit.power
                          ? AppColors.accentGreen.withValues(alpha: 0.15)
                          : AppColors.accentRed.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.button),
                      border: Border.all(
                        color: unit.power
                            ? AppColors.accentGreen.withValues(alpha: 0.3)
                            : AppColors.accentRed.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: unit.power
                                ? AppColors.accentGreen
                                : AppColors.accentRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          unit.power ? l10n.statusRunning : l10n.statusStopped,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: unit.power
                                ? AppColors.accentGreen
                                : AppColors.accentRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.status,
                    style: TextStyle(
                      fontSize: 9,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Temperature display widget
class _TempDisplay extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final bool isPrimary;

  const _TempDisplay({
    required this.label,
    required this.value,
    required this.icon,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Column(
      children: [
        Icon(
          icon,
          size: isPrimary ? 20 : 16,
          color: AppColors.accent,
        ),
        const SizedBox(height: 4),
        Text(
          '$value°',
          style: TextStyle(
            fontSize: isPrimary ? 28 : 22,
            fontWeight: FontWeight.w700,
            color: colors.text,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }
}

/// Controls tab - temperature setpoints, mode, fans
class _ControlsTab extends StatelessWidget {
  final UnitState unit;
  final VoidCallback? onHeatingTempIncrease;
  final VoidCallback? onHeatingTempDecrease;
  final VoidCallback? onCoolingTempIncrease;
  final VoidCallback? onCoolingTempDecrease;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;
  final ValueChanged<String>? onModeChanged;

  const _ControlsTab({
    required this.unit,
    this.onHeatingTempIncrease,
    this.onHeatingTempDecrease,
    this.onCoolingTempIncrease,
    this.onCoolingTempDecrease,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
    this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Temperature setpoints
            Text(
              l10n.temperatureSetpoints.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Heating temp
                Expanded(
                  child: TemperatureColumn(
                    label: l10n.heating,
                    temperature: unit.heatingTemp,
                    icon: Icons.whatshot,
                    color: AppColors.accentOrange,
                    isPowered: unit.power,
                    onIncrease: onHeatingTempIncrease,
                    onDecrease: onHeatingTempDecrease,
                    compact: true,
                  ),
                ),
                Container(
                  width: 1,
                  height: 70,
                  color: colors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                // Cooling temp
                Expanded(
                  child: TemperatureColumn(
                    label: l10n.cooling,
                    temperature: unit.coolingTemp,
                    icon: Icons.ac_unit,
                    color: AppColors.accent,
                    isPowered: unit.power,
                    onIncrease: onCoolingTempIncrease,
                    onDecrease: onCoolingTempDecrease,
                    compact: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Fan controls
            if (unit.power) ...[
              Text(
                l10n.fanSpeed.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FanSlider(
                      label: l10n.intake,
                      value: unit.supplyFan,
                      color: AppColors.accent,
                      icon: Icons.arrow_downward_rounded,
                      onChanged: onSupplyFanChanged,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FanSlider(
                      label: l10n.exhaust,
                      value: unit.exhaustFan,
                      color: AppColors.accentOrange,
                      icon: Icons.arrow_upward_rounded,
                      onChanged: onExhaustFanChanged,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],

            // Mode selector
            Text(
              l10n.operatingMode.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            ModeSelector(
              unitName: unit.name,
              selectedMode: unit.mode,
              onModeChanged: onModeChanged,
              compact: true,
              enabled: unit.power,
            ),
          ],
        ),
      ),
    );
  }
}

/// Sensors tab - full sensors grid
class _SensorsTab extends StatelessWidget {
  final UnitState unit;

  const _SensorsTab({required this.unit});

  @override
  Widget build(BuildContext context) {
    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SingleChildScrollView(
        child: SensorsGrid(unit: unit),
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
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return _ScheduleRowCompact(entry: entry);
                    },
                  ),
                ),

                // See all button
                if (onSeeAll != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: BreezSeeMoreButton(
                      label: l10n.seeAll,
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
            size: 32,
            color: AppColors.accent.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noSchedule,
            style: TextStyle(
              fontSize: 13,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
            width: 70,
            child: Text(
              entry.day,
              style: TextStyle(
                fontSize: 12,
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
              fontSize: 12,
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
                    itemCount: alarmsList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
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
                  padding: const EdgeInsets.only(top: 8),
                  child: BreezSeeMoreButton(
                    label: l10n.alarmHistory,
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
                  size: 40,
                  color: AppColors.accentGreen,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.noAlarms,
                  style: TextStyle(
                    fontSize: 14,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            size: 16,
            color: AppColors.accentRed,
          ),
          const SizedBox(width: 10),
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
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: colors.text,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
