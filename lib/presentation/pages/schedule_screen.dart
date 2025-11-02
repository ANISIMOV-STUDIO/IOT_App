/// Schedule Screen
///
/// Edit weekly schedule for ventilation unit
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/week_schedule.dart';
import '../../domain/entities/day_schedule.dart';
import '../../domain/usecases/update_schedule.dart';

class ScheduleScreen extends StatefulWidget {
  final HvacUnit unit;

  const ScheduleScreen({
    super.key,
    required this.unit,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late WeekSchedule _schedule;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _schedule = widget.unit.schedule ?? WeekSchedule.defaultSchedule;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundCard,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => _onBackPressed(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Расписание',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              widget.unit.name,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _saveSchedule,
              child: const Text(
                'Сохранить',
                style: TextStyle(
                  color: AppTheme.primaryOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildDayCard('Понедельник', 1, _schedule.monday),
          const SizedBox(height: 12),
          _buildDayCard('Вторник', 2, _schedule.tuesday),
          const SizedBox(height: 12),
          _buildDayCard('Среда', 3, _schedule.wednesday),
          const SizedBox(height: 12),
          _buildDayCard('Четверг', 4, _schedule.thursday),
          const SizedBox(height: 12),
          _buildDayCard('Пятница', 5, _schedule.friday),
          const SizedBox(height: 12),
          _buildDayCard('Суббота', 6, _schedule.saturday),
          const SizedBox(height: 12),
          _buildDayCard('Воскресенье', 7, _schedule.sunday),
          const SizedBox(height: 20),

          // Quick actions
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildDayCard(String dayName, int dayOfWeek, DaySchedule schedule) {
    return Container(
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
          // Header with toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Switch(
                value: schedule.timerEnabled,
                onChanged: (value) {
                  setState(() {
                    _hasChanges = true;
                    _schedule = _schedule.updateDay(
                      dayOfWeek,
                      schedule.copyWith(timerEnabled: value),
                    );
                  });
                },
                activeThumbColor: AppTheme.primaryOrange,
                activeTrackColor: AppTheme.primaryOrange.withValues(alpha: 0.5),
              ),
            ],
          ),

          if (schedule.timerEnabled) ...[
            const SizedBox(height: 12),

            // Time selectors
            Row(
              children: [
                Expanded(
                  child: _buildTimeSelector(
                    'Включение',
                    schedule.turnOnTime,
                    Icons.power_settings_new,
                    (time) {
                      setState(() {
                        _hasChanges = true;
                        _schedule = _schedule.updateDay(
                          dayOfWeek,
                          schedule.copyWith(turnOnTime: time),
                        );
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimeSelector(
                    'Отключение',
                    schedule.turnOffTime,
                    Icons.power_off,
                    (time) {
                      setState(() {
                        _hasChanges = true;
                        _schedule = _schedule.updateDay(
                          dayOfWeek,
                          schedule.copyWith(turnOffTime: time),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeSelector(
    String label,
    TimeOfDay? currentTime,
    IconData icon,
    ValueChanged<TimeOfDay?> onTimeChanged,
  ) {
    return GestureDetector(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: currentTime ?? const TimeOfDay(hour: 12, minute: 0),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppTheme.primaryOrange,
                  onPrimary: Colors.white,
                  surface: AppTheme.backgroundCard,
                  onSurface: AppTheme.textPrimary,
                ),
                dialogTheme: const DialogThemeData(
                  backgroundColor: AppTheme.backgroundCard,
                ),
              ),
              child: child!,
            );
          },
        );
        if (time != null) {
          onTimeChanged(time);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
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
            Row(
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              currentTime != null
                  ? '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}'
                  : '--:--',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
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
          const Text(
            'Быстрые действия',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Будни',
                  'Пн-Пт 7:00-20:00',
                  Icons.work_outline,
                  _applyWeekdaySchedule,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  'Выходные',
                  'Сб-Вс 9:00-22:00',
                  Icons.weekend,
                  _applyWeekendSchedule,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: _buildQuickActionButton(
              'Отключить всё',
              'Выключить расписание на всю неделю',
              Icons.clear,
              _disableAllSchedules,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryOrange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyWeekdaySchedule() {
    setState(() {
      _hasChanges = true;
      const schedule = DaySchedule(
        turnOnTime: TimeOfDay(hour: 7, minute: 0),
        turnOffTime: TimeOfDay(hour: 20, minute: 0),
        timerEnabled: true,
      );
      _schedule = WeekSchedule(
        monday: schedule,
        tuesday: schedule,
        wednesday: schedule,
        thursday: schedule,
        friday: schedule,
        saturday: _schedule.saturday,
        sunday: _schedule.sunday,
      );
    });
  }

  void _applyWeekendSchedule() {
    setState(() {
      _hasChanges = true;
      const schedule = DaySchedule(
        turnOnTime: TimeOfDay(hour: 9, minute: 0),
        turnOffTime: TimeOfDay(hour: 22, minute: 0),
        timerEnabled: true,
      );
      _schedule = _schedule.copyWith(
        saturday: schedule,
        sunday: schedule,
      );
    });
  }

  void _disableAllSchedules() {
    setState(() {
      _hasChanges = true;
      const disabled = DaySchedule(timerEnabled: false);
      _schedule = const WeekSchedule(
        monday: disabled,
        tuesday: disabled,
        wednesday: disabled,
        thursday: disabled,
        friday: disabled,
        saturday: disabled,
        sunday: disabled,
      );
    });
  }

  Future<void> _saveSchedule() async {
    try {
      final updateScheduleUseCase = sl<UpdateSchedule>();
      await updateScheduleUseCase(widget.unit.id, _schedule);

      setState(() {
        _hasChanges = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Расписание успешно сохранено'),
            backgroundColor: AppTheme.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка сохранения: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  Future<void> _onBackPressed() async {
    if (_hasChanges) {
      final shouldDiscard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.backgroundCard,
          title: const Text(
            'Несохранённые изменения',
            style: TextStyle(color: AppTheme.textPrimary),
          ),
          content: const Text(
            'У вас есть несохранённые изменения. Выйти без сохранения?',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Отмена',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Выйти',
                style: TextStyle(color: AppTheme.error),
              ),
            ),
          ],
        ),
      );

      if (shouldDiscard == true && mounted) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }
}
