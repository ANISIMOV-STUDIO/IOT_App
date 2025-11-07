/// Analytics Summary Card Widget
///
/// Animated summary card for displaying analytics metrics
/// Extracted from analytics_screen.dart to respect 300-line limit
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class AnalyticsSummaryCard extends StatelessWidget {
  final int index;
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String change;

  const AnalyticsSummaryCard({
    super.key,
    required this.index,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change.startsWith('+');

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animValue),
          child: Opacity(
            opacity: animValue,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(HvacSpacing.mdR),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.mdR),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18.0),
                const SizedBox(width: HvacSpacing.xsR),
                Expanded(
                  child: Text(
                    label,
                    style: HvacTypography.captionSmall.copyWith(
                      color: HvacColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: HvacSpacing.xsR),
            Text(
              value,
              style: HvacTypography.titleLarge.copyWith(
                color: color,
              ),
            ),
            const SizedBox(height: HvacSpacing.xxsR),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12.0,
                  color: isPositive ? HvacColors.success : HvacColors.error,
                ),
                const SizedBox(width: HvacSpacing.xxsR),
                Text(
                  change,
                  style: HvacTypography.captionSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isPositive ? HvacColors.success : HvacColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
