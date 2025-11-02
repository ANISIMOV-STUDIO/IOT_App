/// Day Schedule Card Widget
///
/// Card for displaying and editing daily schedule (on/off times)
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/day_schedule.dart';

class DayScheduleCard extends StatelessWidget {
  final String dayName;
  final DaySchedule schedule;
  final ValueChanged<DaySchedule>? onUpdate;
  final bool isEditable;

  const DayScheduleCard({
    super.key,
    required this.dayName,
    required this.schedule,
    this.onUpdate,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day name
          Text(
            dayName,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),

          // Time controls
          Row(
            children: [
              Expanded(
                child: _buildTimeControl(
                  context,
                  'Включить',
                  schedule.turnOnTime,
                  (time) {
                    if (onUpdate != null) {
                      onUpdate!(schedule.copyWith(turnOnTime: time));
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimeControl(
                  context,
                  'Отключить',
                  schedule.turnOffTime,
                  (time) {
                    if (onUpdate != null) {
                      onUpdate!(schedule.copyWith(turnOffTime: time));
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Timer toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Таймер',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    schedule.timerEnabled ? 'Включен' : 'Выключен',
                    style: TextStyle(
                      fontSize: 12,
                      color: schedule.timerEnabled
                          ? AppTheme.success
                          : AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: schedule.timerEnabled,
                    onChanged: isEditable && onUpdate != null
                        ? (value) {
                            onUpdate!(schedule.copyWith(timerEnabled: value));
                          }
                        : null,
                    activeThumbColor: AppTheme.primaryOrange,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeControl(
    BuildContext context,
    String label,
    TimeOfDay? time,
    ValueChanged<TimeOfDay> onTimeChanged,
  ) {
    return GestureDetector(
      onTap: isEditable && onUpdate != null
          ? () async {
              final newTime = await showTimePicker(
                context: context,
                initialTime: time ?? const TimeOfDay(hour: 12, minute: 0),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppTheme.primaryOrange,
                        onPrimary: Colors.white,
                        surface: AppTheme.backgroundCard,
                        onSurface: AppTheme.textPrimary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (newTime != null) {
                onTimeChanged(newTime);
              }
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.backgroundDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time != null
                      ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                      : '--:--',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
