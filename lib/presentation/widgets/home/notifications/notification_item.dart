/// Notification Item Component
/// Individual notification card display
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'notification_types.dart';

/// Single notification item widget
class NotificationItem extends StatelessWidget {
  final ActivityItem activity;

  const NotificationItem({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final severityColor = NotificationUtils.getSeverityColor(activity.severity);

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundDark,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(severityColor),
          const SizedBox(width: 12.0),
          Expanded(
            child: _buildContent(severityColor),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(Color severityColor) {
    return Container(
      width: 36.0,
      height: 36.0,
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.15),
        borderRadius: HvacRadius.smRadius,
      ),
      child: Icon(
        activity.icon ?? Icons.notifications,
        size: 18.0,
        color: severityColor,
      ),
    );
  }

  Widget _buildContent(Color severityColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                activity.title,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                ),
              ),
            ),
            Text(
              activity.time,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w500,
                color: severityColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Text(
          activity.description,
          style: const TextStyle(
            fontSize: 12.0,
            color: HvacColors.textSecondary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
