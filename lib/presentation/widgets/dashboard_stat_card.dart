/// Dashboard Stat Card Widget
///
/// Premium stat card for dashboard metrics
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final String? subtitle;
  final String? trend;
  final bool isPositiveTrend;
  final VoidCallback? onTap;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.subtitle,
    this.trend,
    this.isPositiveTrend = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(HvacSpacing.xlR),
        decoration: HvacTheme.deviceCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and trend row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(HvacSpacing.mdR),
                  decoration: HvacDecorations.iconContainer(
                    color: iconColor,
                  ).copyWith(
                    color: iconColor.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: HvacSpacing.smR,
                      vertical: HvacSpacing.xxsR,
                    ),
                    decoration: HvacDecorations.badgeSmall(
                      color: isPositiveTrend
                          ? HvacColors.success
                          : HvacColors.error,
                      filled: false,
                    ).copyWith(
                      color: (isPositiveTrend
                              ? HvacColors.success
                              : HvacColors.error)
                          .withValues(alpha: 0.15),
                      border: null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositiveTrend
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: isPositiveTrend
                              ? HvacColors.success
                              : HvacColors.error,
                          size: 14,
                        ),
                        const SizedBox(width: HvacSpacing.xxs),
                        Text(
                          trend!,
                          style: TextStyle(
                            color: isPositiveTrend
                                ? HvacColors.success
                                : HvacColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: HvacSpacing.md),

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: HvacColors.textSecondary,
                  ),
            ),
            const SizedBox(height: HvacSpacing.xs),

            // Value
            Text(
              value,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                  ),
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: HvacSpacing.xxs),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: HvacColors.textTertiary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
