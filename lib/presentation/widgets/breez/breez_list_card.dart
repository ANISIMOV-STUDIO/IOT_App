/// Breez List Card - Unified card for list items (alarms, notifications, etc.)
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart'; // BreezButton

/// Type of list card for color theming
enum ListCardType {
  info,
  warning,
  error,
  success,
}

/// Универсальная карточка для списков (аварии, уведомления и т.д.)
class BreezListCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final String? trailing;
  final ListCardType type;
  final VoidCallback? onTap;
  final bool showUnreadIndicator;
  final bool compact;

  const BreezListCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badge,
    this.trailing,
    this.type = ListCardType.info,
    this.onTap,
    this.showUnreadIndicator = false,
    this.compact = false,
  });

  /// Фабрика для карточки аварии
  factory BreezListCard.alarm({
    Key? key,
    required String code,
    required String description,
    required AppLocalizations l10n,
    VoidCallback? onTap,
    bool compact = false,
  }) {
    return BreezListCard(
      key: key,
      icon: Icons.error_outline,
      title: l10n.alarmCode(code),
      subtitle: description,
      badge: compact ? null : l10n.activeAlarm,
      type: ListCardType.error,
      onTap: onTap,
      compact: compact,
    );
  }

  /// Factory for notification card
  factory BreezListCard.notification({
    Key? key,
    required String title,
    required String message,
    required ListCardType type,
    String? timeAgo,
    bool isRead = true,
    VoidCallback? onTap,
  }) {
    return BreezListCard(
      key: key,
      icon: _iconForType(type),
      title: title,
      subtitle: message,
      trailing: timeAgo,
      type: type,
      showUnreadIndicator: !isRead,
      onTap: onTap,
    );
  }

  static IconData _iconForType(ListCardType type) {
    switch (type) {
      case ListCardType.info:
        return Icons.info_outline;
      case ListCardType.warning:
        return Icons.warning_amber_outlined;
      case ListCardType.error:
        return Icons.error_outline;
      case ListCardType.success:
        return Icons.check_circle_outline;
    }
  }

  Color _colorForType() {
    switch (type) {
      case ListCardType.info:
        return AppColors.accent;
      case ListCardType.warning:
        return AppColors.accentOrange;
      case ListCardType.error:
        return AppColors.accentRed;
      case ListCardType.success:
        return AppColors.accentGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final typeColor = _colorForType();

    // Размеры для компактного режима
    final iconContainerSize = compact ? 24.0 : 32.0;
    final iconSize = compact ? 12.0 : 16.0;
    final padding = compact ? 8.0 : 12.0;
    final titleSize = compact ? 11.0 : 12.0;
    final subtitleSize = compact ? 10.0 : 11.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        hoverColor: typeColor.withValues(alpha: 0.12),
        splashColor: typeColor.withValues(alpha: 0.2),
        highlightColor: typeColor.withValues(alpha: 0.1),
        child: Ink(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: typeColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Иконка
              Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: typeColor,
                ),
              ),

              SizedBox(width: compact ? 8 : 10),

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
                            title,
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.w600,
                              color: colors.text,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badge!,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: typeColor,
                              ),
                            ),
                          ),
                        if (trailing != null)
                          Text(
                            trailing!,
                            style: TextStyle(
                              fontSize: 10,
                              color: colors.textMuted,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: compact ? 2 : 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: subtitleSize,
                        color: colors.textMuted,
                      ),
                      maxLines: compact ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Индикатор непрочитанного
              if (showUnreadIndicator) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: typeColor,
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

/// Unified "See More" button for list widgets
class BreezSeeMoreButton extends StatelessWidget {
  final String label;
  final int? extraCount;
  final VoidCallback? onTap;

  const BreezSeeMoreButton({
    super.key,
    required this.label,
    this.extraCount,
    this.onTap,
  });

  String get _text {
    if (extraCount != null && extraCount! > 0) {
      return '$label (+$extraCount)';
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return BreezButton(
      onTap: onTap,
      width: double.infinity,
      height: 48,
      backgroundColor: colors.buttonBg,
      hoverColor: colors.buttonHover,
      child: Center(
        child: Text(
          _text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }
}

/// Виджет пустого состояния для списков
class BreezEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final bool compact;

  const BreezEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.compact = false,
  });

  /// Фабрика для пустого списка аварий
  factory BreezEmptyState.noAlarms(AppLocalizations l10n, {bool compact = false}) {
    return BreezEmptyState(
      icon: Icons.check_circle_outline,
      title: l10n.noAlarms,
      subtitle: l10n.systemWorkingNormally,
      iconColor: AppColors.accentGreen,
      compact: compact,
    );
  }

  /// Фабрика для пустого списка уведомлений
  factory BreezEmptyState.noNotifications(AppLocalizations l10n, {bool compact = false}) {
    return BreezEmptyState(
      icon: Icons.check_circle_outline,
      title: l10n.noNotifications,
      subtitle: l10n.systemWorkingNormally,
      iconColor: AppColors.accentGreen,
      compact: compact,
    );
  }

  /// Фабрика для пустого расписания
  factory BreezEmptyState.noSchedule(AppLocalizations l10n, {bool compact = false}) {
    return BreezEmptyState(
      icon: Icons.schedule_outlined,
      title: l10n.noSchedule,
      subtitle: l10n.addFirstEntry,
      iconColor: AppColors.accent,
      compact: compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final color = iconColor ?? AppColors.accentGreen;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: compact ? 28 : 40,
            color: color.withValues(alpha: 0.5),
          ),
          SizedBox(height: compact ? 8 : 12),
          Text(
            title,
            style: TextStyle(
              fontSize: compact ? 11 : 13,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: colors.textMuted.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
