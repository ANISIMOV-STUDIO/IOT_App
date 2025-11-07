/// Settings Switch Tile
///
/// Toggle switch row for settings
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Switch tile widget for settings toggles
class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: HvacTypography.titleMedium.copyWith(
                  fontSize: 14.0,
                  color: HvacColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                subtitle,
                style: HvacTypography.labelLarge.copyWith(
                  fontSize: 12.0,
                  color: HvacColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return HvacColors.primaryOrange;
            }
            return null;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (!states.contains(WidgetState.selected)) {
              return HvacColors.textSecondary.withValues(alpha: 0.3);
            }
            return null;
          }),
        ),
      ],
    );
  }
}
