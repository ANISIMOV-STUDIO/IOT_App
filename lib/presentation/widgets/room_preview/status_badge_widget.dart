/// Status Badge Widget
///
/// Badge component for displaying room status indicators
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Data model for status badge
class StatusBadge {
  final IconData icon;
  final String value;

  const StatusBadge({
    required this.icon,
    required this.value,
  });
}

/// Widget for displaying status badges
class StatusBadgeWidget extends StatelessWidget {
  final StatusBadge badge;

  const StatusBadgeWidget({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return HvacInteractiveScale(
      scaleDown: 0.92,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 6.0 : 10.0,
          vertical: isMobile ? 4.0 : 6.0,
        ),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard.withValues(alpha: 0.95),
          borderRadius: HvacRadius.smRadius,
          border: Border.all(
            color: HvacColors.primaryOrange.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: HvacColors.textSecondary.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HvacIconHero(
              tag: 'badge_${badge.icon}_${badge.value}',
              icon: badge.icon,
              size: isMobile ? 12.0 : 14.0,
              color: HvacColors.primaryOrange,
            ),
            const SizedBox(width: 3.0),
            HvacTemperatureHero(
              tag: 'badgeValue_${badge.value}',
              temperature: badge.value,
              style: TextStyle(
                fontSize: isMobile ? 11.0 : 12.0,
                fontWeight: FontWeight.w600,
                color: HvacColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
