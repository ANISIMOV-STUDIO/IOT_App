/// Unit Notifications Widget - Alerts and notifications for specific unit
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/unit_notification.dart';
import 'breez_card.dart';

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
                  Icon(
                    Icons.notifications_outlined,
                    size: 18,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Уведомления',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              if (notifications.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${notifications.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentRed,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Notifications list
          Expanded(
            child: notifications.isEmpty
                ? _EmptyState()
                : ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _NotificationCard(
                        notification: notification,
                        onTap: () => onNotificationTap?.call(notification.id),
                      );
                    },
                  ),
          ),

          // See all button
          if (notifications.isNotEmpty) ...[
            const SizedBox(height: 12),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: onSeeAll,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Center(
                    child: Text(
                      'Все уведомления',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state widget
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 40,
            color: AppColors.accentGreen.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Нет уведомлений',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Система работает штатно',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.darkTextMuted.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual notification card
class _NotificationCard extends StatefulWidget {
  final UnitNotification notification;
  final VoidCallback? onTap;

  const _NotificationCard({
    required this.notification,
    this.onTap,
  });

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  bool _isHovered = false;

  Color get _typeColor {
    switch (widget.notification.type) {
      case NotificationType.info:
        return AppColors.accent;
      case NotificationType.warning:
        return AppColors.accentOrange;
      case NotificationType.error:
        return AppColors.accentRed;
      case NotificationType.success:
        return AppColors.accentGreen;
    }
  }

  IconData get _typeIcon {
    switch (widget.notification.type) {
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.success:
        return Icons.check_circle_outline;
    }
  }

  String get _timeAgo {
    final now = DateTime.now();
    final diff = now.difference(widget.notification.timestamp);

    if (diff.inMinutes < 1) return 'Только что';
    if (diff.inMinutes < 60) return '${diff.inMinutes} мин назад';
    if (diff.inHours < 24) return '${diff.inHours} ч назад';
    return '${diff.inDays} дн назад';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered
                ? _typeColor.withValues(alpha: 0.08)
                : _typeColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? _typeColor.withValues(alpha: 0.3)
                  : _typeColor.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _typeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _typeIcon,
                  size: 16,
                  color: _typeColor,
                ),
              ),

              const SizedBox(width: 10),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.notification.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: widget.notification.isRead
                                  ? AppColors.darkTextMuted
                                  : Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _timeAgo,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.darkTextMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.notification.message,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.darkTextMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Unread indicator
              if (!widget.notification.isRead) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _typeColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
