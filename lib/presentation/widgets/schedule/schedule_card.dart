/// Schedule card widget with web-friendly interactions
///
/// Displays individual schedule information with responsive design
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'schedule_model.dart';
import 'schedule_card_layouts.dart';

class ScheduleCard extends StatefulWidget {
  final Schedule schedule;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.schedule.semanticLabel,
      hint: 'Double tap to select, triple tap for options',
      selected: widget.isSelected,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.diagonal3Values(
            _isHovered ? 1.01 : 1.0,
            _isHovered ? 1.01 : 1.0,
            1.0,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onTap();
              },
              borderRadius: BorderRadius.circular(HvacSpacing.md.r),
              child: Container(
                padding: EdgeInsets.all(HvacSpacing.md.w),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.circular(HvacSpacing.md.r),
                  border: Border.all(
                    color: _getBorderColor(),
                    width: 2,
                  ),
                  boxShadow: _getBoxShadow(),
                ),
                child: AdaptiveControl(
                  builder: (context, deviceSize) {
                    switch (deviceSize) {
                      case DeviceSize.compact:
                        return ScheduleCardMobileLayout(
                          schedule: widget.schedule,
                          onEdit: widget.onEdit,
                          onDelete: widget.onDelete,
                          onToggle: widget.onToggle,
                        );
                      case DeviceSize.medium:
                      case DeviceSize.expanded:
                        return ScheduleCardTabletLayout(
                          schedule: widget.schedule,
                          onEdit: widget.onEdit,
                          onDelete: widget.onDelete,
                          onToggle: widget.onToggle,
                        );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (widget.isSelected) {
      return HvacColors.primaryOrange.withValues(alpha: 0.1);
    }
    if (_isHovered) {
      return HvacColors.cardDark.withValues(alpha: 0.9);
    }
    return HvacColors.cardDark;
  }

  Color _getBorderColor() {
    if (widget.isSelected) {
      return HvacColors.primaryOrange;
    }
    if (_isHovered) {
      return HvacColors.primaryOrange.withValues(alpha: 0.3);
    }
    return HvacColors.cardDark;
  }

  List<BoxShadow>? _getBoxShadow() {
    if (_isHovered) {
      return [
        BoxShadow(
          color: HvacColors.primaryOrange.withValues(alpha: 0.1),
          blurRadius: 8.r,
          offset: Offset(0, 2.h),
        ),
      ];
    }
    return null;
  }
}