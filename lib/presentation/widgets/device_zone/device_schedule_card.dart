/// Device schedule card
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';
import '../../../domain/entities/device_schedule.dart';
import '../common/glowing_status_dot.dart';

/// Schedule card showing device automation rules
class DeviceScheduleCard extends StatelessWidget {
  final List<DeviceSchedule> schedules;
  final String title;
  final VoidCallback? onAddSchedule;
  final ValueChanged<String>? onEditSchedule;
  final ValueChanged<String>? onDeleteSchedule;
  final ValueChanged<DeviceSchedule>? onToggleSchedule;

  const DeviceScheduleCard({
    super.key,
    required this.schedules,
    this.title = 'Расписание',
    this.onAddSchedule,
    this.onEditSchedule,
    this.onDeleteSchedule,
    this.onToggleSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final t = NeumorphicTheme.of(context);

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: t.typography.titleMedium),
              Row(
                children: [
                  if (onAddSchedule != null)
                    NeumorphicIconButton(
                      icon: Icons.add,
                      iconColor: NeumorphicColors.accentPrimary,
                      size: 32,
                      onPressed: onAddSchedule,
                    ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.calendar_month,
                    color: t.colors.textTertiary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Schedule list
          Expanded(
            child: schedules.isEmpty
                ? _buildEmptyState(t)
                : ListView.builder(
                    itemCount: schedules.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ScheduleItem(
                          schedule: schedules[index],
                          onEdit: onEditSchedule != null
                              ? () => onEditSchedule!(schedules[index].id)
                              : null,
                          onToggle: onToggleSchedule != null
                              ? () => onToggleSchedule!(schedules[index])
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(NeumorphicThemeData t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 32,
            color: t.colors.textTertiary,
          ),
          const SizedBox(height: 8),
          Text(
            'Нет расписаний',
            style: t.typography.bodySmall.copyWith(
              color: t.colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final DeviceSchedule schedule;
  final VoidCallback? onEdit;
  final VoidCallback? onToggle;

  const _ScheduleItem({
    required this.schedule,
    this.onEdit,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final t = NeumorphicTheme.of(context);
    final isActive = schedule.isEnabled;

    return GestureDetector(
      onTap: onEdit,
      child: Row(
        children: [
          // Status dot
          GestureDetector(
            onTap: onToggle,
            child: GlowingStatusDot(
              color: isActive
                  ? NeumorphicColors.accentPrimary
                  : t.colors.textTertiary,
              isGlowing: isActive,
            ),
          ),
          const SizedBox(width: 8),

          // Time
          Text(
            schedule.timeFormatted,
            style: t.typography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: isActive
                  ? NeumorphicColors.accentPrimary
                  : t.colors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),

          // Action label
          Expanded(
            child: Text(
              schedule.label ?? schedule.actionDescription,
              style: t.typography.bodyMedium.copyWith(
                color: t.colors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Temperature (if set)
          if (schedule.temperature != null)
            Text(
              '${schedule.temperature!.round()}°',
              style: t.typography.labelSmall.copyWith(
                color: isActive
                    ? NeumorphicColors.accentPrimary
                    : t.colors.textTertiary,
              ),
            ),

          // Global indicator
          if (schedule.isGlobal) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.public,
              size: 14,
              color: t.colors.textTertiary,
            ),
          ],
        ],
      ),
    );
  }
}
