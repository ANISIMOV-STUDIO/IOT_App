/// Device alerts card
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';
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
    final t = GlassTheme.of(context);
    final unreadCount = alerts.where((a) => !a.isRead).length;

    return GlassCard(
      variant: GlassCardVariant.concave,
      padding: const EdgeInsets.all(GlassSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: t.typography.titleMedium),
              if (unreadCount > 0)
                GlassBadge(
                  text: '$unreadCount',
                  color: GlassColors.accentError,
                ),
            ],
          ),
          const SizedBox(height: GlassSpacing.sm),

          // Alerts list
          Expanded(
            child: alerts.isEmpty
                ? _buildEmptyState(t)
                : ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    itemCount: alerts.length.clamp(0, 3),
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: GlassSpacing.xs),
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
            const SizedBox(height: GlassSpacing.xs),
            Center(
              child: TextButton(
                onPressed: onViewAll,
                child: Text(
                  'Показать все (${alerts.length})',
                  style: t.typography.labelSmall.copyWith(
                    color: GlassColors.accentPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(GlassThemeData t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: GlassSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 20,
            color: GlassColors.accentSuccess,
          ),
          const SizedBox(width: 8),
          Text(
            'Нет уведомлений',
            style: t.typography.bodySmall.copyWith(
              color: t.colors.textSecondary,
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
    final t = GlassTheme.of(context);
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
                style: t.typography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                alert.message,
                style: t.typography.bodySmall.copyWith(
                  color: t.colors.textSecondary,
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
              style: t.typography.labelSmall.copyWith(
                color: _getDueDateColor(alert.daysUntilDue!),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Color _getAlertColor(DeviceAlertType type) => switch (type) {
        DeviceAlertType.filterChange => GlassColors.accentWarning,
        DeviceAlertType.maintenance => GlassColors.accentInfo,
        DeviceAlertType.error => GlassColors.accentError,
        DeviceAlertType.offline => GlassColors.airQualityPoor,
        DeviceAlertType.connectionLost => GlassColors.accentError,
        DeviceAlertType.firmwareUpdate => GlassColors.accentPrimary,
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
    if (days <= 3) return GlassColors.accentError;
    if (days <= 7) return GlassColors.accentWarning;
    return GlassColors.accentInfo;
  }

  String _getDueDateText(int days) {
    if (days < 0) return 'Просрочено';
    if (days == 0) return 'Сегодня';
    if (days == 1) return 'Завтра';
    return 'Через $days дн.';
  }
}
