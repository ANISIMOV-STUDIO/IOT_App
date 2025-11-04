/// Dashboard Alert Item Widget
///
/// Alert/notification item for dashboard
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
enum AlertSeverity { critical, warning, info }

class DashboardAlertItem extends StatelessWidget {
  final String title;
  final String message;
  final String timestamp;
  final AlertSeverity severity;
  final VoidCallback? onTap;

  const DashboardAlertItem({
    super.key,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.severity,
    this.onTap,
  });

  Color get _severityColor {
    switch (severity) {
      case AlertSeverity.critical:
        return HvacColors.error;
      case AlertSeverity.warning:
        return HvacColors.warning;
      case AlertSeverity.info:
        return HvacColors.info;
    }
  }

  IconData get _severityIcon {
    switch (severity) {
      case AlertSeverity.critical:
        return Icons.error;
      case AlertSeverity.warning:
        return Icons.warning;
      case AlertSeverity.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: HvacRadius.mdRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.md, vertical: HvacSpacing.sm),
        child: Row(
          children: [
            // Severity Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _severityColor.withValues(alpha: 0.15),
                borderRadius: HvacRadius.smRadius,
              ),
              child: Icon(
                _severityIcon,
                color: _severityColor,
                size: 20,
              ),
            ),
            const SizedBox(width: HvacSpacing.sm),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: HvacSpacing.xxs),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: HvacColors.textSecondary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Timestamp
            Text(
              timestamp,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: HvacColors.textTertiary,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
