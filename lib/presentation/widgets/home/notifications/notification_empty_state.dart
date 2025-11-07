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
            size: 48.0,
            color: HvacColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12.0),
          const Text(
            'Нет уведомлений',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: HvacColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4.0),
          const Text(
            'Все системы работают нормально',
            style: TextStyle(
              fontSize: 12.0,
              color: HvacColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
