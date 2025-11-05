/// Alerts History Tab Widget
///
/// Displays history of alerts and errors
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/alert.dart';

class AlertsHistoryTab extends StatelessWidget {
  final HvacUnit unit;

  const AlertsHistoryTab({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final alerts = unit.alerts ?? [];

    if (alerts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64.0,
            color: HvacColors.success.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Нет аварий',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Установка работает без ошибок',
            style: TextStyle(
              fontSize: 14.0,
              color: HvacColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Alert alert) {
    Color severityColor;
    IconData severityIcon;

    switch (alert.severity) {
      case AlertSeverity.critical:
        severityColor = HvacColors.error;
        severityIcon = Icons.error;
        break;
      case AlertSeverity.error:
        severityColor = HvacColors.error;
        severityIcon = Icons.error_outline;
        break;
      case AlertSeverity.warning:
        severityColor = HvacColors.warning;
        severityIcon = Icons.warning;
        break;
      case AlertSeverity.info:
        severityColor = HvacColors.info;
        severityIcon = Icons.info;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.15),
              borderRadius: HvacRadius.smRadius,
            ),
            child: Icon(severityIcon, color: severityColor, size: 20.0),
          ),

          const SizedBox(width: 12.0),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Авария: код ${alert.code}',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: HvacColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  alert.description,
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: HvacColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  alert.timestamp != null
                      ? '${alert.timestamp!.day.toString().padLeft(2, '0')}.${alert.timestamp!.month.toString().padLeft(2, '0')}.${alert.timestamp!.year} ${alert.timestamp!.hour.toString().padLeft(2, '0')}:${alert.timestamp!.minute.toString().padLeft(2, '0')}'
                      : 'Время неизвестно',
                  style: const TextStyle(
                    fontSize: 11.0,
                    color: HvacColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
