/// Stat Item Widget - displays a statistic with icon, value and label
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';

// =============================================================================
// WIDGET
// =============================================================================

/// Stat display item with icon, value, and label
class StatItem extends StatelessWidget {

  const StatItem({
    required this.icon,
    required this.value,
    required this.label,
    super.key,
    this.iconColor,
  });
  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Semantics(
      label: '$label: $value',
      child: Column(
        children: [
          Icon(
            icon,
            size: AppIconSizes.standard,
            color: iconColor ?? colors.accent,
          ),
          const SizedBox(height: AppSpacing.xxs + 2), // 6px
          Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs / 2), // 2px
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.tiny,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
