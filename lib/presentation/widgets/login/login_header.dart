/// Login Header Widget
///
/// Displays logo and welcome text for login screen
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Login header with logo and welcome text
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Logo container
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: HvacColors.primaryGradient,
            borderRadius: BorderRadius.circular(HvacRadius.xxl),
            boxShadow: [
              BoxShadow(
                color: HvacColors.primary.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.air,
            size: 60,
            color: HvacColors.secondary,
          ),
        ),

        const SizedBox(height: HvacSpacing.lg),

        // Welcome text
        Text(
          l10n.welcomeBack,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: HvacColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: HvacSpacing.xs),

        // Subtitle
        Text(
          l10n.loginSubtitle,
          style: const TextStyle(
            fontSize: 16,
            color: HvacColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
