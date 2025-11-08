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
    return HvacSwitch(
      value: value,
      onChanged: onChanged,
      label: title,
      subtitle: subtitle,
    );
  }
}
