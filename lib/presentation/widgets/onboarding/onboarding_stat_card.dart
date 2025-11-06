/// Onboarding Stat Card Widget
///
/// Reusable statistics card component for onboarding analytics page
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// A compact statistics card widget for displaying metrics
class OnboardingStatCard extends StatelessWidget {
  /// The main value to display
  final String value;

  /// The label describing the value
  final String label;

  /// The icon to display
  final IconData icon;

  /// Whether to use compact sizing
  final bool isCompact;

  /// Icon color
  final Color? iconColor;

  const OnboardingStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.isCompact,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCompact ? 90 : 100,
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor ?? const Color(0xFF9C27B0),
            size: isCompact ? 24 : 32,
          ),
          SizedBox(height: isCompact ? 8 : 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isCompact ? 18 : 24,
              fontWeight: FontWeight.bold,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isCompact ? 10 : 11,
              color: HvacColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}