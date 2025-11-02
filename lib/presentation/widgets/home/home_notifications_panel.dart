/// Home Notifications Panel Widget
///
/// Displays alerts, warnings, and info messages grouped by severity
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/alert.dart';
import '../../../domain/entities/ventilation_mode.dart';
import '../activity_timeline.dart';

class HomeNotificationsPanel extends StatefulWidget {
  final HvacUnit unit;

  const HomeNotificationsPanel({
    super.key,
    required this.unit,
  });

  @override
  State<HomeNotificationsPanel> createState() => _HomeNotificationsPanelState();
}

class _HomeNotificationsPanelState extends State<HomeNotificationsPanel> {
  bool _showAllNotifications = false;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Group notifications by severity
    final critical = <ActivityItem>[];
    final errors = <ActivityItem>[];
    final warnings = <ActivityItem>[];
    final info = <ActivityItem>[];

    // Add alert notifications
    if (widget.unit.alerts != null && widget.unit.alerts!.isNotEmpty) {
      for (final alert in widget.unit.alerts!) {
        if (alert.code != 0) {
          final severity = _mapAlertSeverityToNotification(alert.severity);
          final activity = ActivityItem(
            time: alert.timestamp != null
                ? '${alert.timestamp!.hour.toString().padLeft(2, '0')}:${alert.timestamp!.minute.toString().padLeft(2, '0')}'
                : '--:--',
            title: 'Авария: код ${alert.code}',
            description: alert.description,
            severity: severity,
            icon: _getSeverityIcon(severity),
          );

          switch (severity) {
            case NotificationSeverity.critical:
              critical.add(activity);
              break;
            case NotificationSeverity.error:
              errors.add(activity);
              break;
            case NotificationSeverity.warning:
              warnings.add(activity);
              break;
            case NotificationSeverity.info:
              info.add(activity);
              break;
          }
        }
      }
    }

    // Add operational info
    if (widget.unit.power) {
      info.add(ActivityItem(
        time:
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        title: '${widget.unit.name} работает',
        description: 'Режим: ${widget.unit.ventMode?.displayName ?? "Авто"}',
        severity: NotificationSeverity.info,
        icon: Icons.power_settings_new,
      ));
    }

    // Add schedule info
    final todaySchedule = widget.unit.schedule?.getDaySchedule(now.weekday);
    if (todaySchedule != null && todaySchedule.timerEnabled) {
      if (todaySchedule.turnOnTime != null) {
        info.add(ActivityItem(
          time:
              '${todaySchedule.turnOnTime!.hour.toString().padLeft(2, '0')}:${todaySchedule.turnOnTime!.minute.toString().padLeft(2, '0')}',
          title: 'Запланированное включение',
          description: 'Автоматический запуск по расписанию',
          severity: NotificationSeverity.info,
          icon: Icons.schedule,
        ));
      }
    }

    final totalCount =
        critical.length + errors.length + warnings.length + info.length;

    return Container(
      height: 400.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(totalCount),

          SizedBox(height: 16.h),

          // Category badges
          if (totalCount > 0) _buildCategoryBadges(critical, errors, warnings, info),

          if (totalCount > 0) SizedBox(height: 20.h),

          // Notifications list
          Expanded(
            child: totalCount == 0
                ? _buildEmptyState()
                : _buildNotificationsList(critical, errors, warnings, info),
          ),

          // Show all/collapse button
          if (totalCount > 3) _buildToggleButton(totalCount),
        ],
      ),
    );
  }

  Widget _buildHeader(int totalCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Уведомления',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppTheme.primaryOrange.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            '$totalCount',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryOrange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBadges(
    List<ActivityItem> critical,
    List<ActivityItem> errors,
    List<ActivityItem> warnings,
    List<ActivityItem> info,
  ) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        if (critical.isNotEmpty)
          _buildCategoryBadge('Критические', critical.length, AppTheme.error),
        if (errors.isNotEmpty)
          _buildCategoryBadge(
              'Ошибки', errors.length, const Color(0xFFE57373)),
        if (warnings.isNotEmpty)
          _buildCategoryBadge('Предупреждения', warnings.length, AppTheme.warning),
        if (info.isNotEmpty)
          _buildCategoryBadge('Инфо', info.length, AppTheme.info),
      ],
    );
  }

  Widget _buildCategoryBadge(String label, int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            '$label: $count',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(
    List<ActivityItem> critical,
    List<ActivityItem> errors,
    List<ActivityItem> warnings,
    List<ActivityItem> info,
  ) {
    final maxItems = _showAllNotifications ? 1000 : 3;
    final items = <ActivityItem>[];
    int itemCount = 0;

    // Add in priority order
    for (final activity in critical) {
      if (itemCount >= maxItems) break;
      items.add(activity);
      itemCount++;
    }
    for (final activity in errors) {
      if (itemCount >= maxItems) break;
      items.add(activity);
      itemCount++;
    }
    for (final activity in warnings) {
      if (itemCount >= maxItems) break;
      items.add(activity);
      itemCount++;
    }
    for (final activity in info) {
      if (itemCount >= maxItems) break;
      items.add(activity);
      itemCount++;
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => _buildActivityItem(items[index]),
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    final severityColor = _getSeverityColor(activity.severity);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              activity.icon ?? Icons.notifications,
              size: 18.sp,
              color: severityColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      activity.time,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: severityColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 48.sp,
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
          ),
          SizedBox(height: 12.h),
          Text(
            'Нет уведомлений',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Все системы работают нормально',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(int totalCount) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Center(
        child: TextButton(
          onPressed: () {
            setState(() {
              _showAllNotifications = !_showAllNotifications;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _showAllNotifications
                    ? 'Свернуть'
                    : 'Показать все ($totalCount)',
                style: TextStyle(
                  color: _showAllNotifications
                      ? AppTheme.textSecondary
                      : AppTheme.primaryOrange,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                _showAllNotifications
                    ? Icons.expand_less
                    : Icons.expand_more,
                color: _showAllNotifications
                    ? AppTheme.textSecondary
                    : AppTheme.primaryOrange,
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  NotificationSeverity _mapAlertSeverityToNotification(
      AlertSeverity alertSeverity) {
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

  IconData _getSeverityIcon(NotificationSeverity severity) {
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

  Color _getSeverityColor(NotificationSeverity severity) {
    switch (severity) {
      case NotificationSeverity.critical:
        return AppTheme.error;
      case NotificationSeverity.error:
        return const Color(0xFFE57373);
      case NotificationSeverity.warning:
        return AppTheme.warning;
      case NotificationSeverity.info:
        return AppTheme.info;
    }
  }
}
