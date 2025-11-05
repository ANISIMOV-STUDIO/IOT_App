/// Schedule card layout variations for different screen sizes
///
/// Mobile and tablet/desktop layout implementations
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'schedule_model.dart';
import 'schedule_action_buttons.dart';
import 'schedule_toggle_switch.dart';
import 'schedule_info_widgets.dart';

/// Mobile layout for schedule card
class ScheduleCardMobileLayout extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const ScheduleCardMobileLayout({
    super.key,
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: ScheduleInfo(schedule: schedule)),
            ScheduleToggleSwitch(
              isActive: schedule.isActive,
              onToggle: onToggle,
              scheduleName: schedule.name,
            ),
          ],
        ),
        const SizedBox(height: HvacSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TemperatureInfo(schedule: schedule),
            ScheduleActionButtons(
              schedule: schedule,
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ],
        ),
      ],
    );
  }
}

/// Tablet/Desktop layout for schedule card
class ScheduleCardTabletLayout extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const ScheduleCardTabletLayout({
    super.key,
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: ScheduleInfo(schedule: schedule, isTablet: true),
        ),
        Expanded(
          flex: 2,
          child: TemperatureInfo(schedule: schedule),
        ),
        ScheduleActionButtons(
          schedule: schedule,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
        const SizedBox(width: HvacSpacing.md),
        ScheduleToggleSwitch(
          isActive: schedule.isActive,
          onToggle: onToggle,
          scheduleName: schedule.name,
        ),
      ],
    );
  }
}