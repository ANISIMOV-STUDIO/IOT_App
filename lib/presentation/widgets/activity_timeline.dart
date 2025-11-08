/// Activity Timeline Widget
///
/// Shows recent device activities
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class ActivityTimeline extends StatelessWidget {
  final List<ActivityItem> activities;
  final VoidCallback? onSeeAll;

  const ActivityTimeline({
    super.key,
    required this.activities,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.xlR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.xlRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity',
                    style: HvacTypography.headlineSmall,
                  ),
                  const SizedBox(height: HvacSpacing.xxs),
                  Text(
                    'December 12, 2024',
                    style: HvacTypography.labelLarge.copyWith(
                      color: HvacColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (onSeeAll != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HvacTextButton(
                      label: 'See All',
                      onPressed: onSeeAll,
                    ),
                    const SizedBox(width: HvacSpacing.xxs),
                    const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: HvacColors.textSecondary,
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: HvacSpacing.lg),

          // Activity items
          ...activities.map((activity) => _buildActivityItem(activity)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HvacSpacing.xlR),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time
          SizedBox(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.time,
                  style: HvacTypography.titleMedium,
                ),
                Text(
                  'AM',
                  style: HvacTypography.labelLarge.copyWith(
                    color: HvacColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: HvacSpacing.md),

          // Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(HvacSpacing.lgR),
              decoration: BoxDecoration(
                color: HvacColors.backgroundDark,
                borderRadius: HvacRadius.mdRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: HvacTypography.titleMedium,
                  ),
                  const SizedBox(height: HvacSpacing.xxs),
                  Text(
                    activity.description,
                    style: HvacTypography.labelLarge.copyWith(
                      color: HvacColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
    this.severity = NotificationSeverity.info,
    this.icon,
  });
}

enum NotificationSeverity {
  critical,
  error,
  warning,
  info,
}
