/// Unified Schedule Card - shows device-specific and global schedules
library;


import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/device_schedule.dart';
import '../common/glowing_status_dot.dart';

/// Schedule card that separates device-specific and global automation rules
class UnifiedScheduleCard extends StatelessWidget {
  final List<DeviceSchedule> schedules;
  final String? currentDeviceId;
  final String? currentDeviceName;
  final String title;
  final VoidCallback? onAddSchedule;
  final ValueChanged<String>? onEditSchedule;
  final ValueChanged<DeviceSchedule>? onToggleSchedule;

  const UnifiedScheduleCard({
    super.key,
    required this.schedules,
    this.currentDeviceId,
    this.currentDeviceName,
    this.title = 'Расписание',
    this.onAddSchedule,
    this.onEditSchedule,
    this.onToggleSchedule,
  });

  List<DeviceSchedule> get _deviceSchedules => schedules
      .where((s) => s.deviceId == currentDeviceId)
      .toList()
    ..sort((a, b) => _timeToMinutes(a.time).compareTo(_timeToMinutes(b.time)));

  List<DeviceSchedule> get _globalSchedules => schedules
      .where((s) => s.isGlobal)
      .toList()
    ..sort((a, b) => _timeToMinutes(a.time).compareTo(_timeToMinutes(b.time)));

  int _timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.foreground,
                    ),
                  ),
                ],
              ),
              if (onAddSchedule != null)
                ShadButton.ghost(
                  onPressed: onAddSchedule,
                  size: ShadButtonSize.sm,
                  child: const Icon(Icons.add, size: 18),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Content
          Expanded(
            child: schedules.isEmpty
                ? _buildEmptyState(theme)
                : ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      // Device-specific schedules
                      if (_deviceSchedules.isNotEmpty) ...[
                        _SectionLabel(
                          label: currentDeviceName ?? 'Устройство',
                          icon: Icons.air,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 8),
                        ..._deviceSchedules.map((schedule) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: _ScheduleItem(
                                schedule: schedule,
                                onEdit: onEditSchedule != null
                                    ? () => onEditSchedule!(schedule.id)
                                    : null,
                                onToggle: onToggleSchedule != null
                                    ? () => onToggleSchedule!(schedule)
                                    : null,
                              ),
                            )),
                      ],

                      // Divider between sections
                      if (_deviceSchedules.isNotEmpty &&
                          _globalSchedules.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Divider(color: theme.colorScheme.border),
                        const SizedBox(height: 8),
                      ],

                      // Global schedules
                      if (_globalSchedules.isNotEmpty) ...[
                        _SectionLabel(
                          label: 'Все устройства',
                          icon: Icons.public,
                          color: theme.colorScheme.mutedForeground,
                        ),
                        const SizedBox(height: 8),
                        ..._globalSchedules.map((schedule) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: _ScheduleItem(
                                schedule: schedule,
                                isGlobalStyle: true,
                                onEdit: onEditSchedule != null
                                    ? () => onEditSchedule!(schedule.id)
                                    : null,
                                onToggle: onToggleSchedule != null
                                    ? () => onToggleSchedule!(schedule)
                                    : null,
                              ),
                            )),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ShadThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 36,
            color: theme.colorScheme.mutedForeground.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Нет расписаний',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Добавьте автоматизацию',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.mutedForeground.withValues(alpha: 0.7),
            ),
          ),
          if (onAddSchedule != null) ...[
            const SizedBox(height: 16),
            ShadButton.outline(
              onPressed: onAddSchedule,
              size: ShadButtonSize.sm,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16),
                  SizedBox(width: 4),
                  Text('Добавить'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _SectionLabel({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final DeviceSchedule schedule;
  final bool isGlobalStyle;
  final VoidCallback? onEdit;
  final VoidCallback? onToggle;

  const _ScheduleItem({
    required this.schedule,
    this.isGlobalStyle = false,
    this.onEdit,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isActive = schedule.isEnabled;
    final actionColor = _getActionColor(schedule.action);

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? actionColor.withValues(alpha: 0.05)
              : theme.colorScheme.muted.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive
                ? actionColor.withValues(alpha: 0.2)
                : theme.colorScheme.border,
          ),
        ),
        child: Row(
          children: [
            // Status dot (toggleable)
            GestureDetector(
              onTap: onToggle,
              child: GlowingStatusDot(
                color: isActive ? actionColor : theme.colorScheme.mutedForeground,
                isGlowing: isActive,
                size: 10,
              ),
            ),
            const SizedBox(width: 10),

            // Time
            SizedBox(
              width: 48,
              child: Text(
                schedule.timeFormatted,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isActive ? actionColor : theme.colorScheme.mutedForeground,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),

            // Action icon
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isActive
                    ? actionColor.withValues(alpha: 0.15)
                    : theme.colorScheme.muted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _getActionIcon(schedule.action),
                size: 14,
                color: isActive ? actionColor : theme.colorScheme.mutedForeground,
              ),
            ),
            const SizedBox(width: 10),

            // Label and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (schedule.label != null)
                    Text(
                      schedule.label!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? theme.colorScheme.foreground
                            : theme.colorScheme.mutedForeground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    _getActionDescription(schedule),
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),

            // Days indicator
            _DaysIndicator(
              days: schedule.repeatDays,
              isActive: isActive,
            ),

            // Temperature badge (if applicable)
            if (schedule.temperature != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.heating.withValues(alpha: 0.15)
                      : theme.colorScheme.muted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${schedule.temperature!.round()}°',
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive
                        ? AppColors.heating
                        : theme.colorScheme.mutedForeground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getActionColor(ScheduleAction action) => switch (action) {
        ScheduleAction.turnOn => AppColors.success,
        ScheduleAction.turnOff => AppColors.error,
        ScheduleAction.setTemperature => AppColors.heating,
        ScheduleAction.setMode => AppColors.primary,
      };

  IconData _getActionIcon(ScheduleAction action) => switch (action) {
        ScheduleAction.turnOn => Icons.power_settings_new,
        ScheduleAction.turnOff => Icons.power_off,
        ScheduleAction.setTemperature => Icons.thermostat,
        ScheduleAction.setMode => Icons.tune,
      };

  String _getActionDescription(DeviceSchedule schedule) {
    final action = switch (schedule.action) {
      ScheduleAction.turnOn => 'Включить',
      ScheduleAction.turnOff => 'Выключить',
      ScheduleAction.setTemperature => 'Установить температуру',
      ScheduleAction.setMode => 'Изменить режим',
    };

    if (schedule.temperature != null) {
      return '$action: ${schedule.temperature!.round()}°C';
    }
    if (schedule.mode != null) {
      return '$action: ${schedule.mode}';
    }
    return action;
  }
}

class _DaysIndicator extends StatelessWidget {
  final Set<DayOfWeek> days;
  final bool isActive;

  const _DaysIndicator({
    required this.days,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    // If all days, show "Ежедневно"
    if (days.length == 7) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: theme.colorScheme.muted.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Ежедн.',
          style: TextStyle(
            fontSize: 9,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
      );
    }

    // If weekdays only
    final weekdays = {
      DayOfWeek.monday,
      DayOfWeek.tuesday,
      DayOfWeek.wednesday,
      DayOfWeek.thursday,
      DayOfWeek.friday,
    };
    if (days.length == 5 && days.containsAll(weekdays)) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: theme.colorScheme.muted.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Пн-Пт',
          style: TextStyle(
            fontSize: 9,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
      );
    }

    // Show individual day dots
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: DayOfWeek.values.map((day) {
        final isIncluded = days.contains(day);
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isIncluded
                ? (isActive
                    ? AppColors.primary
                    : theme.colorScheme.mutedForeground)
                : theme.colorScheme.muted.withValues(alpha: 0.3),
          ),
        );
      }).toList(),
    );
  }
}
