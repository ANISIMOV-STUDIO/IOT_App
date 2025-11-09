/// Compact temperature tile component
///
/// Reusable tile for displaying temperature values in grid layouts
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Compact temperature tile for grid layouts
class TemperatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final double? value;
  final bool isSecondary;

  const TemperatureTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.smRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: isSecondary ? 12.0 : 14.0,
                color: HvacColors.neutral200,
              ),
              const SizedBox(width: 4.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: isSecondary ? 9.0 : 10.0,
                  color: HvacColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            value != null ? '${value!.toStringAsFixed(1)}°C' : '—',
            style: TextStyle(
              fontSize: isSecondary ? 16.0 : 20.0,
              fontWeight: FontWeight.w600,
              color: value != null
                  ? HvacColors.textPrimary
                  : HvacColors.textDisabled,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
