/// Schedule Edit Button Component
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Schedule edit button
class ScheduleEditButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ScheduleEditButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: HvacOutlineButton(
        label: l10n.configureSchedule,
        onPressed: onPressed,
      ),
    );
  }
}