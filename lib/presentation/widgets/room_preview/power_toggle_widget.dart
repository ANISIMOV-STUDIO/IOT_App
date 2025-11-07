/// Power Toggle Widget
///
/// Compact power switch for room preview cards
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Power toggle switch widget
class PowerToggleWidget extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool>? onChanged;

  const PowerToggleWidget({
    super.key,
    required this.isActive,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard.withValues(alpha: 0.95),
        borderRadius: HvacRadius.smRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.power_settings_new : Icons.power_off,
            color: isActive ? HvacColors.success : HvacColors.textSecondary,
            size: 16.0,
          ),
          const SizedBox(width: 6.0),
          SizedBox(
            height: 20.0,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Switch(
                value: isActive,
                onChanged: onChanged,
                activeThumbColor: HvacColors.textPrimary,
                activeTrackColor: HvacColors.success,
                inactiveThumbColor: HvacColors.textSecondary,
                inactiveTrackColor: HvacColors.backgroundCardBorder,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
