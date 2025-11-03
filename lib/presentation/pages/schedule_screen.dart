/// Schedule Screen
///
/// Edit weekly schedule for ventilation unit with responsive design
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/hvac_unit.dart';
import '../../domain/entities/week_schedule.dart';
import '../../domain/entities/day_schedule.dart';
import '../../domain/usecases/update_schedule.dart';
import '../widgets/common/time_picker_field.dart';

class ScheduleScreen extends StatefulWidget {
  final HvacUnit unit;

  const ScheduleScreen({
    super.key,
    required this.unit,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late WeekSchedule _schedule;
  bool _hasChanges = false;
  bool _isSaving = false;
  late AnimationController _saveAnimationController;

  @override
  void initState() {
    super.initState();
    _schedule = widget.unit.schedule ?? WeekSchedule.defaultSchedule;
    _saveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _saveAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: HvacColors.backgroundCard,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: HvacColors.textPrimary, size: 24.sp),
          onPressed: () => _onBackPressed(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Расписание',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: HvacColors.textPrimary,
              ),
            ),
            Text(
              widget.unit.name,
              style: TextStyle(
                fontSize: 12.sp,
                color: HvacColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          if (_hasChanges)
            AnimatedScale(
              scale: _hasChanges ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: TextButton(
                onPressed: _isSaving ? null : _saveSchedule,
                child: _isSaving
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(HvacColors.primaryOrange),
                        ),
                      )
                    : Text(
                        'Сохранить',
                        style: TextStyle(
                          color: HvacColors.primaryOrange,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(HvacSpacing.lgR),
        children: [
          _buildDayCard('Понедельник', 1, _schedule.monday),
          const SizedBox(height: HvacSpacing.smR),
          _buildDayCard('Вторник', 2, _schedule.tuesday),
          const SizedBox(height: HvacSpacing.smR),
          _buildDayCard('Среда', 3, _schedule.wednesday),
          const SizedBox(height: HvacSpacing.smR),
          _buildDayCard('Четверг', 4, _schedule.thursday),
          const SizedBox(height: HvacSpacing.smR),
          _buildDayCard('Пятница', 5, _schedule.friday),
          const SizedBox(height: HvacSpacing.smR),
          _buildDayCard('Суббота', 6, _schedule.saturday),
          const SizedBox(height: HvacSpacing.smR),
          _buildDayCard('Воскресенье', 7, _schedule.sunday),
          const SizedBox(height: HvacSpacing.lgR),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildDayCard(String dayName, int dayOfWeek, DaySchedule schedule) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (dayOfWeek * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(HvacSpacing.mdR),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.mdR),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: HvacColors.textPrimary,
                  ),
                ),
                Transform.scale(
                  scale: 0.9,
                  child: Switch(
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
                    activeThumbColor: HvacColors.primaryOrange,
                    activeTrackColor: HvacColors.primaryOrange.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: const SizedBox(height: 0),
              secondChild: Column(
                children: [
                  const SizedBox(height: HvacSpacing.smR),
                  Row(
                    children: [
                      Expanded(
                        child: TimePickerField(
                          label: 'Включение',
                          currentTime: schedule.turnOnTime,
                          icon: Icons.power_settings_new,
                          onTimeChanged: (time) {
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
                      const SizedBox(width: HvacSpacing.smR),
                      Expanded(
                        child: TimePickerField(
                          label: 'Отключение',
                          currentTime: schedule.turnOffTime,
                          icon: Icons.power_off,
                          onTimeChanged: (time) {
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
              ),
              crossFadeState: schedule.timerEnabled
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.mdR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(HvacRadius.mdR),
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Быстрые действия',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: HvacSpacing.smR),
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
              const SizedBox(width: HvacSpacing.smR),
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
          const SizedBox(height: HvacSpacing.xsR),
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
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HvacRadius.smR),
        ),
        padding: const EdgeInsets.all(HvacSpacing.smR),
      ),
      child: Row(
        children: [
          Icon(icon, color: HvacColors.primaryOrange, size: 20.sp),
          const SizedBox(width: HvacSpacing.xsR),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: HvacColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: HvacColors.textSecondary,
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
    setState(() {
      _isSaving = true;
    });

    try {
      final updateScheduleUseCase = sl<UpdateSchedule>();
      await updateScheduleUseCase(widget.unit.id, _schedule);

      _saveAnimationController.forward().then((_) {
        _saveAnimationController.reverse();
      });

      setState(() {
        _hasChanges = false;
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: HvacSpacing.xsR),
                Text('Расписание успешно сохранено'),
              ],
            ),
            backgroundColor: HvacColors.success,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(HvacRadius.smR),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: HvacSpacing.xsR),
                Expanded(child: Text('Ошибка сохранения: $e')),
              ],
            ),
            backgroundColor: HvacColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(HvacRadius.smR),
            ),
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
          backgroundColor: HvacColors.backgroundCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HvacRadius.mdR),
          ),
          title: Text(
            'Несохранённые изменения',
            style: TextStyle(
              color: HvacColors.textPrimary,
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            'У вас есть несохранённые изменения. Выйти без сохранения?',
            style: TextStyle(
              color: HvacColors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Отмена',
                style: TextStyle(
                  color: HvacColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Выйти',
                style: TextStyle(
                  color: HvacColors.error,
                  fontSize: 14.sp,
                ),
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
