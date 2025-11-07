/// Onboarding Welcome Page Widget
///
/// First page of the onboarding experience
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Welcome page widget for onboarding
class OnboardingWelcomePage extends StatelessWidget {
  /// Whether to use compact sizing
  final bool isCompact;

  const OnboardingWelcomePage({
    super.key,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: HvacColors.backgroundDark,
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
                  // Icon with glow effect
                  Container(
                    width: isCompact ? 80 : 120,
                    height: isCompact ? 80 : 120,
                    decoration: BoxDecoration(
                      color: HvacColors.primaryOrange.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              HvacColors.primaryOrange.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.air,
                      size: isCompact ? 50 : 70,
                      color: HvacColors.primaryOrange,
                    ),
                  ),
                  SizedBox(height: isCompact ? 30 : 50),

                  // Title with BREEZ HOME
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: isCompact ? 28 : 36,
                        fontWeight: FontWeight.bold,
                        color: HvacColors.textPrimary,
                        height: 1.2,
                      ),
                      children: const [
                        TextSpan(text: 'Welcome to\n'),
                        TextSpan(
                          text: 'BREEZ ',
                          style: TextStyle(
                            color: HvacColors.primaryOrange,
                          ),
                        ),
                        TextSpan(text: 'HOME'),
                      ],
                    ),
                  ),
                  SizedBox(height: isCompact ? 12 : 20),

                  // Subtitle
                  Text(
                    l10n.smartHomeClimateControl,
                    style: TextStyle(
                      fontSize: isCompact ? 14 : 16,
                      color: HvacColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
