/// Dashboard Alert Item Widget
///
/// Alert/notification item for dashboard
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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
        return AppTheme.error;
      case AlertSeverity.warning:
        return AppTheme.warning;
      case AlertSeverity.info:
        return AppTheme.info;
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
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Severity Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _severityColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _severityIcon,
                color: _severityColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

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
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
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
                    color: AppTheme.textTertiary,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
