/// Device schedule card
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';
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
    final theme = ShadTheme.of(context);

    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.foreground,
                ),
              ),
              Row(
                children: [
                  if (onAddSchedule != null)
                    ShadButton.ghost(
                      onPressed: onAddSchedule,
                      size: ShadButtonSize.sm,
                      child: const Icon(Icons.add, size: 18),
                    ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.calendar_month,
                    color: theme.colorScheme.mutedForeground,
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
                ? _buildEmptyState(theme)
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

  Widget _buildEmptyState(ShadThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 32,
            color: theme.colorScheme.mutedForeground,
          ),
          const SizedBox(height: 8),
          Text(
            'Нет расписаний',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.mutedForeground,
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
    final theme = ShadTheme.of(context);
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
                  ? AppColors.primary
                  : theme.colorScheme.mutedForeground,
              isGlowing: isActive,
            ),
          ),
          const SizedBox(width: 8),

          // Time
          Text(
            schedule.timeFormatted,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? AppColors.primary
                  : theme.colorScheme.mutedForeground,
            ),
          ),
          const SizedBox(width: 8),

          // Action label
          Expanded(
            child: Text(
              schedule.label ?? schedule.actionDescription,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.mutedForeground,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Temperature (if set)
          if (schedule.temperature != null)
            Text(
              '${schedule.temperature!.round()}°',
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? AppColors.primary
                    : theme.colorScheme.mutedForeground,
              ),
            ),

          // Global indicator
          if (schedule.isGlobal) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.public,
              size: 14,
              color: theme.colorScheme.mutedForeground,
            ),
          ],
        ],
      ),
    );
  }
}
