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
      padding: EdgeInsets.all(20.w),
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
            size: 64.sp,
            color: HvacColors.success.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'Нет аварий',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Установка работает без ошибок',
            style: TextStyle(
              fontSize: 14.sp,
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
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(severityIcon, color: severityColor, size: 20.sp),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Авария: код ${alert.code}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: HvacColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  alert.description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: HvacColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  alert.timestamp != null
                      ? '${alert.timestamp!.day.toString().padLeft(2, '0')}.${alert.timestamp!.month.toString().padLeft(2, '0')}.${alert.timestamp!.year} ${alert.timestamp!.hour.toString().padLeft(2, '0')}:${alert.timestamp!.minute.toString().padLeft(2, '0')}'
                      : 'Время неизвестно',
                  style: TextStyle(
                    fontSize: 11.sp,
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
