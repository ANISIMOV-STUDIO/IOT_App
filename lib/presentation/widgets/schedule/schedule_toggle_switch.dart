/// Web-friendly toggle switch for schedule activation
///
/// Provides an accessible switch with proper cursor management for web
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class ScheduleToggleSwitch extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onToggle;
  final String? scheduleName;

  const ScheduleToggleSwitch({
    super.key,
    required this.isActive,
    required this.onToggle,
    this.scheduleName,
  });

  @override
  Widget build(BuildContext context) {
    final label = scheduleName != null
        ? '$scheduleName is ${isActive ? "active" : "inactive"}'
        : isActive
            ? 'Schedule active'
            : 'Schedule inactive';

    return Semantics(
      label: label,
      hint: 'Double tap to toggle',
      toggled: isActive,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Switch(
          value: isActive,
          onChanged: onToggle,
          activeThumbColor: HvacColors.primaryOrange,
          activeTrackColor: HvacColors.primaryOrange.withValues(alpha: 0.3),
          inactiveThumbColor: HvacColors.textSecondary,
          inactiveTrackColor: HvacColors.cardDark,
          trackOutlineColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return HvacColors.primaryOrange;
            }
            return HvacColors.backgroundCard;
          }),
        ),
      ),
    );
  }
}