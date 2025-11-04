/// Day schedule card with web-friendly interactions
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/day_schedule.dart';
import '../common/time_picker_field.dart';

/// Card widget for displaying and editing a single day's schedule
class DayScheduleCard extends StatefulWidget {
  final String dayName;
  final int dayOfWeek;
  final DaySchedule schedule;
  final ValueChanged<DaySchedule> onScheduleChanged;

  const DayScheduleCard({
    super.key,
    required this.dayName,
    required this.dayOfWeek,
    required this.schedule,
    required this.onScheduleChanged,
  });

  @override
  State<DayScheduleCard> createState() => _DayScheduleCardState();
}

class _DayScheduleCardState extends State<DayScheduleCard> {
  bool _isHovered = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.schedule.timerEnabled;
  }

  @override
  void didUpdateWidget(DayScheduleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.schedule.timerEnabled != oldWidget.schedule.timerEnabled) {
      setState(() {
        _isExpanded = widget.schedule.timerEnabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (widget.dayOfWeek * 50)),
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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(HvacSpacing.md.w),
          decoration: BoxDecoration(
            color: _isHovered
                ? HvacColors.backgroundCard.withValues(alpha: 0.95)
                : HvacColors.backgroundCard,
            borderRadius: BorderRadius.circular(HvacRadius.md.r),
            border: Border.all(
              color: _isHovered
                  ? HvacColors.primaryOrange.withValues(alpha: 0.5)
                  : HvacColors.backgroundCardBorder,
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: HvacColors.primaryOrange.withValues(alpha: 0.1),
                      blurRadius: 8.r,
                      offset: Offset(0, 4.h),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: SizedBox(height: 0.h),
                secondChild: _buildTimeSelectors(),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.dayName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
        _WebSwitch(
          value: widget.schedule.timerEnabled,
          onChanged: (value) {
            widget.onScheduleChanged(
              widget.schedule.copyWith(timerEnabled: value),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimeSelectors() {
    return Column(
      children: [
        SizedBox(height: HvacSpacing.sm.h),
        Row(
          children: [
            Expanded(
              child: TimePickerField(
                label: 'Включение',
                currentTime: widget.schedule.turnOnTime,
                icon: Icons.power_settings_new,
                onTimeChanged: (time) {
                  widget.onScheduleChanged(
                    widget.schedule.copyWith(turnOnTime: time),
                  );
                },
              ),
            ),
            SizedBox(width: HvacSpacing.sm.w),
            Expanded(
              child: TimePickerField(
                label: 'Отключение',
                currentTime: widget.schedule.turnOffTime,
                icon: Icons.power_off,
                onTimeChanged: (time) {
                  widget.onScheduleChanged(
                    widget.schedule.copyWith(turnOffTime: time),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Custom switch with web-friendly hover states
class _WebSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _WebSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  State<_WebSwitch> createState() => _WebSwitchState();
}

class _WebSwitchState extends State<_WebSwitch> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Transform.scale(
        scale: _isHovered ? 1.05 : 0.9,
        child: Switch(
          value: widget.value,
          onChanged: widget.onChanged,
          activeThumbColor: HvacColors.primaryOrange,
          activeTrackColor: HvacColors.primaryOrange.withValues(alpha: 0.5),
          inactiveThumbColor: HvacColors.textSecondary,
          inactiveTrackColor: HvacColors.textSecondary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}