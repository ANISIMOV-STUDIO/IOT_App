/// Appearance Settings Section
///
/// Extracted widget for appearance-related settings
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'settings_section.dart';

class AppearanceSection extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const AppearanceSection({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SettingsSection(
      title: l10n.appearance,
      icon: Icons.palette_outlined,
      children: [
        HvacInteractiveRipple(
          child: SwitchTile(
            title: l10n.darkTheme,
            subtitle: l10n.useDarkColorScheme,
            value: darkMode,
            onChanged: onDarkModeChanged,
          ),
        ),
      ],
    );
  }
}