/// Schedule Screen
///
/// Edit weekly schedule for ventilation unit with responsive design
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/app_radius.dart';
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
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundCard,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 24.sp),
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
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              widget.unit.name,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.textSecondary,
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
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
                        ),
                      )
                    : Text(
                        'Сохранить',
                        style: TextStyle(
                          color: AppTheme.primaryOrange,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.lgR),
        children: [
          _buildDayCard('Понедельник', 1, _schedule.monday),
          SizedBox(height: AppSpacing.smR),
          _buildDayCard('Вторник', 2, _schedule.tuesday),
          SizedBox(height: AppSpacing.smR),
          _buildDayCard('Среда', 3, _schedule.wednesday),
          SizedBox(height: AppSpacing.smR),
          _buildDayCard('Четверг', 4, _schedule.thursday),
          SizedBox(height: AppSpacing.smR),
          _buildDayCard('Пятница', 5, _schedule.friday),
          SizedBox(height: AppSpacing.smR),
          _buildDayCard('Суббота', 6, _schedule.saturday),
          SizedBox(height: AppSpacing.smR),
          _buildDayCard('Воскресенье', 7, _schedule.sunday),
          SizedBox(height: AppSpacing.lgR),
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
        padding: EdgeInsets.all(AppSpacing.mdR),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(AppRadius.mdR),
          border: Border.all(
            color: AppTheme.backgroundCardBorder,
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
                    color: AppTheme.textPrimary,
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
                    activeThumbColor: AppTheme.primaryOrange,
                    activeTrackColor: AppTheme.primaryOrange.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: const SizedBox(height: 0),
              secondChild: Column(
                children: [
                  SizedBox(height: AppSpacing.smR),
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
                      SizedBox(width: AppSpacing.smR),
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
      padding: EdgeInsets.all(AppSpacing.mdR),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(AppRadius.mdR),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
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
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.smR),
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
              SizedBox(width: AppSpacing.smR),
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
          SizedBox(height: AppSpacing.xsR),
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
          borderRadius: BorderRadius.circular(AppRadius.smR),
        ),
        padding: EdgeInsets.all(AppSpacing.smR),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryOrange, size: 20.sp),
          SizedBox(width: AppSpacing.xsR),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
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
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: AppSpacing.xsR),
                const Text('Расписание успешно сохранено'),
              ],
            ),
            backgroundColor: AppTheme.success,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.smR),
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
                SizedBox(width: AppSpacing.xsR),
                Expanded(child: Text('Ошибка сохранения: $e')),
              ],
            ),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.smR),
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
          backgroundColor: AppTheme.backgroundCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.mdR),
          ),
          title: Text(
            'Несохранённые изменения',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18.sp,
            ),
          ),
          content: Text(
            'У вас есть несохранённые изменения. Выйти без сохранения?',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Отмена',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Выйти',
                style: TextStyle(
                  color: AppTheme.error,
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
