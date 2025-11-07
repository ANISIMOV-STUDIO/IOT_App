/// Notifications Settings Section
///
/// Push and email notification preferences
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'settings_section.dart';

class NotificationsSection extends StatelessWidget {
  final bool pushNotifications;
  final bool emailNotifications;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onEmailChanged;

  const NotificationsSection({
    super.key,
    required this.pushNotifications,
    required this.emailNotifications,
    required this.onPushChanged,
    required this.onEmailChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SettingsSection(
      title: l10n.notifications,
      icon: Icons.notifications_outlined,
      children: [
        HvacInteractiveRipple(
          child: SwitchTile(
            title: l10n.pushNotifications,
            subtitle: l10n.receiveInstantNotifications,
            value: pushNotifications,
            onChanged: onPushChanged,
          ),
        ),
        SizedBox(height: 12.h),
        HvacInteractiveRipple(
          child: SwitchTile(
            title: l10n.emailNotifications,
            subtitle: l10n.receiveEmailReports,
            value: emailNotifications,
            onChanged: onEmailChanged,
          ),
        ),
      ],
    );
  }
}