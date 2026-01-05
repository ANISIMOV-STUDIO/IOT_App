/// Mobile Layout - Main control card + tabs for sensors/schedule/alarms
///
/// Big Tech pattern: минимальный код, переиспользование виджетов
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../../domain/entities/alarm_info.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../widgets/breez/breez.dart';

/// Mobile layout: MainTempCard + 3 tabs (Sensors, Schedule, Alarms)
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

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Column(
        children: [
          // Main control card
          Expanded(
            flex: 5,
            child: MainTempCard(
              unitName: widget.unit.name,
              temperature: widget.unit.temp,
              heatingTemp: widget.unit.heatingTemp,
              coolingTemp: widget.unit.coolingTemp,
              status: widget.unit.power ? l10n.statusRunning : l10n.statusStopped,
              humidity: widget.unit.humidity,
              airflow: widget.unit.airflowRate,
              filterPercent: widget.unit.filterPercent,
              isPowered: widget.unit.power,
              supplyFan: widget.unit.supplyFan,
              exhaustFan: widget.unit.exhaustFan,
              onPowerToggle: widget.onPowerToggle,
              onHeatingTempIncrease: widget.onHeatingTempIncrease,
              onHeatingTempDecrease: widget.onHeatingTempDecrease,
              onCoolingTempIncrease: widget.onCoolingTempIncrease,
              onCoolingTempDecrease: widget.onCoolingTempDecrease,
              onSupplyFanChanged: widget.onSupplyFanChanged,
              onExhaustFanChanged: widget.onExhaustFanChanged,
              onSettingsTap: widget.onSettingsTap,
              showControls: true,
              isPowerLoading: widget.isPowerLoading,
              showStats: false,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Tab bar
          _MobileTabBar(
            controller: _tabController,
            alarmCount: widget.activeAlarms.length,
          ),

          const SizedBox(height: AppSpacing.sm),

          // Tab content
          Expanded(
            flex: 2,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Режимы работы
                _ModesGrid(
                  selectedMode: widget.unit.mode,
                  onModeChanged: widget.onModeChanged,
                  isPowered: widget.unit.power,
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

/// Compact tab bar for mobile layout
class _MobileTabBar extends StatelessWidget {
  final TabController controller;
  final int alarmCount;

  const _MobileTabBar({
    required this.controller,
    required this.alarmCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        border: Border.all(color: colors.border),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppRadius.cardSmall - 2),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelColor: AppColors.accent,
        unselectedLabelColor: colors.textMuted,
        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        tabs: [
          _buildTab(Icons.tune, l10n.modes),
          _buildTab(Icons.calendar_today, l10n.schedule),
          _buildAlarmTab(l10n.alarms, alarmCount),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(label.toUpperCase()),
        ],
      ),
    );
  }

  Widget _buildAlarmTab(String label, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            count == 0 ? Icons.check_circle_outline : Icons.warning_amber_rounded,
            size: 14,
            color: count == 0 ? null : AppColors.accentRed,
          ),
          const SizedBox(width: 4),
          Text(label.toUpperCase()),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.accentRed,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$count',
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
    );
  }
}

/// Сетка режимов работы (8 режимов, 4x2)
class _ModesGrid extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String>? onModeChanged;
  final bool isPowered;

  const _ModesGrid({
    required this.selectedMode,
    this.onModeChanged,
    this.isPowered = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final modes = [
      _ModeData('basic', l10n.modeBasic, Icons.air, AppColors.accent),
      _ModeData('intensive', l10n.modeIntensive, Icons.speed, AppColors.accentOrange),
      _ModeData('economy', l10n.modeEconomy, Icons.eco, AppColors.accentGreen),
      _ModeData('max_performance', l10n.modeMaxPerformance, Icons.bolt, AppColors.accentOrange),
      _ModeData('kitchen', l10n.modeKitchen, Icons.restaurant, Colors.brown),
      _ModeData('fireplace', l10n.modeFireplace, Icons.fireplace, Colors.deepOrange),
      _ModeData('vacation', l10n.modeVacation, Icons.flight_takeoff, Colors.teal),
      _ModeData('custom', l10n.modeCustom, Icons.tune, Colors.purple),
    ];

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Вычисляем размеры ячеек на основе доступного пространства
          const columns = 4;
          const rows = 2;
          const spacing = AppSpacing.sm;

          final availableWidth = constraints.maxWidth - spacing * (columns - 1);
          final availableHeight = constraints.maxHeight - spacing * (rows - 1);

          final cellWidth = availableWidth / columns;
          final cellHeight = availableHeight / rows;

          // Aspect ratio = width / height
          final aspectRatio = cellWidth / cellHeight;

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: aspectRatio.clamp(0.8, 2.0),
            ),
            itemCount: modes.length,
            itemBuilder: (context, index) {
              final mode = modes[index];
              final isSelected = selectedMode.toLowerCase() == mode.id.toLowerCase();

              return _ModeButton(
                mode: mode,
                isSelected: isSelected,
                isEnabled: isPowered,
                onTap: isPowered ? () => onModeChanged?.call(mode.id) : null,
              );
            },
          );
        },
      ),
    );
  }
}

class _ModeData {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const _ModeData(this.id, this.name, this.icon, this.color);
}

class _ModeButton extends StatelessWidget {
  final _ModeData mode;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;

  const _ModeButton({
    required this.mode,
    this.isSelected = false,
    this.isEnabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final color = isEnabled ? mode.color : colors.textMuted;

    return BreezButton(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.xs),
      backgroundColor: isSelected
          ? color.withValues(alpha: 0.15)
          : Colors.transparent,
      hoverColor: color.withValues(alpha: 0.1),
      border: Border.all(
        color: isSelected ? color.withValues(alpha: 0.4) : colors.border,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Icon(
              mode.icon,
              size: 20,
              color: isSelected ? color : colors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            mode.name.toUpperCase(),
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: isSelected ? color : colors.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
