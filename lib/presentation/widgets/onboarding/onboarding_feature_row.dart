/// Onboarding Feature Row Widget
///
/// Reusable feature row component for onboarding pages
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// A feature row widget displaying an icon and text description
class OnboardingFeatureRow extends StatelessWidget {
  /// The icon to display
  final IconData icon;

  /// The feature description text
  final String text;

  /// Whether to use compact sizing
  final bool isCompact;

  const OnboardingFeatureRow({
    super.key,
    required this.icon,
    required this.text,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isCompact ? 40 : 48,
            height: isCompact ? 40 : 48,
            decoration: BoxDecoration(
              color: HvacColors.primaryOrange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: HvacColors.primaryOrange,
              size: isCompact ? 20 : 24,
            ),
          ),
          SizedBox(width: isCompact ? 12 : 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isCompact ? 14 : 16,
                color: HvacColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
