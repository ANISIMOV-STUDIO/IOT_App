/// Device alerts card
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/app_notification.dart';

/// Card showing device-specific alerts (filter change, errors, etc.)
class DeviceAlertsCard extends StatelessWidget {
  final List<DeviceAlert> alerts;
  final String title;
  final VoidCallback? onViewAll;
  final ValueChanged<String>? onDismiss;
  final ValueChanged<String>? onAction;

  const DeviceAlertsCard({
    super.key,
    required this.alerts,
    this.title = 'Уведомления',
    this.onViewAll,
    this.onDismiss,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final unreadCount = alerts.where((a) => !a.isRead).length;

    return ShadCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.foreground,
                ),
              ),
              if (unreadCount > 0)
                ShadBadge.destructive(
                  child: Text('$unreadCount'),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Alerts list
          Expanded(
            child: alerts.isEmpty
                ? _buildEmptyState(theme)
                : ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    itemCount: alerts.length.clamp(0, 3),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final alert = alerts[index];
                      return _AlertItem(
                        alert: alert,
                        onDismiss: onDismiss != null
                            ? () => onDismiss!(alert.id)
                            : null,
                        onAction: onAction != null
                            ? () => onAction!(alert.id)
                            : null,
                      );
                    },
                  ),
          ),

          // View all button
          if (alerts.length > 3 && onViewAll != null) ...[
            const SizedBox(height: 8),
            Center(
              child: ShadButton.ghost(
                onPressed: onViewAll,
                size: ShadButtonSize.sm,
                child: Text('Показать все (${alerts.length})'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(ShadThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 20,
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          Text(
            'Нет уведомлений',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final DeviceAlert alert;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;

  const _AlertItem({
    required this.alert,
    this.onDismiss,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final color = _getAlertColor(alert.type);
    final icon = _getAlertIcon(alert.type);

    return Row(
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alert.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.foreground,
                ),
              ),
              Text(
                alert.message,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.mutedForeground,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Due date badge
        if (alert.daysUntilDue != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getDueDateColor(alert.daysUntilDue!).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getDueDateText(alert.daysUntilDue!),
              style: TextStyle(
                fontSize: 12,
                color: _getDueDateColor(alert.daysUntilDue!),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Color _getAlertColor(DeviceAlertType type) => switch (type) {
        DeviceAlertType.filterChange => AppColors.warning,
        DeviceAlertType.maintenance => AppColors.info,
        DeviceAlertType.error => AppColors.error,
        DeviceAlertType.offline => AppColors.error,
        DeviceAlertType.connectionLost => AppColors.error,
        DeviceAlertType.firmwareUpdate => AppColors.primary,
      };

  IconData _getAlertIcon(DeviceAlertType type) => switch (type) {
        DeviceAlertType.filterChange => Icons.filter_alt,
        DeviceAlertType.maintenance => Icons.build,
        DeviceAlertType.error => Icons.error_outline,
        DeviceAlertType.offline => Icons.cloud_off,
        DeviceAlertType.connectionLost => Icons.wifi_off,
        DeviceAlertType.firmwareUpdate => Icons.update,
      };

  Color _getDueDateColor(int days) {
    if (days <= 3) return AppColors.error;
    if (days <= 7) return AppColors.warning;
    return AppColors.info;
  }

  String _getDueDateText(int days) {
    if (days < 0) return 'Просрочено';
    if (days == 0) return 'Сегодня';
    if (days == 1) return 'Завтра';
    return 'Через $days дн.';
  }
}
