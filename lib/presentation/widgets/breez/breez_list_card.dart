/// Breez List Card - Unified card for list items (alarms, notifications, etc.)
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart'; // BreezButton

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezListCard
abstract class _ListCardConstants {
  // Размеры для нормального режима
  static const double iconContainerSizeNormal = 32.0;
  static const double iconSizeNormal = 16.0;
  static const double paddingNormal = 12.0;
  static const double titleFontSizeNormal = 12.0;
  static const double subtitleFontSizeNormal = 11.0;

  // Размеры для компактного режима
  static const double iconContainerSizeCompact = 24.0;
  static const double iconSizeCompact = 12.0;
  static const double paddingCompact = 8.0;
  static const double titleFontSizeCompact = 11.0;
  static const double subtitleFontSizeCompact = 10.0;

  // Общие
  static const double badgeFontSize = 9.0;
  static const double badgePaddingH = 6.0;
  static const double badgePaddingV = 2.0;
  static const double badgeRadius = 4.0;
  static const double trailingFontSize = 10.0;
  static const double unreadIndicatorSize = 8.0;

  // Прозрачности
  static const double bgAlpha = 0.08;
  static const double borderAlpha = 0.2;
  static const double hoverAlpha = 0.12;
  static const double splashAlpha = 0.2;
  static const double highlightAlpha = 0.1;
  static const double badgeAlpha = 0.2;
}

/// Константы для BreezEmptyState
abstract class _EmptyStateConstants {
  static const double iconSizeNormal = 40.0;
  static const double iconSizeCompact = 28.0;
  static const double titleFontSizeNormal = 13.0;
  static const double titleFontSizeCompact = 11.0;
  static const double subtitleFontSize = 11.0;
  static const double iconAlpha = 0.5;
  static const double subtitleAlpha = 0.7;
}

/// Константы для BreezSeeMoreButton
abstract class _SeeMoreConstants {
  static const double height = 48.0;
  static const double fontSize = 12.0;
}

// =============================================================================
// TYPES
// =============================================================================

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
    const iconMap = <ListCardType, IconData>{
      ListCardType.info: Icons.info_outline,
      ListCardType.warning: Icons.warning_amber_outlined,
      ListCardType.error: Icons.error_outline,
      ListCardType.success: Icons.check_circle_outline,
    };
    return iconMap[type] ?? Icons.info_outline;
  }

  Color _colorForType() {
    const colorMap = <ListCardType, Color>{
      ListCardType.info: AppColors.accent,
      ListCardType.warning: AppColors.accentOrange,
      ListCardType.error: AppColors.accentRed,
      ListCardType.success: AppColors.accentGreen,
    };
    return colorMap[type] ?? AppColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final typeColor = _colorForType();

    // Размеры для компактного режима
    final iconContainerSize = compact
        ? _ListCardConstants.iconContainerSizeCompact
        : _ListCardConstants.iconContainerSizeNormal;
    final iconSize = compact
        ? _ListCardConstants.iconSizeCompact
        : _ListCardConstants.iconSizeNormal;
    final padding = compact
        ? _ListCardConstants.paddingCompact
        : _ListCardConstants.paddingNormal;
    final titleSize = compact
        ? _ListCardConstants.titleFontSizeCompact
        : _ListCardConstants.titleFontSizeNormal;
    final subtitleSize = compact
        ? _ListCardConstants.subtitleFontSizeCompact
        : _ListCardConstants.subtitleFontSizeNormal;

    return Semantics(
      label: '$title: $subtitle${showUnreadIndicator ? ', непрочитано' : ''}',
      button: onTap != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.card),
          hoverColor: typeColor.withValues(alpha: _ListCardConstants.hoverAlpha),
          splashColor: typeColor.withValues(alpha: _ListCardConstants.splashAlpha),
          highlightColor: typeColor.withValues(alpha: _ListCardConstants.highlightAlpha),
          child: Ink(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: _ListCardConstants.bgAlpha),
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(
                color: typeColor.withValues(alpha: _ListCardConstants.borderAlpha),
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
                    color: typeColor.withValues(alpha: _ListCardConstants.badgeAlpha),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: typeColor,
                  ),
                ),

                SizedBox(width: compact ? AppSpacing.xs : AppSpacing.xs + 2),

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
                              padding: EdgeInsets.symmetric(
                                horizontal: _ListCardConstants.badgePaddingH,
                                vertical: _ListCardConstants.badgePaddingV,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor.withValues(alpha: _ListCardConstants.badgeAlpha),
                                borderRadius: BorderRadius.circular(_ListCardConstants.badgeRadius),
                              ),
                              child: Text(
                                badge!,
                                style: TextStyle(
                                  fontSize: _ListCardConstants.badgeFontSize,
                                  fontWeight: FontWeight.w700,
                                  color: typeColor,
                                ),
                              ),
                            ),
                          if (trailing != null)
                            Text(
                              trailing!,
                              style: TextStyle(
                                fontSize: _ListCardConstants.trailingFontSize,
                                color: colors.textMuted,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: compact ? AppSpacing.xxs / 2 : AppSpacing.xxs),
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
                  SizedBox(width: AppSpacing.xs),
                  Container(
                    width: _ListCardConstants.unreadIndicatorSize,
                    height: _ListCardConstants.unreadIndicatorSize,
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
      height: _SeeMoreConstants.height,
      backgroundColor: colors.buttonBg,
      hoverColor: colors.buttonHover,
      child: Center(
        child: Text(
          _text,
          style: TextStyle(
            fontSize: _SeeMoreConstants.fontSize,
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

    return Semantics(
      label: '$title. $subtitle',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: compact
                  ? _EmptyStateConstants.iconSizeCompact
                  : _EmptyStateConstants.iconSizeNormal,
              color: color.withValues(alpha: _EmptyStateConstants.iconAlpha),
            ),
            SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
            Text(
              title,
              style: TextStyle(
                fontSize: compact
                    ? _EmptyStateConstants.titleFontSizeCompact
                    : _EmptyStateConstants.titleFontSizeNormal,
                fontWeight: FontWeight.w600,
                color: colors.textMuted,
              ),
            ),
            if (!compact) ...[
              SizedBox(height: AppSpacing.xxs),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: _EmptyStateConstants.subtitleFontSize,
                  color: colors.textMuted.withValues(alpha: _EmptyStateConstants.subtitleAlpha),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
