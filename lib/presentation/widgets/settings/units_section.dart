/// Units Settings Section
///
/// Temperature and measurement units configuration
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'settings_section.dart';

class UnitsSection extends StatelessWidget {
  final bool celsius;
  final ValueChanged<bool> onCelsiusChanged;

  const UnitsSection({
    super.key,
    required this.celsius,
    required this.onCelsiusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SettingsSection(
      title: l10n.units,
      icon: Icons.straighten_outlined,
      children: [
        HvacInteractiveRipple(
          child: SwitchTile(
            title: l10n.temperatureUnits,
            subtitle: celsius ? l10n.celsius : l10n.fahrenheit,
            value: celsius,
            onChanged: onCelsiusChanged,
          ),
        ),
      ],
    );
  }
}