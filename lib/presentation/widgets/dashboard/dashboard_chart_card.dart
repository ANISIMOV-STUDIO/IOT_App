/// Dashboard Chart Card Widget
///
/// Responsive chart card for dashboard metrics visualization
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
class DashboardChartCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget chart;
  final VoidCallback? onTap;

  const DashboardChartCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.chart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(HvacSpacing.lgR),
        decoration: HvacTheme.deviceCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: HvacColors.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: HvacSpacing.xxsR),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: HvacColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.chevron_right,
                    color: HvacColors.textTertiary,
                    size: 20.sp,
                  ),
              ],
            ),
            const SizedBox(height: HvacSpacing.lgR),
            chart,
          ],
        ),
      ),
    );
  }
}
