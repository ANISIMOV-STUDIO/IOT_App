/// Home Notifications Panel Widget
/// Displays alerts, warnings, and info messages grouped by severity
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import 'notifications/notification_types.dart';
import 'notifications/notification_item.dart';
import 'notifications/notification_badge.dart';
import 'notifications/notification_empty_state.dart';
import 'notifications/notification_grouper.dart';

/// Main notifications panel widget
class HomeNotificationsPanel extends StatefulWidget {
  final HvacUnit unit;

  const HomeNotificationsPanel({
    super.key,
    required this.unit,
  });

  @override
  State<HomeNotificationsPanel> createState() =>
      _HomeNotificationsPanelState();
}

class _HomeNotificationsPanelState extends State<HomeNotificationsPanel> {
  bool _showAllNotifications = false;
  late NotificationGrouper _grouper;

  @override
  void initState() {
    super.initState();
    _grouper = NotificationGrouper(unit: widget.unit);
  }

  @override
  void didUpdateWidget(HomeNotificationsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.unit != widget.unit) {
      _grouper = NotificationGrouper(unit: widget.unit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groups = _grouper.groupNotifications();
    final totalCount = _grouper.getTotalCount();

    return Container(
      height: 400.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.lgRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
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
          if (totalCount > 0) _buildCategoryBadges(groups),

          if (totalCount > 0) SizedBox(height: 20.h),

          // Notifications list
          Expanded(
            child: totalCount == 0
                ? const NotificationEmptyState()
                : _buildNotificationsList(),
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
            color: HvacColors.textPrimary,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: HvacColors.primaryOrange.withValues(alpha: 0.2),
            borderRadius: HvacRadius.mdRadius,
          ),
          child: Text(
            '$totalCount',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: HvacColors.primaryOrange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBadges(
      Map<NotificationSeverity, List<ActivityItem>> groups) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        if (groups[NotificationSeverity.critical]!.isNotEmpty)
          NotificationBadge(
            label: 'Критические',
            count: groups[NotificationSeverity.critical]!.length,
            color: HvacColors.error,
          ),
        if (groups[NotificationSeverity.error]!.isNotEmpty)
          NotificationBadge(
            label: 'Ошибки',
            count: groups[NotificationSeverity.error]!.length,
            color: HvacColors.error,
          ),
        if (groups[NotificationSeverity.warning]!.isNotEmpty)
          NotificationBadge(
            label: 'Предупреждения',
            count: groups[NotificationSeverity.warning]!.length,
            color: HvacColors.warning,
          ),
        if (groups[NotificationSeverity.info]!.isNotEmpty)
          NotificationBadge(
            label: 'Инфо',
            count: groups[NotificationSeverity.info]!.length,
            color: HvacColors.info,
          ),
      ],
    );
  }

  Widget _buildNotificationsList() {
    final items = _grouper.getAllNotifications(
      limit: _showAllNotifications ? null : 3,
    );

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => NotificationItem(
        activity: items[index],
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
                      ? HvacColors.textSecondary
                      : HvacColors.primaryOrange,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                _showAllNotifications ? Icons.expand_less : Icons.expand_more,
                color: _showAllNotifications
                    ? HvacColors.textSecondary
                    : HvacColors.primaryOrange,
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}