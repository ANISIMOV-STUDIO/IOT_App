/// Ventilation Schedule Control Widget
///
/// Adaptive card for schedule overview and quick status
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../domain/entities/hvac_unit.dart';
import 'schedule/schedule_components.dart';

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
    final isMobile = ResponsiveUtils.isMobile(context);
    final now = DateTime.now();
    final dayOfWeek = now.weekday;
    final todaySchedule = unit.schedule?.getDaySchedule(dayOfWeek);

    return HvacCard(
      padding: EdgeInsets.all(isMobile ? HvacSpacing.md : HvacSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScheduleHeader(),
          const SizedBox(height: HvacSpacing.sm),
          TodayScheduleCard(
            dayOfWeek: dayOfWeek,
            schedule: todaySchedule,
          ),
          const SizedBox(height: HvacSpacing.sm),
          ScheduleQuickStats(
            isPowerOn: unit.power,
            fanSpeed: unit.supplyFanSpeed,
          ),
          const SizedBox(height: HvacSpacing.sm),
          ScheduleEditButton(onPressed: onSchedulePressed),
        ],
      ),
    );
  }
}
