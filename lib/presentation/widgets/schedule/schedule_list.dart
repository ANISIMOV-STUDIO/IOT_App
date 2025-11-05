/// Schedule list management widget with web-friendly interactions
///
/// Manages the display and interaction of multiple schedule cards
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'schedule_model.dart';
import 'schedule_card.dart';

class ScheduleList extends StatefulWidget {
  final List<Schedule> schedules;
  final Function(Schedule) onEdit;
  final Function(Schedule) onDelete;
  final Function(Schedule, bool) onToggle;
  final VoidCallback? onRefresh;

  const ScheduleList({
    super.key,
    required this.schedules,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    this.onRefresh,
  });

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  Schedule? _selectedSchedule;
  int _focusedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? HvacSpacing.md : HvacSpacing.xl,
        vertical: HvacSpacing.md,
      ),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: _handleKeyEvent,
        child: ListView.separated(
          itemCount: widget.schedules.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: HvacSpacing.md,
          ),
          itemBuilder: (context, index) {
            final schedule = widget.schedules[index];
            return Focus(
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  setState(() => _focusedIndex = index);
                }
              },
              child: ScheduleCard(
                key: ValueKey(schedule.id),
                schedule: schedule,
                isSelected: _selectedSchedule?.id == schedule.id ||
                    _focusedIndex == index,
                onTap: () => _selectSchedule(schedule),
                onEdit: () => widget.onEdit(schedule),
                onDelete: () => widget.onDelete(schedule),
                onToggle: (value) => widget.onToggle(schedule, value),
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectSchedule(Schedule schedule) {
    setState(() {
      _selectedSchedule = _selectedSchedule?.id == schedule.id
          ? null
          : schedule;
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _moveFocus(1);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _moveFocus(-1);
    } else if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      _activateCurrentItem();
    } else if (event.logicalKey == LogicalKeyboardKey.delete) {
      _deleteCurrentItem();
    } else if (event.logicalKey == LogicalKeyboardKey.keyE &&
        HardwareKeyboard.instance.isControlPressed) {
      _editCurrentItem();
    }
  }

  void _moveFocus(int delta) {
    setState(() {
      _focusedIndex = (_focusedIndex + delta)
          .clamp(0, widget.schedules.length - 1);
    });
  }

  void _activateCurrentItem() {
    if (_focusedIndex >= 0 && _focusedIndex < widget.schedules.length) {
      final schedule = widget.schedules[_focusedIndex];
      widget.onToggle(schedule, !schedule.isActive);
    }
  }

  void _deleteCurrentItem() {
    if (_focusedIndex >= 0 && _focusedIndex < widget.schedules.length) {
      widget.onDelete(widget.schedules[_focusedIndex]);
    }
  }

  void _editCurrentItem() {
    if (_focusedIndex >= 0 && _focusedIndex < widget.schedules.length) {
      widget.onEdit(widget.schedules[_focusedIndex]);
    }
  }
}