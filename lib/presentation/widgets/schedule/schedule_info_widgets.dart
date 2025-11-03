/// Schedule information display widgets
///
/// Extracted components for displaying schedule details
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'schedule_model.dart';

/// Schedule name and time info widget
class ScheduleInfo extends StatelessWidget {
  final Schedule schedule;
  final bool isTablet;

  const ScheduleInfo({
    super.key,
    required this.schedule,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schedule.name,
          style: TextStyle(
            fontSize: isTablet ? 18.sp : 16.sp,
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
        SizedBox(height: HvacSpacing.xs.h),
        Text(
          '${schedule.time} • ${schedule.days.join(', ')}',
          style: TextStyle(
            fontSize: 14.sp,
            color: HvacColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Temperature and mode info widget
class TemperatureInfo extends StatelessWidget {
  final Schedule schedule;

  const TemperatureInfo({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.thermostat,
          size: 20.sp,
          color: HvacColors.primaryOrange,
        ),
        SizedBox(width: HvacSpacing.xs.w),
        Text(
          '${schedule.temperature}°C',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: HvacColors.textPrimary,
          ),
        ),
        SizedBox(width: HvacSpacing.sm.w),
        _ModeChip(mode: schedule.mode),
      ],
    );
  }
}

/// Mode display chip
class _ModeChip extends StatelessWidget {
  final String mode;

  const _ModeChip({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: HvacSpacing.xs.w,
        vertical: HvacSpacing.xxs.h,
      ),
      decoration: BoxDecoration(
        color: HvacColors.primaryOrange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(HvacSpacing.xs.r),
      ),
      child: Text(
        mode,
        style: TextStyle(
          fontSize: 12.sp,
          color: HvacColors.primaryOrange,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}