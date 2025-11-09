/// Onboarding Control Page Widget
///
/// Second page of the onboarding - device control features
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'onboarding_feature_row.dart';

/// Control devices page widget for onboarding
class OnboardingControlPage extends StatelessWidget {
  /// Whether to use compact sizing
  final bool isCompact;

  const OnboardingControlPage({
    super.key,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HvacColors.backgroundDark,
            HvacColors.backgroundDark,
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 24 : 40,
                vertical: isCompact ? 20 : 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    width: isCompact ? 80 : 120,
                    height: isCompact ? 80 : 120,
                    decoration: BoxDecoration(
                      color: HvacColors.primaryBlue.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: HvacColors.primaryBlue.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.devices,
                      size: isCompact ? 50 : 70,
                      color: HvacColors.primaryBlue,
                    ),
                  ),
                  SizedBox(height: isCompact ? 30 : 50),

                  // Title
                  Text(
                    l10n.controlYourDevices,
                    style: TextStyle(
                      fontSize: isCompact ? 28 : 36,
                      fontWeight: FontWeight.bold,
                      color: HvacColors.textPrimary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isCompact ? 12 : 20),

                  // Subtitle
                  Text(
                    l10n.manageHvacSystems,
                    style: TextStyle(
                      fontSize: isCompact ? 14 : 16,
                      color: HvacColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isCompact ? 24 : 40),

                  // Features (compact)
                  OnboardingFeatureRow(
                    icon: Icons.power_settings_new,
                    text: l10n.turnOnOffRemotely,
                    isCompact: isCompact,
                  ),
                  SizedBox(height: isCompact ? 10 : 12),
                  OnboardingFeatureRow(
                    icon: Icons.thermostat,
                    text: 'Adjust temperature',
                    isCompact: isCompact,
                  ),
                  SizedBox(height: isCompact ? 10 : 12),
                  OnboardingFeatureRow(
                    icon: Icons.schedule,
                    text: 'Set schedules',
                    isCompact: isCompact,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
