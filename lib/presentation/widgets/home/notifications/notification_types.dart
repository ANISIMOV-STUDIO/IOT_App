/// Notification Types and Enums
/// Shared types for notification components
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../domain/entities/alert.dart';

/// Notification severity levels
enum NotificationSeverity {
  critical,
  error,
  warning,
  info,
}

/// Activity item data model
class ActivityItem {
  final String time;
  final String title;
  final String description;
  final NotificationSeverity severity;
  final IconData? icon;

  const ActivityItem({
    required this.time,
    required this.title,
    required this.description,
    required this.severity,
    this.icon,
  });
}

/// Notification utilities
class NotificationUtils {
  NotificationUtils._();

  /// Map alert severity to notification severity
  static NotificationSeverity mapAlertSeverity(AlertSeverity alertSeverity) {
    switch (alertSeverity) {
      case AlertSeverity.critical:
        return NotificationSeverity.critical;
      case AlertSeverity.error:
        return NotificationSeverity.error;
      case AlertSeverity.warning:
        return NotificationSeverity.warning;
      case AlertSeverity.info:
        return NotificationSeverity.info;
    }
  }

  /// Get severity icon
  static IconData getSeverityIcon(NotificationSeverity severity) {
    switch (severity) {
      case NotificationSeverity.critical:
        return Icons.error;
      case NotificationSeverity.error:
        return Icons.error_outline;
      case NotificationSeverity.warning:
        return Icons.warning;
      case NotificationSeverity.info:
        return Icons.info_outline;
    }
  }

  /// Get severity color
  static Color getSeverityColor(NotificationSeverity severity) {
    switch (severity) {
      case NotificationSeverity.critical:
        return HvacColors.error;
      case NotificationSeverity.error:
        return HvacColors.error;
      case NotificationSeverity.warning:
        return HvacColors.warning;
      case NotificationSeverity.info:
        return HvacColors.info;
    }
  }
}