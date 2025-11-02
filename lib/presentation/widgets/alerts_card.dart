/// Alerts Card Widget
///
/// Displays list of system alerts/errors
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/alert.dart';

class AlertsCard extends StatelessWidget {
  final List<Alert> alerts;
  final VoidCallback? onClearAlerts;
  final int maxAlerts;

  const AlertsCard({
    super.key,
    required this.alerts,
    this.onClearAlerts,
    this.maxAlerts = 5,
  });

  @override
  Widget build(BuildContext context) {
    // Pad with empty alerts if needed
    final displayAlerts = List<Alert?>.from(alerts.take(maxAlerts));
    while (displayAlerts.length < maxAlerts) {
      displayAlerts.add(null);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.deviceCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Аварии ($maxAlerts последних кодов)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (onClearAlerts != null && alerts.isNotEmpty)
                TextButton(
                  onPressed: onClearAlerts,
                  child: const Text(
                    'Сброс',
                    style: TextStyle(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Alert rows
          ...displayAlerts.map((alert) => _buildAlertRow(context, alert)),

          const SizedBox(height: 12),

          // Footer note
          Text(
            'Дата фиксируется на клиенте при первом появлении кода ≠ 0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertRow(BuildContext context, Alert? alert) {
    final hasAlert = alert != null && alert.code != 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.backgroundCardBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alert icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: hasAlert
                  ? _getSeverityColor(alert.severity).withValues(alpha: 0.2)
                  : AppTheme.backgroundDark,
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasAlert ? _getSeverityIcon(alert.severity) : Icons.check_circle,
              size: 18,
              color: hasAlert
                  ? _getSeverityColor(alert.severity)
                  : AppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 12),

          // Alert info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasAlert ? 'Код ${alert.code}' : 'Нет аварий',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        hasAlert ? _getSeverityColor(alert.severity) : AppTheme.textSecondary,
                  ),
                ),
                if (hasAlert) ...[
                  const SizedBox(height: 2),
                  Text(
                    alert.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Timestamp
          if (hasAlert && alert.timestamp != null)
            Text(
              DateFormat('dd.MM.yy HH:mm').format(alert.timestamp!),
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.info:
        return AppTheme.info;
      case AlertSeverity.warning:
        return AppTheme.warning;
      case AlertSeverity.error:
        return AppTheme.error;
      case AlertSeverity.critical:
        return const Color(0xFFD32F2F); // Darker red
    }
  }

  IconData _getSeverityIcon(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.info:
        return Icons.info_outline;
      case AlertSeverity.warning:
        return Icons.warning_amber;
      case AlertSeverity.error:
        return Icons.error_outline;
      case AlertSeverity.critical:
        return Icons.dangerous;
    }
  }
}
