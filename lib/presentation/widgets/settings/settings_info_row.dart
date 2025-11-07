/// Settings Info Row
///
/// Label-value row for displaying information
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Info row widget for displaying label-value pairs
class SettingsInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const SettingsInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: HvacTypography.bodyMedium.copyWith(
            fontSize: 14.0,
            color: HvacColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: HvacTypography.titleMedium.copyWith(
            fontSize: 14.0,
            color: HvacColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
