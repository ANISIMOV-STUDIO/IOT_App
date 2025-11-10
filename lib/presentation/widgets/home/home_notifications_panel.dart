/// Home Notifications Panel Widget
/// Displays alerts, warnings, and info messages grouped by severity
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'notifications/notification_types.dart';
import 'notifications/notification_item.dart';
import 'notifications/notification_badge.dart';
import 'notifications/notification_empty_state.dart';
import 'notifications/notification_grouper.dart';

/// Main notifications panel widget with consistent HVAC UI Kit styling
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
    final l10n = AppLocalizations.of(context)!;
    final groups = _grouper.groupNotifications();
    final totalCount = _grouper.getTotalCount();

    return SizedBox(
      height: 400.0,
      child: HvacCard(
        padding: const EdgeInsets.all(HvacSpacing.lg),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(l10n, totalCount),

          const SizedBox(height: HvacSpacing.md),

          // Category badges
          if (totalCount > 0) _buildCategoryBadges(l10n, groups),

          if (totalCount > 0) const SizedBox(height: HvacSpacing.lg),

          // Notifications list
          Expanded(
            child: totalCount == 0
                ? const NotificationEmptyState()
                : _buildNotificationsList(),
          ),

          // Show all/collapse button
          if (totalCount > 3) _buildToggleButton(l10n, totalCount),
        ],
      ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, int totalCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.notifications,
          style: HvacTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.xs,
            vertical: HvacSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: HvacColors.primary.withValues(alpha: 0.2),
            borderRadius: HvacRadius.mdRadius,
          ),
          child: Text(
            '$totalCount',
            style: HvacTypography.labelSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: HvacColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBadges(
    AppLocalizations l10n,
    Map<NotificationSeverity, List<ActivityItem>> groups,
  ) {
    return Wrap(
      spacing: HvacSpacing.xs,
      runSpacing: HvacSpacing.xs,
      children: [
        if (groups[NotificationSeverity.critical]!.isNotEmpty)
          NotificationBadge(
            label: l10n.critical,
            count: groups[NotificationSeverity.critical]!.length,
            color: HvacColors.error,
          ),
        if (groups[NotificationSeverity.error]!.isNotEmpty)
          NotificationBadge(
            label: l10n.errors,
            count: groups[NotificationSeverity.error]!.length,
            color: HvacColors.error,
          ),
        if (groups[NotificationSeverity.warning]!.isNotEmpty)
          NotificationBadge(
            label: l10n.warnings,
            count: groups[NotificationSeverity.warning]!.length,
            color: HvacColors.warning,
          ),
        if (groups[NotificationSeverity.info]!.isNotEmpty)
          NotificationBadge(
            label: l10n.infoLabel,
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

  Widget _buildToggleButton(AppLocalizations l10n, int totalCount) {
    return Padding(
      padding: const EdgeInsets.only(top: HvacSpacing.sm),
      child: Center(
        child: HvacTextButton(
          label: _showAllNotifications
              ? l10n.collapse
              : l10n.showAll(totalCount),
          onPressed: () {
            setState(() {
              _showAllNotifications = !_showAllNotifications;
            });
          },
        ),
      ),
    );
  }
}