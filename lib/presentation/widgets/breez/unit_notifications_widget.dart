/// Unit Notifications Widget - Alerts and notifications for specific unit
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_radius.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/unit_notification.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_list_card.dart';

export '../../../domain/entities/unit_notification.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для UnitNotificationsWidget
abstract class _NotificationWidgetConstants {
  static const double iconSize = 18;
  static const double titleFontSize = 16;
  static const double badgeFontSize = 11;
  static const int maxVisibleNotifications = 3;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Unit notifications widget
class UnitNotificationsWidget extends StatelessWidget {

  const UnitNotificationsWidget({
    required this.unitName,
    required this.notifications,
    super.key,
    this.onSeeAll,
    this.onNotificationTap,
  });
  final String unitName;
  final List<UnitNotification> notifications;
  final VoidCallback? onSeeAll;
  final ValueChanged<String>? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    const maxVisible = _NotificationWidgetConstants.maxVisibleNotifications;

    return Semantics(
      label: '${l10n.notifications}: ${notifications.length}',
      child: BreezCard(
        padding: const EdgeInsets.all(AppSpacing.xs),
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
                      size: _NotificationWidgetConstants.iconSize,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      l10n.notifications,
                      style: TextStyle(
                        fontSize: _NotificationWidgetConstants.titleFontSize,
                        fontWeight: FontWeight.w700,
                        color: colors.text,
                      ),
                    ),
                  ],
                ),
                if (notifications.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xxs / 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                    child: Text(
                      '${notifications.length}',
                      style: const TextStyle(
                        fontSize: _NotificationWidgetConstants.badgeFontSize,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentRed,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Notifications list (no scroll, max 3 visible)
            Expanded(
              child: notifications.isEmpty
                  ? BreezEmptyState.noNotifications(l10n)
                  : Column(
                      children: [
                        for (var i = 0; i < notifications.length && i < maxVisible; i++) ...[
                          if (i > 0) const SizedBox(height: AppSpacing.xs),
                          BreezListCard.notification(
                            title: notifications[i].title,
                            message: notifications[i].message,
                            type: _mapNotificationType(notifications[i].type),
                            timeAgo: _formatTimeAgo(notifications[i].timestamp, l10n),
                            isRead: notifications[i].isRead,
                            onTap: () => onNotificationTap?.call(notifications[i].id),
                          ),
                        ],
                      ],
                    ),
            ),

            // See all button
            if (notifications.length > maxVisible) ...[
              const SizedBox(height: AppSpacing.sm),
              BreezSeeMoreButton(
                label: l10n.allNotifications,
                extraCount: notifications.length - maxVisible,
                onTap: onSeeAll,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Map NotificationType to ListCardType
  ListCardType _mapNotificationType(NotificationType type) {
    const typeMap = <NotificationType, ListCardType>{
      NotificationType.info: ListCardType.info,
      NotificationType.warning: ListCardType.warning,
      NotificationType.error: ListCardType.error,
      NotificationType.success: ListCardType.success,
    };
    return typeMap[type] ?? ListCardType.info;
  }

  /// Format timestamp to human-readable time ago
  String _formatTimeAgo(DateTime timestamp, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return l10n.justNow;
    }
    if (diff.inMinutes < 60) {
      return l10n.minutesAgo(diff.inMinutes);
    }
    if (diff.inHours < 24) {
      return l10n.hoursAgo(diff.inHours);
    }
    return l10n.daysAgo(diff.inDays);
  }
}
