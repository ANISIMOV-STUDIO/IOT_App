/// Notifications Screen - Full notification list with actions
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/services/toast_service.dart';
import 'package:hvac_control/core/theme/app_animations.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/unit_notification.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_icon_button.dart';
import 'package:hvac_control/presentation/widgets/error/error_widgets.dart';

/// Полноэкранный список уведомлений с действиями
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        elevation: 0,
        title: Text(
          l10n.notificationsTitle,
          style: TextStyle(
            fontSize: AppFontSizes.h3,
            fontWeight: FontWeight.bold,
            color: colors.text,
          ),
        ),
        leading: BreezIconButton(
          icon: Icons.arrow_back,
          iconColor: colors.text,
          backgroundColor: Colors.transparent,
          showBorder: false,
          compact: true,
          onTap: () => Navigator.of(context).pop(),
          semanticLabel: 'Back',
        ),
        actions: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (!state.hasUnread) {
                return const SizedBox.shrink();
              }

              return BreezButton(
                onTap: () {
                  context.read<NotificationsBloc>().add(
                    const NotificationsMarkAllAsReadRequested(),
                  );
                  ToastService.success(l10n.notificationsReadAll);
                },
                backgroundColor: Colors.transparent,
                hoverColor: colors.accent.withValues(alpha: 0.1),
                pressedColor: colors.accent.withValues(alpha: 0.15),
                showBorder: false,
                semanticLabel: l10n.readAll,
                child: Text(
                  l10n.readAll,
                  style: TextStyle(
                    color: colors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return EmptyState.noNotifications(context);
          }

          return RefreshIndicator(
            color: colors.accent,
            onRefresh: () async {
              final deviceId = state.currentDeviceId;
              if (deviceId != null) {
                context.read<NotificationsBloc>().add(
                  NotificationsDeviceChanged(deviceId),
                );
              }
              await Future<void>.delayed(AppDurations.long);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: state.notifications.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return _NotificationTile(
                  notification: notification,
                  l10n: l10n,
                  onTap: () {
                    if (!notification.isRead) {
                      context.read<NotificationsBloc>().add(
                        NotificationsMarkAsReadRequested(notification.id),
                      );
                    }
                  },
                  onDismiss: () {
                    context.read<NotificationsBloc>().add(
                      NotificationsDismissRequested(notification.id),
                    );
                    ToastService.info(l10n.notificationDeleted);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Плитка уведомления с возможностью свайпа
class _NotificationTile extends StatelessWidget {

  const _NotificationTile({
    required this.notification,
    required this.l10n,
    this.onTap,
    this.onDismiss,
  });
  final UnitNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final AppLocalizations l10n;

  Color get _typeColor {
    switch (notification.type) {
      case NotificationType.info:
        return AppColors.info;
      case NotificationType.warning:
        return AppColors.warning;
      case NotificationType.error:
        return AppColors.critical;
      case NotificationType.success:
        return AppColors.success;
    }
  }

  IconData get _typeIcon {
    switch (notification.type) {
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
    final diff = now.difference(notification.timestamp);

    if (diff.inMinutes < 1) {
      return l10n.justNow;
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} мин назад';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} ч назад';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays} дн назад';
    }
    return '${notification.timestamp.day}.${notification.timestamp.month}.${notification.timestamp.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.critical,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: notification.isRead
                ? colors.card
                : _typeColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: notification.isRead
                  ? colors.border
                  : _typeColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Иконка типа
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _typeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                child: Icon(_typeIcon, size: AppIconSizes.standard, color: _typeColor),
              ),
              const SizedBox(width: AppSpacing.md),

              // Контент
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: AppFontSizes.body,
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                              color: colors.text,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _timeAgo,
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        color: colors.textMuted,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Индикатор непрочитанного
              if (!notification.isRead) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 10,
                  height: 10,
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
