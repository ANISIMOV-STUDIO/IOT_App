/// Notification Grouper Component
/// Logic for grouping and organizing notifications
library;

import 'package:flutter/material.dart';
import '../../../../domain/entities/hvac_unit.dart';
import '../../../../domain/entities/ventilation_mode.dart';
import 'notification_types.dart';

/// Groups and organizes notifications
class NotificationGrouper {
  final HvacUnit unit;

  const NotificationGrouper({required this.unit});

  /// Group all notifications by severity
  Map<NotificationSeverity, List<ActivityItem>> groupNotifications() {
    final now = DateTime.now();
    final groups = <NotificationSeverity, List<ActivityItem>>{
      NotificationSeverity.critical: [],
      NotificationSeverity.error: [],
      NotificationSeverity.warning: [],
      NotificationSeverity.info: [],
    };

    // Add alert notifications
    if (unit.alerts != null && unit.alerts!.isNotEmpty) {
      for (final alert in unit.alerts!) {
        if (alert.code != 0) {
          final severity = NotificationUtils.mapAlertSeverity(alert.severity);
          final activity = ActivityItem(
            time: alert.timestamp != null
                ? '${alert.timestamp!.hour.toString().padLeft(2, '0')}:${alert.timestamp!.minute.toString().padLeft(2, '0')}'
                : '--:--',
            title: 'Авария: код ${alert.code}',
            description: alert.description,
            severity: severity,
            icon: NotificationUtils.getSeverityIcon(severity),
          );

          groups[severity]!.add(activity);
        }
      }
    }

    // Add operational info
    if (unit.power) {
      groups[NotificationSeverity.info]!.add(
        ActivityItem(
          time:
              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
          title: '${unit.name} работает',
          description: 'Режим: ${unit.ventMode?.displayName ?? "Авто"}',
          severity: NotificationSeverity.info,
          icon: Icons.power_settings_new,
        ),
      );
    }

    // Add schedule info
    final todaySchedule = unit.schedule?.getDaySchedule(now.weekday);
    if (todaySchedule != null && todaySchedule.timerEnabled) {
      if (todaySchedule.turnOnTime != null) {
        groups[NotificationSeverity.info]!.add(
          ActivityItem(
            time:
                '${todaySchedule.turnOnTime!.hour.toString().padLeft(2, '0')}:${todaySchedule.turnOnTime!.minute.toString().padLeft(2, '0')}',
            title: 'Запланированное включение',
            description: 'Автоматический запуск по расписанию',
            severity: NotificationSeverity.info,
            icon: Icons.schedule,
          ),
        );
      }
    }

    return groups;
  }

  /// Get all notifications in priority order
  List<ActivityItem> getAllNotifications({int? limit}) {
    final groups = groupNotifications();
    final items = <ActivityItem>[];

    // Add in priority order
    items.addAll(groups[NotificationSeverity.critical]!);
    items.addAll(groups[NotificationSeverity.error]!);
    items.addAll(groups[NotificationSeverity.warning]!);
    items.addAll(groups[NotificationSeverity.info]!);

    if (limit != null && items.length > limit) {
      return items.sublist(0, limit);
    }

    return items;
  }

  /// Get total notification count
  int getTotalCount() {
    final groups = groupNotifications();
    return groups.values.fold(0, (sum, list) => sum + list.length);
  }
}