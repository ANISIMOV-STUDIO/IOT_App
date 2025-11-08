/// Home Quick Actions Panel
///
/// Quick action buttons for desktop layout
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Quick actions panel for desktop home screen
class HomeQuickActionsPanel extends StatelessWidget {
  final VoidCallback onPowerAllOn;
  final VoidCallback onPowerAllOff;

  const HomeQuickActionsPanel({
    super.key,
    required this.onPowerAllOn,
    required this.onPowerAllOff,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quickActions,
            style: HvacTypography.headlineSmall,
          ),
          const SizedBox(height: 16),
          // Quick action buttons
          _QuickActionButton(
            icon: Icons.power_settings_new,
            label: l10n.allOn,
            onPressed: onPowerAllOn,
          ),
          const SizedBox(height: 8),
          _QuickActionButton(
            icon: Icons.power_off,
            label: l10n.allOff,
            onPressed: onPowerAllOff,
          ),
        ],
      ),
    );
  }
}

/// Individual quick action button
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: HvacOutlineButton(
        onPressed: onPressed,
        label: label,
        icon: icon,
      ),
    );
  }
}
