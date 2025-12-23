/// Unified Notification Center - groups device alerts and company notifications
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/app_notification.dart';

/// Unified notification center that groups:
/// - Device alerts (per-device issues like filter change, errors)
/// - Company notifications (news, promos, tips from BREEZ)
class NotificationCenterCard extends StatefulWidget {
  final List<DeviceAlert> deviceAlerts;
  final List<CompanyNotification> companyNotifications;
  final String title;
  final VoidCallback? onViewAll;
  final ValueChanged<String>? onDeviceAlertAction;
  final ValueChanged<String>? onCompanyNotificationAction;

  const NotificationCenterCard({
    super.key,
    required this.deviceAlerts,
    required this.companyNotifications,
    this.title = 'Уведомления',
    this.onViewAll,
    this.onDeviceAlertAction,
    this.onCompanyNotificationAction,
  });

  @override
  State<NotificationCenterCard> createState() => _NotificationCenterCardState();
}

class _NotificationCenterCardState extends State<NotificationCenterCard> {
  bool _deviceAlertsExpanded = true;
  bool _companyNotificationsExpanded = true;

  int get _totalCount =>
      widget.deviceAlerts.length + widget.companyNotifications.length;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.foreground,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_totalCount > 0) ...[
                      const SizedBox(width: 8),
                      ShadBadge(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                        foregroundColor: AppColors.primary,
                        child: Text('$_totalCount'),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.onViewAll != null) ...[
                const SizedBox(width: 8),
                ShadButton.ghost(
                  onPressed: widget.onViewAll,
                  size: ShadButtonSize.sm,
                  child: const Icon(Icons.arrow_forward, size: 16),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Content
          Expanded(
            child: _totalCount == 0
                ? _buildEmptyState(theme)
                : ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      // Device alerts section
                      if (widget.deviceAlerts.isNotEmpty)
                        _NotificationGroup(
                          title: 'Устройства',
                          icon: Icons.devices,
                          count: widget.deviceAlerts.length,
                          isExpanded: _deviceAlertsExpanded,
                          onToggle: () => setState(() {
                            _deviceAlertsExpanded = !_deviceAlertsExpanded;
                          }),
                          children: widget.deviceAlerts
                              .take(3)
                              .map((alert) => _DeviceAlertItem(
                                    alert: alert,
                                    onAction: widget.onDeviceAlertAction != null
                                        ? () => widget.onDeviceAlertAction!(alert.id)
                                        : null,
                                  ))
                              .toList(),
                        ),

                      if (widget.deviceAlerts.isNotEmpty &&
                          widget.companyNotifications.isNotEmpty)
                        const SizedBox(height: 12),

                      // Company notifications section
                      if (widget.companyNotifications.isNotEmpty)
                        _NotificationGroup(
                          title: 'От BREEZ',
                          icon: Icons.campaign_outlined,
                          count: widget.companyNotifications.length,
                          isExpanded: _companyNotificationsExpanded,
                          accentColor: AppColors.info,
                          onToggle: () => setState(() {
                            _companyNotificationsExpanded =
                                !_companyNotificationsExpanded;
                          }),
                          children: widget.companyNotifications
                              .take(3)
                              .map((notification) => _CompanyNotificationItem(
                                    notification: notification,
                                    onAction: widget.onCompanyNotificationAction !=
                                            null
                                        ? () => widget.onCompanyNotificationAction!(
                                            notification.id)
                                        : null,
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ShadThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 40,
            color: AppColors.success.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          Text(
            'Нет уведомлений',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          Text(
            'Всё работает исправно',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.mutedForeground.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;
  final bool isExpanded;
  final VoidCallback? onToggle;
  final List<Widget> children;
  final Color? accentColor;

  const _NotificationGroup({
    required this.title,
    required this.icon,
    required this.count,
    required this.isExpanded,
    required this.children,
    this.onToggle,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final color = accentColor ?? AppColors.warning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group header
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: theme.colorScheme.mutedForeground,
                ),
                const SizedBox(width: 4),
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.mutedForeground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Items
        if (isExpanded)
          ...children.map((child) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: child,
              )),
      ],
    );
  }
}

class _DeviceAlertItem extends StatelessWidget {
  final DeviceAlert alert;
  final VoidCallback? onAction;

  const _DeviceAlertItem({
    required this.alert,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final color = _getAlertColor(alert.type);
    final icon = _getAlertIcon(alert.type);

    return GestureDetector(
      onTap: onAction,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 10),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alert.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.foreground,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Device name chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.muted.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          alert.deviceName.split(' ').first,
                          style: TextStyle(
                            fontSize: 9,
                            color: theme.colorScheme.mutedForeground,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    alert.message,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.mutedForeground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Due date
            if (alert.daysUntilDue != null) ...[
              const SizedBox(width: 8),
              _DueDateBadge(days: alert.daysUntilDue!),
            ],
          ],
        ),
      ),
    );
  }

  Color _getAlertColor(DeviceAlertType type) => switch (type) {
        DeviceAlertType.filterChange => AppColors.warning,
        DeviceAlertType.maintenance => AppColors.info,
        DeviceAlertType.error => AppColors.error,
        DeviceAlertType.offline => AppColors.airPoor,
        DeviceAlertType.connectionLost => AppColors.error,
        DeviceAlertType.firmwareUpdate => AppColors.primary,
      };

  IconData _getAlertIcon(DeviceAlertType type) => switch (type) {
        DeviceAlertType.filterChange => Icons.filter_alt,
        DeviceAlertType.maintenance => Icons.build,
        DeviceAlertType.error => Icons.error_outline,
        DeviceAlertType.offline => Icons.cloud_off,
        DeviceAlertType.connectionLost => Icons.wifi_off,
        DeviceAlertType.firmwareUpdate => Icons.system_update,
      };
}

class _CompanyNotificationItem extends StatelessWidget {
  final CompanyNotification notification;
  final VoidCallback? onAction;

  const _CompanyNotificationItem({
    required this.notification,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final color = _getNotificationColor(notification.type);
    final icon = _getNotificationIcon(notification.type);

    return GestureDetector(
      onTap: onAction,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 10),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.foreground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.mutedForeground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Type chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getTypeLabel(notification.type),
                style: TextStyle(
                  fontSize: 9,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNotificationColor(CompanyNotificationType type) => switch (type) {
        CompanyNotificationType.update => AppColors.primary,
        CompanyNotificationType.news => AppColors.info,
        CompanyNotificationType.promo => AppColors.success,
        CompanyNotificationType.tip => AppColors.warning,
        CompanyNotificationType.security => AppColors.error,
      };

  IconData _getNotificationIcon(CompanyNotificationType type) => switch (type) {
        CompanyNotificationType.update => Icons.system_update,
        CompanyNotificationType.news => Icons.newspaper,
        CompanyNotificationType.promo => Icons.local_offer,
        CompanyNotificationType.tip => Icons.lightbulb_outline,
        CompanyNotificationType.security => Icons.security,
      };

  String _getTypeLabel(CompanyNotificationType type) => switch (type) {
        CompanyNotificationType.update => 'Обновление',
        CompanyNotificationType.news => 'Новость',
        CompanyNotificationType.promo => 'Акция',
        CompanyNotificationType.tip => 'Совет',
        CompanyNotificationType.security => 'Важно',
      };
}

class _DueDateBadge extends StatelessWidget {
  final int days;

  const _DueDateBadge({required this.days});

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final text = _getText();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getColor() {
    if (days <= 3) return AppColors.error;
    if (days <= 7) return AppColors.warning;
    return AppColors.info;
  }

  String _getText() {
    if (days < 0) return 'Просрочено';
    if (days == 0) return 'Сегодня';
    if (days == 1) return 'Завтра';
    return '$days дн.';
  }
}
