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
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: HvacColors.backgroundDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(severityColor),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildContent(severityColor),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(Color severityColor) {
    return Container(
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
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
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
            color: HvacColors.textSecondary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}