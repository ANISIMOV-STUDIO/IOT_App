/// Today's Schedule Card Component
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:hvac_ui_kit/src/utils/adaptive_layout.dart' as adaptive;
import 'schedule_time.dart';

/// Today's schedule display card
class TodayScheduleCard extends StatelessWidget {
  final int dayOfWeek;
  final dynamic schedule;

  const TodayScheduleCard({
    super.key,
    required this.dayOfWeek,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveControl(
      builder: (context, deviceSize) {
        return Container(
          padding: EdgeInsets.all(
              adaptive.AdaptiveLayout.spacing(context, base: 10)),
          decoration: BoxDecoration(
            color: HvacColors.backgroundDark,
            borderRadius: BorderRadius.circular(
              adaptive.AdaptiveLayout.borderRadius(context, base: 12),
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
                      style: HvacTypography.labelMedium.copyWith(
                        fontSize:
                            adaptive.AdaptiveLayout.fontSize(context, base: 11),
                        color: HvacColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 3.0,
                    ),
                    decoration: BoxDecoration(
                      color: schedule?.timerEnabled == true
                          ? HvacColors.success.withValues(alpha: 0.2)
                          : HvacColors.textSecondary.withValues(alpha: 0.2),
                      borderRadius: HvacRadius.xsRadius,
                    ),
                    child: Text(
                      schedule?.timerEnabled == true ? 'Включен' : 'Выключен',
                      style: HvacTypography.labelSmall.copyWith(
                        fontSize:
                            adaptive.AdaptiveLayout.fontSize(context, base: 10),
                        fontWeight: FontWeight.w600,
                        color: schedule?.timerEnabled == true
                            ? HvacColors.success
                            : HvacColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: adaptive.AdaptiveLayout.spacing(context, base: 10)),
              Row(
                children: [
                  Expanded(
                    child: ScheduleTime(
                      label: 'Включение',
                      time: schedule?.turnOnTime,
                      icon: Icons.power_settings_new,
                    ),
                  ),
                  SizedBox(width: adaptive.AdaptiveLayout.spacing(context)),
                  Expanded(
                    child: ScheduleTime(
                      label: 'Отключение',
                      time: schedule?.turnOffTime,
                      icon: Icons.power_off,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
