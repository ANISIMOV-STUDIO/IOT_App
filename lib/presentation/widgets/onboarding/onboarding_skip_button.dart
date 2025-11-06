/// Onboarding Skip Button Widget
///
/// Skip button component for onboarding navigation
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// A skip button widget for onboarding
class OnboardingSkipButton extends StatelessWidget {
  /// Callback when skip is pressed
  final VoidCallback onSkip;

  /// The text to display
  final String skipText;

  const OnboardingSkipButton({
    super.key,
    required this.onSkip,
    required this.skipText,
  });

  void _handleSkip() {
    HapticFeedback.lightImpact();
    onSkip();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 20,
      child: SafeArea(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: HvacInteractiveScale(
            scaleDown: 0.95,
            child: TextButton(
              onPressed: _handleSkip,
              style: TextButton.styleFrom(
                foregroundColor: HvacColors.textSecondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                skipText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}