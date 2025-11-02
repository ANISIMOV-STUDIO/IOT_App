/// Device Stat Item Widget
///
/// Responsive stat display for device cards
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';

class DeviceStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DeviceStatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: AppTheme.textSecondary,
            ),
            SizedBox(width: AppSpacing.xxsR),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xxsR),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }
}
