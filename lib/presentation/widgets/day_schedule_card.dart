/// Day Schedule Card Widget
///
/// Card for displaying and editing daily schedule (on/off times)
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
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
      margin: const EdgeInsets.only(bottom: HvacSpacing.mdR),
      padding: const EdgeInsets.all(HvacSpacing.lgR),
      decoration: HvacDecorations.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day name
          Text(
            dayName,
            style: HvacTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: HvacSpacing.sm),

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
              const SizedBox(width: HvacSpacing.md),
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
          const SizedBox(height: HvacSpacing.sm),

          // Timer toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Таймер',
                style: HvacTypography.bodyMedium.copyWith(
                  color: HvacColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    schedule.timerEnabled ? 'Включен' : 'Выключен',
                    style: HvacTypography.labelMedium.copyWith(
                      color: schedule.timerEnabled
                          ? HvacColors.success
                          : HvacColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: HvacSpacing.xs),
                  Switch(
                    value: schedule.timerEnabled,
                    onChanged: isEditable && onUpdate != null
                        ? (value) {
                            onUpdate!(schedule.copyWith(timerEnabled: value));
                          }
                        : null,
                    activeThumbColor: HvacColors.primaryOrange,
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
                        primary: HvacColors.primaryOrange,
                        onPrimary: Colors.white,
                        surface: HvacColors.backgroundCard,
                        onSurface: HvacColors.textPrimary,
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
        padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.sm, vertical: HvacSpacing.sm),
        decoration: HvacDecorations.cardFlat(
          color: HvacColors.backgroundCard,
          radius: HvacRadius.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: HvacTypography.captionSmall.copyWith(
                color: HvacColors.textSecondary,
              ),
            ),
            const SizedBox(height: HvacSpacing.xxs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time != null
                      ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                      : '--:--',
                  style: HvacTypography.titleSmall.copyWith(
                    color: HvacColors.textPrimary,
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: HvacColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
