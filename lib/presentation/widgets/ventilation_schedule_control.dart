/// Ventilation Schedule Control Widget
///
/// Compact card for schedule overview and quick status
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/hvac_unit.dart';

class VentilationScheduleControl extends StatelessWidget {
  final HvacUnit unit;
  final VoidCallback? onSchedulePressed;

  const VentilationScheduleControl({
    super.key,
    required this.unit,
    this.onSchedulePressed,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;
    final todaySchedule = unit.schedule?.getDaySchedule(dayOfWeek);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.deviceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.schedule,
                  color: AppTheme.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Расписание',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Автоматическое управление',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Today's schedule
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getDayName(dayOfWeek),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: todaySchedule?.timerEnabled == true
                            ? AppTheme.success.withValues(alpha: 0.2)
                            : AppTheme.textSecondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        todaySchedule?.timerEnabled == true ? 'Включен' : 'Выключен',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: todaySchedule?.timerEnabled == true
                              ? AppTheme.success
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTime(
                        'Включение',
                        todaySchedule?.turnOnTime,
                        Icons.power_settings_new,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTime(
                        'Отключение',
                        todaySchedule?.turnOffTime,
                        Icons.power_off,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Quick stats
          Row(
            children: [
              Expanded(
                child: _buildStat(
                  'Статус',
                  unit.power ? 'Работает' : 'Выключено',
                  unit.power ? AppTheme.success : AppTheme.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStat(
                  'Время работы',
                  '${(unit.supplyFanSpeed ?? 0) > 0 ? '2ч 15м' : '0м'}',
                  AppTheme.info,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Edit schedule button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onSchedulePressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: AppTheme.primaryOrange,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Настроить расписание',
                style: TextStyle(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTime(String label, TimeOfDay? time, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          time != null
              ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
              : '--:--',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
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
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'Понедельник';
      case 2:
        return 'Вторник';
      case 3:
        return 'Среда';
      case 4:
        return 'Четверг';
      case 5:
        return 'Пятница';
      case 6:
        return 'Суббота';
      case 7:
        return 'Воскресенье';
      default:
        return '';
    }
  }
}
