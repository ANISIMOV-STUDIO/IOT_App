/// Unit Notifications Widget - Alerts and notifications for specific unit
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../domain/entities/unit_notification.dart';
import 'breez_card.dart';
import 'breez_list_card.dart';

export '../../../domain/entities/unit_notification.dart';

/// Unit notifications widget
class UnitNotificationsWidget extends StatelessWidget {
  final String unitName;
  final List<UnitNotification> notifications;
  final VoidCallback? onSeeAll;
  final ValueChanged<String>? onNotificationTap;

  const UnitNotificationsWidget({
    super.key,
    required this.unitName,
    required this.notifications,
    this.onSeeAll,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return BreezCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    size: 18,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Уведомления',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.text,
                    ),
                  ),
                ],
              ),
              if (notifications.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                  child: Text(
                    '${notifications.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentRed,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Notifications list (no scroll, max 3 visible)
          Expanded(
            child: notifications.isEmpty
                ? BreezEmptyState.noNotifications()
                : Column(
                    children: notifications.take(3).toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final notification = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(bottom: index < 2 ? 8 : 0),
                        child: BreezListCard.notification(
                          title: notification.title,
                          message: notification.message,
                          type: _mapNotificationType(notification.type),
                          timeAgo: _formatTimeAgo(notification.timestamp),
                          isRead: notification.isRead,
                          onTap: () => onNotificationTap?.call(notification.id),
                        ),
                      );
                    }).toList(),
                  ),
          ),

          // See all button
          if (notifications.length > 3) ...[
            const SizedBox(height: 12),
            BreezSeeMoreButton(
              label: 'Все уведомления',
              extraCount: notifications.length - 3,
              onTap: onSeeAll,
            ),
          ],
        ],
      ),
    );
  }

  /// Map NotificationType to ListCardType
  ListCardType _mapNotificationType(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return ListCardType.info;
      case NotificationType.warning:
        return ListCardType.warning;
      case NotificationType.error:
        return ListCardType.error;
      case NotificationType.success:
        return ListCardType.success;
    }
  }

  /// Format timestamp to human-readable time ago
  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Только что';
    if (diff.inMinutes < 60) return '${diff.inMinutes} мин назад';
    if (diff.inHours < 24) return '${diff.inHours} ч назад';
    return '${diff.inDays} дн назад';
  }
}
