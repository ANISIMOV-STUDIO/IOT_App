/// Notification Empty State Component
/// Empty state for no notifications
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Empty state widget for notifications
class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 48.sp,
            color: HvacColors.textSecondary.withValues(alpha: 0.5),
          ),
          SizedBox(height: 12.h),
          Text(
            'Нет уведомлений',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: HvacColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Все системы работают нормально',
            style: TextStyle(
              fontSize: 12.sp,
              color: HvacColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}