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
      height: 400.0,
      padding: const EdgeInsets.all(20.0),
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

          const SizedBox(height: 16.0),

          // Category badges
          if (totalCount > 0) _buildCategoryBadges(groups),

          if (totalCount > 0) const SizedBox(height: 20.0),

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
        const Text(
          'Уведомления',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: HvacColors.primaryOrange.withValues(alpha: 0.2),
            borderRadius: HvacRadius.mdRadius,
          ),
          child: Text(
            '$totalCount',
            style: const TextStyle(
              fontSize: 12.0,
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
      spacing: 8.0,
      runSpacing: 8.0,
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
      padding: const EdgeInsets.only(top: 12.0),
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
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4.0),
              Icon(
                _showAllNotifications ? Icons.expand_less : Icons.expand_more,
                color: _showAllNotifications
                    ? HvacColors.textSecondary
                    : HvacColors.primaryOrange,
                size: 18.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}