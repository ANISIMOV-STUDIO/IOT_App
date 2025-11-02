/// Dashboard Chart Card Widget
///
/// Responsive chart card for dashboard metrics visualization
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';

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
        padding: EdgeInsets.all(AppSpacing.lgR),
        decoration: AppTheme.deviceCard(),
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
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: AppSpacing.xxsR),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.chevron_right,
                    color: AppTheme.textTertiary,
                    size: 20.sp,
                  ),
              ],
            ),
            SizedBox(height: AppSpacing.lgR),
            chart,
          ],
        ),
      ),
    );
  }
}
