/// Stat Item Widget - displays a statistic with icon, value and label
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для StatItem
abstract class _StatItemConstants {
  static const double iconSize = 18.0;
  static const double valueFontSize = 12.0;
  static const double labelFontSize = 10.0;
}

// =============================================================================
// WIDGET
// =============================================================================

/// Stat display item with icon, value, and label
class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;

  const StatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Semantics(
      label: '$label: $value',
      child: Column(
        children: [
          Icon(
            icon,
            size: _StatItemConstants.iconSize,
            color: iconColor ?? AppColors.accent,
          ),
          SizedBox(height: AppSpacing.xxs + 2), // 6px
          Text(
            value,
            style: TextStyle(
              fontSize: _StatItemConstants.valueFontSize,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          SizedBox(height: AppSpacing.xxs / 2), // 2px
          Text(
            label,
            style: TextStyle(
              fontSize: _StatItemConstants.labelFontSize,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
