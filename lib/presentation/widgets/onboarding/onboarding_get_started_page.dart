/// Onboarding Get Started Page Widget
///
/// Final page of the onboarding with CTA
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Get started page widget for onboarding
class OnboardingGetStartedPage extends StatelessWidget {
  /// Whether to use compact sizing
  final bool isCompact;

  /// Callback when get started is pressed
  final VoidCallback onGetStarted;

  const OnboardingGetStartedPage({
    super.key,
    required this.isCompact,
    required this.onGetStarted,
  });

  void _handleGetStarted() {
    HapticFeedback.mediumImpact();
    onGetStarted();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HvacColors.primaryOrange.withValues(alpha: 0.1),
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
                      color: HvacColors.success.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: HvacColors.success.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: isCompact ? 50 : 70,
                      color: HvacColors.success,
                    ),
                  ),
                  SizedBox(height: isCompact ? 30 : 50),

                  // Title
                  Text(
                    l10n.readyToGetStarted,
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
                    l10n.startControllingClimate,
                    style: TextStyle(
                      fontSize: isCompact ? 14 : 16,
                      color: HvacColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isCompact ? 40 : 60),

                  // Get Started Button
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: HvacInteractiveScale(
                      scaleDown: 0.98,
                      child: HvacNeumorphicButton(
                        onPressed: _handleGetStarted,
                        width: double.infinity,
                        height: isCompact ? 52 : 56,
                        borderRadius: 30,
                        color: HvacColors.primaryOrange,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.getStarted,
                              style: TextStyle(
                                fontSize: isCompact ? 15 : 17,
                                fontWeight: FontWeight.bold,
                                color: HvacColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.arrow_forward,
                              color: HvacColors.textPrimary,
                              size: isCompact ? 18 : 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isCompact ? 20 : 30),

                  // Terms & Privacy
                  Text(
                    l10n.termsPrivacyAgreement,
                    style: TextStyle(
                      fontSize: isCompact ? 10 : 11,
                      color: HvacColors.textSecondary.withValues(alpha: 0.6),
                      height: 1.5,
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
