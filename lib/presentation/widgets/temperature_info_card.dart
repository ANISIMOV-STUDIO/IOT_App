/// Temperature Info Card Widget
///
/// Small card for displaying temperature values (setpoint, room, outdoor)
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class TemperatureInfoCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  final Color? valueColor;

  const TemperatureInfoCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return HvacCard(
      size: HvacCardSize.medium,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 24,
              color: HvacColors.textSecondary,
            ),
            const SizedBox(height: HvacSpacing.xs),
          ],
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: valueColor ?? HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: HvacSpacing.xxs),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: HvacColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
