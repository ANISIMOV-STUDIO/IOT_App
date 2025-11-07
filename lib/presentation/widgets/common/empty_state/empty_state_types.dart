/// Empty State Types
///
/// Enumeration and type-specific logic for empty states
library;

import 'package:flutter/material.dart';

/// Types of empty states
enum EmptyStateType {
  general,
  noDevices,
  noSchedules,
  noData,
  noNotifications,
  noSearchResults,
  noConnection,
}

/// Extension methods for empty state types
extension EmptyStateTypeExtension on EmptyStateType {
  /// Get default icon for this type
  IconData get defaultIcon {
    switch (this) {
      case EmptyStateType.noDevices:
        return Icons.devices_other_rounded;
      case EmptyStateType.noSchedules:
        return Icons.schedule_rounded;
      case EmptyStateType.noData:
        return Icons.analytics_outlined;
      case EmptyStateType.noNotifications:
        return Icons.notifications_none_rounded;
      case EmptyStateType.noSearchResults:
        return Icons.search_off_rounded;
      case EmptyStateType.noConnection:
        return Icons.wifi_off_rounded;
      case EmptyStateType.general:
        return Icons.inbox_rounded;
    }
  }

  /// Get action icon for this type
  IconData get actionIcon {
    switch (this) {
      case EmptyStateType.noDevices:
        return Icons.add_rounded;
      case EmptyStateType.noSchedules:
        return Icons.add_alarm_rounded;
      case EmptyStateType.noData:
        return Icons.refresh_rounded;
      case EmptyStateType.noSearchResults:
        return Icons.clear_rounded;
      case EmptyStateType.noConnection:
        return Icons.refresh_rounded;
      case EmptyStateType.general:
      case EmptyStateType.noNotifications:
        return Icons.arrow_forward_rounded;
    }
  }

  /// Get color for this type
  Color getColor(ThemeData theme) {
    switch (this) {
      case EmptyStateType.noDevices:
        return Colors.blue;
      case EmptyStateType.noSchedules:
        return Colors.orange;
      case EmptyStateType.noData:
        return Colors.purple;
      case EmptyStateType.noNotifications:
        return Colors.green;
      case EmptyStateType.noSearchResults:
        return Colors.grey;
      case EmptyStateType.noConnection:
        return Colors.red;
      case EmptyStateType.general:
        return theme.colorScheme.primary;
    }
  }
}
