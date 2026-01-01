/// Notifications Screen - Full notification list with actions
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_font_sizes.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/services/toast_service.dart';
import '../../../domain/entities/unit_notification.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../widgets/error/error_widgets.dart';

/// Полноэкранный список уведомлений с действиями
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        elevation: 0,
        title: Text(
          'Уведомления',
          style: TextStyle(
            fontSize: AppFontSizes.h3,
            fontWeight: FontWeight.bold,
            color: colors.text,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              final hasUnread = state.unitNotifications.any((n) => !n.isRead);
              if (!hasUnread) return const SizedBox.shrink();

              return TextButton(
                onPressed: () {
                  for (final n in state.unitNotifications) {
                    if (!n.isRead) {
                      context.read<DashboardBloc>().add(NotificationRead(n.id));
                    }
                  }
                  ToastService.success('Все уведомления прочитаны');
                },
                child: const Text(
                  'Прочитать все',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final notifications = state.unitNotifications;

          if (notifications.isEmpty) {
            return EmptyState.noNotifications();
          }

          return RefreshIndicator(
            color: AppColors.accent,
            onRefresh: () async {
              context.read<DashboardBloc>().add(const DashboardRefreshed());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationTile(
                  notification: notification,
                  onTap: () {
                    if (!notification.isRead) {
                      context.read<DashboardBloc>().add(
                        NotificationRead(notification.id),
                      );
                    }
                  },
                  onDismiss: () {
                    context.read<DashboardBloc>().add(
                      NotificationDismissed(notification.id),
                    );
                    ToastService.info('Уведомление удалено');
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
  final UnitNotification notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const _NotificationTile({
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

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

    if (diff.inMinutes < 1) return 'Только что';
    if (diff.inMinutes < 60) return '${diff.inMinutes} мин назад';
    if (diff.inHours < 24) return '${diff.inHours} ч назад';
    if (diff.inDays < 7) return '${diff.inDays} дн назад';
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
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
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
                child: Icon(
                  _typeIcon,
                  size: 20,
                  color: _typeColor,
                ),
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
