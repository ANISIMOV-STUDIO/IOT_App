/// Schedule action buttons with web-friendly hover states
///
/// Provides edit and delete action buttons for schedule management
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'schedule_model.dart';

class ScheduleActionButtons extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double iconSize;
  final double minTouchTarget;

  const ScheduleActionButtons({
    super.key,
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
    this.iconSize = 20,
    this.minTouchTarget = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit button with hover effect for web
        _WebFriendlyIconButton(
          onPressed: onEdit,
          icon: Icons.edit,
          semanticLabel: 'Edit ${schedule.name}',
          tooltip: 'Edit schedule',
          size: iconSize.sp,
          minTouchTarget: minTouchTarget,
          color: HvacColors.textSecondary,
          hoverColor: HvacColors.primaryOrange,
        ),
        SizedBox(width: HvacSpacing.xs.w),
        // Delete button with hover effect for web
        _WebFriendlyIconButton(
          onPressed: onDelete,
          icon: Icons.delete,
          semanticLabel: 'Delete ${schedule.name}',
          tooltip: 'Delete schedule',
          size: iconSize.sp,
          minTouchTarget: minTouchTarget,
          color: HvacColors.textSecondary,
          hoverColor: HvacColors.error,
        ),
      ],
    );
  }
}

/// Icon button with web-friendly hover states and cursor management
class _WebFriendlyIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String semanticLabel;
  final String tooltip;
  final double size;
  final double minTouchTarget;
  final Color color;
  final Color hoverColor;

  const _WebFriendlyIconButton({
    required this.onPressed,
    required this.icon,
    required this.semanticLabel,
    required this.tooltip,
    required this.size,
    required this.minTouchTarget,
    required this.color,
    required this.hoverColor,
  });

  @override
  State<_WebFriendlyIconButton> createState() => _WebFriendlyIconButtonState();
}

class _WebFriendlyIconButtonState extends State<_WebFriendlyIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      button: true,
      child: Tooltip(
        message: widget.tooltip,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              width: widget.minTouchTarget.w,
              height: widget.minTouchTarget.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(HvacSpacing.xs.r),
                color: _isHovered
                    ? widget.hoverColor.withValues(alpha: 0.1)
                    : Colors.transparent,
              ),
              child: AnimatedScale(
                scale: _isHovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  widget.icon,
                  size: widget.size,
                  color: _isHovered ? widget.hoverColor : widget.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}