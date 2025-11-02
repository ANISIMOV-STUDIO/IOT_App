/// Ventilation Schedule Control Widget
///
/// Adaptive card for schedule overview and quick status
/// Uses big-tech adaptive layout approach
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/adaptive_layout.dart';
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
    return AdaptiveControl(
      builder: (context, deviceSize) {
        final now = DateTime.now();
        final dayOfWeek = now.weekday;
        final todaySchedule = unit.schedule?.getDaySchedule(dayOfWeek);

        final children = [
          _buildHeader(context, deviceSize),
          SizedBox(height: deviceSize == DeviceSize.compact ? 12.h : AdaptiveLayout.spacing(context, base: 16)),
          _buildTodaySchedule(context, deviceSize, dayOfWeek, todaySchedule),
          SizedBox(height: deviceSize == DeviceSize.compact ? 12.h : AdaptiveLayout.spacing(context, base: 16)),
          _buildQuickStats(context, deviceSize),
          SizedBox(height: deviceSize == DeviceSize.compact ? 12.h : AdaptiveLayout.spacing(context, base: 16)),
          _buildEditButton(context, deviceSize),
        ];

        // Add spacer only on desktop for equal heights
        if (deviceSize != DeviceSize.compact) {
          children.add(const Spacer());
        }

        return Container(
          padding: AdaptiveLayout.controlPadding(context),
          decoration: BoxDecoration(
            color: AppTheme.backgroundCard,
            borderRadius: BorderRadius.circular(
              AdaptiveLayout.borderRadius(context, base: 16),
            ),
            border: Border.all(
              color: AppTheme.backgroundCardBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, DeviceSize deviceSize) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AdaptiveLayout.spacing(context, base: 8)),
          decoration: BoxDecoration(
            color: AppTheme.success.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(
              AdaptiveLayout.borderRadius(context, base: 8),
            ),
          ),
          child: Icon(
            Icons.schedule,
            color: AppTheme.success,
            size: AdaptiveLayout.iconSize(context, base: 20),
          ),
        ),
        SizedBox(width: AdaptiveLayout.spacing(context)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Расписание',
                style: TextStyle(
                  fontSize: AdaptiveLayout.fontSize(context, base: 16),
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Автоматическое управление',
                style: TextStyle(
                  fontSize: AdaptiveLayout.fontSize(context, base: 12),
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySchedule(
    BuildContext context,
    DeviceSize deviceSize,
    int dayOfWeek,
    dynamic todaySchedule,
  ) {
    return Container(
      padding: EdgeInsets.all(AdaptiveLayout.spacing(context, base: 10)),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(
          AdaptiveLayout.borderRadius(context, base: 12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _getDayName(dayOfWeek),
                  style: TextStyle(
                    fontSize: AdaptiveLayout.fontSize(context, base: 11),
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: todaySchedule?.timerEnabled == true
                      ? AppTheme.success.withValues(alpha: 0.2)
                      : AppTheme.textSecondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  todaySchedule?.timerEnabled == true ? 'Включен' : 'Выключен',
                  style: TextStyle(
                    fontSize: AdaptiveLayout.fontSize(context, base: 10),
                    fontWeight: FontWeight.w600,
                    color: todaySchedule?.timerEnabled == true
                        ? AppTheme.success
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AdaptiveLayout.spacing(context, base: 10)),
          Row(
            children: [
              Expanded(
                child: _buildTime(
                  context,
                  deviceSize,
                  'Включение',
                  todaySchedule?.turnOnTime,
                  Icons.power_settings_new,
                ),
              ),
              SizedBox(width: AdaptiveLayout.spacing(context)),
              Expanded(
                child: _buildTime(
                  context,
                  deviceSize,
                  'Отключение',
                  todaySchedule?.turnOffTime,
                  Icons.power_off,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, DeviceSize deviceSize) {
    return Row(
      children: [
        Expanded(
          child: _buildStat(
            context,
            deviceSize,
            'Статус',
            unit.power ? 'Работает' : 'Выключено',
            unit.power ? AppTheme.success : AppTheme.error,
          ),
        ),
        SizedBox(width: AdaptiveLayout.spacing(context)),
        Expanded(
          child: _buildStat(
            context,
            deviceSize,
            'Время работы',
            (unit.supplyFanSpeed ?? 0) > 0 ? '2ч 15м' : '0м',
            AppTheme.info,
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context, DeviceSize deviceSize) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onSchedulePressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppTheme.primaryOrange,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AdaptiveLayout.borderRadius(context, base: 8),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: deviceSize == DeviceSize.compact ? 10.h : 12.h,
          ),
        ),
        child: Text(
          'Настроить расписание',
          style: TextStyle(
            color: AppTheme.primaryOrange,
            fontWeight: FontWeight.w600,
            fontSize: AdaptiveLayout.fontSize(context, base: 13),
          ),
        ),
      ),
    );
  }

  Widget _buildTime(
    BuildContext context,
    DeviceSize deviceSize,
    String label,
    TimeOfDay? time,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AdaptiveLayout.iconSize(context, base: 12),
              color: AppTheme.textSecondary,
            ),
            SizedBox(width: AdaptiveLayout.spacing(context, base: 4)),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AdaptiveLayout.fontSize(context, base: 10),
                  color: AppTheme.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: AdaptiveLayout.spacing(context, base: 4)),
        Text(
          time != null
              ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
              : '--:--',
          style: TextStyle(
            fontSize: AdaptiveLayout.fontSize(context, base: 15),
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStat(
    BuildContext context,
    DeviceSize deviceSize,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AdaptiveLayout.spacing(context, base: 8)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          AdaptiveLayout.borderRadius(context, base: 8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AdaptiveLayout.fontSize(context, base: 10),
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: AdaptiveLayout.spacing(context, base: 4)),
          Text(
            value,
            style: TextStyle(
              fontSize: AdaptiveLayout.fontSize(context, base: 12),
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
