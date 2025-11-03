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
              size: 16.sp,
              color: HvacColors.textSecondary,
            ),
            const SizedBox(width: HvacSpacing.xxsR),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: HvacColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: HvacSpacing.xxsR),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: HvacColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
