/// Company notifications card
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';
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
    final t = NeumorphicTheme.of(context);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(title, style: t.typography.titleMedium),
                  if (unreadCount > 0) ...[
                    const SizedBox(width: 8),
                    NeumorphicBadge(
                      text: '$unreadCount',
                      color: NeumorphicColors.accentPrimary,
                    ),
                  ],
                ],
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'Все',
                    style: t.typography.labelSmall.copyWith(
                      color: NeumorphicColors.accentPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Notifications list
          if (notifications.isEmpty)
            _buildEmptyState(t)
          else
            Expanded(
              child: ListView.separated(
                itemCount: notifications.take(5).length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: NeumorphicSpacing.xs),
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

  Widget _buildEmptyState(NeumorphicThemeData t) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 32,
              color: t.colors.textTertiary,
            ),
            const SizedBox(height: 8),
            Text(
              'Нет новых уведомлений',
              style: t.typography.bodySmall.copyWith(
                color: t.colors.textTertiary,
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
    final t = NeumorphicTheme.of(context);
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
                ? t.colors.textTertiary.withValues(alpha: 0.1)
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
                          style: t.typography.bodyMedium.copyWith(
                            fontWeight: notification.isRead
                                ? FontWeight.normal
                                : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        notification.timeAgo,
                        style: t.typography.labelSmall.copyWith(
                          color: t.colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: t.typography.bodySmall.copyWith(
                      color: t.colors.textSecondary,
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
                color: t.colors.textTertiary,
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
        CompanyNotificationType.update => NeumorphicColors.accentPrimary,
        CompanyNotificationType.news => NeumorphicColors.accentInfo,
        CompanyNotificationType.promo => NeumorphicColors.accentSuccess,
        CompanyNotificationType.tip => NeumorphicColors.accentWarning,
        CompanyNotificationType.security => NeumorphicColors.accentError,
      };
}
