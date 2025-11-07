/// Settings Section Widget
///
/// Reusable section container for settings groups
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Section widget for settings groups
class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return HvacGradientBorder(
      borderWidth: 2.0,
      gradientColors: [
        HvacColors.primaryOrange.withValues(alpha: 0.3),
        HvacColors.primaryBlue.withValues(alpha: 0.3),
      ],
      borderRadius: HvacRadius.lgRadius,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: HvacRadius.lgRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: HvacColors.primaryOrange, size: 24.0),
                const SizedBox(width: 12.0),
                Text(
                  title,
                  style: HvacTypography.headlineSmall.copyWith(
                    fontSize: 18.0,
                    color: HvacColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ...children,
          ],
        ),
      ),
    );
  }
}
