/// About Settings Section
///
/// App information and updates
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'settings_section.dart';

class AboutSection extends StatelessWidget {
  final VoidCallback onCheckUpdates;

  const AboutSection({
    super.key,
    required this.onCheckUpdates,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SettingsSection(
      title: l10n.about,
      icon: Icons.info_outline,
      children: [
        HvacInteractiveRipple(
          child: InfoRow(
            label: l10n.version,
            value: '1.0.0',
          ),
        ),
        SizedBox(height: 12.h),
        HvacInteractiveRipple(
          child: InfoRow(
            label: l10n.developer,
            value: 'BREEZ',
          ),
        ),
        SizedBox(height: 12.h),
        HvacInteractiveRipple(
          child: InfoRow(
            label: l10n.license,
            value: 'MIT License',
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          height: 48.h, // Ensure minimum tap target
          child: HvacNeumorphicButton(
            onPressed: onCheckUpdates,
            child: Text(
              l10n.checkUpdates,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: HvacColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}