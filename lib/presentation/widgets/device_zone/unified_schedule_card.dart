/// Unified Schedule Card - shows device-specific and global schedules
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';
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
    final t = GlassTheme.of(context);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 20,
                    color: GlassColors.accentPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(title, style: t.typography.titleMedium),
                ],
              ),
              if (onAddSchedule != null)
                GlassIconButton(
                  icon: Icons.add,
                  iconColor: GlassColors.accentPrimary,
                  size: 32,
                  onPressed: onAddSchedule,
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Content
          Expanded(
            child: schedules.isEmpty
                ? _buildEmptyState(t)
                : ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      // Device-specific schedules
                      if (_deviceSchedules.isNotEmpty) ...[
                        _SectionLabel(
                          label: currentDeviceName ?? 'Устройство',
                          icon: Icons.air,
                          color: GlassColors.accentPrimary,
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
                        Divider(
                          color: t.colors.textTertiary.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Global schedules
                      if (_globalSchedules.isNotEmpty) ...[
                        _SectionLabel(
                          label: 'Все устройства',
                          icon: Icons.public,
                          color: t.colors.textSecondary,
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

  Widget _buildEmptyState(GlassThemeData t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 36,
            color: t.colors.textTertiary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Нет расписаний',
            style: t.typography.bodyMedium.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Добавьте автоматизацию',
            style: t.typography.bodySmall.copyWith(
              color: t.colors.textTertiary,
            ),
          ),
          if (onAddSchedule != null) ...[
            const SizedBox(height: 16),
            GlassButton(
              onPressed: onAddSchedule,
              size: GlassButtonSize.small,
              icon: Icons.add,
              child: const Text('Добавить'),
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
    final t = GlassTheme.of(context);

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
          style: t.typography.labelSmall.copyWith(
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
    final t = GlassTheme.of(context);
    final isActive = schedule.isEnabled;
    final actionColor = _getActionColor(schedule.action);

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? actionColor.withValues(alpha: 0.05)
              : t.colors.textTertiary.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive
                ? actionColor.withValues(alpha: 0.2)
                : t.colors.textTertiary.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            // Status dot (toggleable)
            GestureDetector(
              onTap: onToggle,
              child: GlowingStatusDot(
                color: isActive ? actionColor : t.colors.textTertiary,
                isGlowing: isActive,
                size: 10,
              ),
            ),
            const SizedBox(width: 10),

            // Time
            Container(
              width: 48,
              child: Text(
                schedule.timeFormatted,
                style: t.typography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isActive ? actionColor : t.colors.textTertiary,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ),

            // Action icon
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isActive
                    ? actionColor.withValues(alpha: 0.15)
                    : t.colors.textTertiary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _getActionIcon(schedule.action),
                size: 14,
                color: isActive ? actionColor : t.colors.textTertiary,
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
                      style: t.typography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? t.colors.textPrimary
                            : t.colors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    _getActionDescription(schedule),
                    style: t.typography.labelSmall.copyWith(
                      color: t.colors.textSecondary,
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
                      ? GlassColors.modeHeating.withValues(alpha: 0.15)
                      : t.colors.textTertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${schedule.temperature!.round()}°',
                  style: t.typography.labelSmall.copyWith(
                    color: isActive
                        ? GlassColors.modeHeating
                        : t.colors.textTertiary,
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
        ScheduleAction.turnOn => GlassColors.accentSuccess,
        ScheduleAction.turnOff => GlassColors.accentError,
        ScheduleAction.setTemperature => GlassColors.modeHeating,
        ScheduleAction.setMode => GlassColors.accentPrimary,
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
    final t = GlassTheme.of(context);

    // If all days, show "Ежедневно"
    if (days.length == 7) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: t.colors.textTertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Ежедн.',
          style: t.typography.labelSmall.copyWith(
            color: t.colors.textSecondary,
            fontSize: 9,
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
          color: t.colors.textTertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Пн-Пт',
          style: t.typography.labelSmall.copyWith(
            color: t.colors.textSecondary,
            fontSize: 9,
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
                    ? GlassColors.accentPrimary
                    : t.colors.textSecondary)
                : t.colors.textTertiary.withValues(alpha: 0.2),
          ),
        );
      }).toList(),
    );
  }
}
