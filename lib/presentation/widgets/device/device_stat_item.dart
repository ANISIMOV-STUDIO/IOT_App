/// Device Stat Item Widget
///
/// Responsive stat display for device cards
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
class DeviceStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DeviceStatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.0,
              color: HvacColors.textSecondary,
            ),
            const SizedBox(width: HvacSpacing.xxsR),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: HvacColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: HvacSpacing.xxsR),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.0,
            color: HvacColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
