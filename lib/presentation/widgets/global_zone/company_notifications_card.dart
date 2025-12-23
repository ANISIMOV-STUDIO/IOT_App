/// Company notifications card
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/app_notification.dart';

/// Card showing company-wide notifications (updates, news, promos)
class CompanyNotificationsCard extends StatelessWidget {
  final List<CompanyNotification> notifications;
  final String title;
  final VoidCallback? onViewAll;
  final ValueChanged<String>? onNotificationTap;
  final ValueChanged<String>? onDismiss;

  const CompanyNotificationsCard({
    super.key,
    required this.notifications,
    this.title = 'Новости BREEZ',
    this.onViewAll,
    this.onNotificationTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.foreground,
                    ),
                  ),
                  if (unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    ShadBadge(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      foregroundColor: AppColors.primary,
                      child: Text('$unreadCount'),
                    ),
                  ],
                ],
              ),
              if (onViewAll != null)
                ShadButton.ghost(
                  onPressed: onViewAll,
                  size: ShadButtonSize.sm,
                  child: const Text('Все'),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Notifications list
          if (notifications.isEmpty)
            _buildEmptyState(theme)
          else
            Expanded(
              child: ListView.separated(
                itemCount: notifications.take(5).length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _NotificationItem(
                    notification: notification,
                    onTap: onNotificationTap != null
                        ? () => onNotificationTap!(notification.id)
                        : null,
                    onDismiss: onDismiss != null
                        ? () => onDismiss!(notification.id)
                        : null,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ShadThemeData theme) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 32,
              color: theme.colorScheme.mutedForeground,
            ),
            const SizedBox(height: 8),
            Text(
              'Нет новых уведомлений',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final CompanyNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const _NotificationItem({
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final icon = _getTypeIcon(notification.type);
    final color = _getTypeColor(notification.type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.transparent
              : color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: notification.isRead
                ? theme.colorScheme.border
                : color.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.normal
                                : FontWeight.w600,
                            color: theme.colorScheme.foreground,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        notification.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.mutedForeground,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Action button
            if (notification.hasAction) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: theme.colorScheme.mutedForeground,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(CompanyNotificationType type) => switch (type) {
        CompanyNotificationType.update => Icons.system_update,
        CompanyNotificationType.news => Icons.newspaper,
        CompanyNotificationType.promo => Icons.local_offer,
        CompanyNotificationType.tip => Icons.lightbulb_outline,
        CompanyNotificationType.security => Icons.security,
      };

  Color _getTypeColor(CompanyNotificationType type) => switch (type) {
        CompanyNotificationType.update => AppColors.primary,
        CompanyNotificationType.news => AppColors.info,
        CompanyNotificationType.promo => AppColors.success,
        CompanyNotificationType.tip => AppColors.warning,
        CompanyNotificationType.security => AppColors.error,
      };
}
