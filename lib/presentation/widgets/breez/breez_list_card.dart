/// Breez List Card - Unified card for list items (alarms, notifications, etc.)
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/device_event_log.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart'; // BreezButton

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezListCard
abstract class _ListCardConstants {
  // Размеры для нормального режима
  static const double iconContainerSizeNormal = 32;
  static const double iconSizeNormal = 16;
  static const double paddingNormal = 12;
  static const double titleFontSizeNormal = 12;
  static const double subtitleFontSizeNormal = 11;

  // Размеры для компактного режима
  static const double iconContainerSizeCompact = 24;
  static const double iconSizeCompact = 12;
  static const double paddingCompact = 8;
  static const double titleFontSizeCompact = 11;
  static const double subtitleFontSizeCompact = 10;

  // Общие
  static const double badgeFontSize = 9;
  static const double badgePaddingH = 6;
  static const double badgePaddingV = 2;
  static const double badgeRadius = 4;
  static const double trailingFontSize = 10;
  static const double unreadIndicatorSize = 8;

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
  static const double iconSizeNormal = 40;
  static const double iconSizeCompact = 28;
  static const double titleFontSizeNormal = 13;
  static const double titleFontSizeCompact = 11;
  static const double subtitleFontSize = 11;
  static const double iconAlpha = 0.5;
  static const double subtitleAlpha = 0.7;
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

  const BreezListCard({
    required this.icon, required this.title, required this.subtitle, super.key,
    this.badge,
    this.trailing,
    this.type = ListCardType.info,
    this.onTap,
    this.showUnreadIndicator = false,
    this.compact = false,
  });

  /// Factory для карточки лога событий
  factory BreezListCard.log({
    required DeviceEventLog log, required String formattedTime, Key? key,
    VoidCallback? onTap,
    bool compact = false,
  }) {
    final isAlarm = log.eventType == DeviceEventType.alarm;
    return BreezListCard(
      key: key,
      icon: isAlarm ? Icons.warning_amber : Icons.settings_outlined,
      title: log.property,
      subtitle: log.description.isNotEmpty ? log.description : log.newValue,
      trailing: formattedTime,
      type: isAlarm ? ListCardType.error : ListCardType.info,
      onTap: onTap,
      compact: compact,
    );
  }

  /// Фабрика для карточки аварии
  factory BreezListCard.alarm({
    required String code, required String description, required AppLocalizations l10n, Key? key,
    VoidCallback? onTap,
    bool compact = false,
  }) => BreezListCard(
      key: key,
      icon: Icons.error_outline,
      title: l10n.alarmCode(code),
      subtitle: description,
      badge: compact ? null : l10n.activeAlarm,
      type: ListCardType.error,
      onTap: onTap,
      compact: compact,
    );

  /// Factory for notification card
  factory BreezListCard.notification({
    required String title, required String message, required ListCardType type, Key? key,
    String? timeAgo,
    bool isRead = true,
    VoidCallback? onTap,
  }) => BreezListCard(
      key: key,
      icon: _iconForType(type),
      title: title,
      subtitle: message,
      trailing: timeAgo,
      type: type,
      showUnreadIndicator: !isRead,
      onTap: onTap,
    );
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final String? trailing;
  final ListCardType type;
  final VoidCallback? onTap;
  final bool showUnreadIndicator;
  final bool compact;

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
                              padding: const EdgeInsets.symmetric(
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
                  const SizedBox(width: AppSpacing.xs),
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

  const BreezSeeMoreButton({
    required this.label, super.key,
    this.extraCount,
    this.onTap,
  });
  final String label;
  final int? extraCount;
  final VoidCallback? onTap;

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
      height: AppSizes.buttonHeightSmall,
      backgroundColor: colors.buttonBg,
      hoverColor: colors.buttonHover,
      child: Center(
        child: Text(
          _text,
          style: const TextStyle(
            fontSize: AppFontSizes.caption,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }
}

/// Компактная кнопка-действие (chip) для inline-использования в заголовках
///
/// Поддерживает обычный (accent) и danger (red) стили.
class BreezActionChip extends StatelessWidget {
  const BreezActionChip({
    required this.label,
    required this.onTap,
    super.key,
    this.isDanger = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final accentColor = isDanger ? AppColors.accentRed : AppColors.accent;

    return BreezButton(
      onTap: onTap,
      backgroundColor: accentColor.withValues(alpha: 0.1),
      hoverColor: accentColor.withValues(alpha: 0.2),
      borderRadius: AppRadius.nested,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      showBorder: false,
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppFontSizes.captionSmall,
          fontWeight: FontWeight.w600,
          color: accentColor,
        ),
      ),
    );
  }
}

/// Кнопка сброса/опасного действия на всю ширину (аналог BreezSeeMoreButton)
///
/// Используется внизу списков для danger-действий.
class BreezResetButton extends StatelessWidget {
  const BreezResetButton({
    required this.label,
    super.key,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return BreezButton(
      onTap: onTap,
      width: double.infinity,
      height: AppSizes.buttonHeightSmall,
      backgroundColor: colors.buttonBg,
      hoverColor: AppColors.accentRed.withValues(alpha: 0.15),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: AppFontSizes.caption,
            fontWeight: FontWeight.w600,
            color: AppColors.accentRed,
          ),
        ),
      ),
    );
  }
}

/// Заголовок секции с иконкой и опциональным trailing (счётчик, бейдж)
///
/// Высота определяется контентом. Используется для заголовков списков
/// (аварии, уведомления, расписание, график и т.д.)
class BreezSectionHeader extends StatelessWidget {
  const BreezSectionHeader({
    required this.icon,
    required this.title,
    super.key,
    this.iconColor,
    this.trailing,
    this.leading,
    this.large = false,
  });

  /// Фабрика для заголовка секции аварий
  factory BreezSectionHeader.alarms({
    required String title,
    required int count,
    Key? key,
  }) => BreezSectionHeader(
      key: key,
      icon: count == 0 ? Icons.check_circle_outline : Icons.warning_amber_rounded,
      title: title,
      iconColor: count == 0 ? AppColors.accentGreen : AppColors.accentRed,
      trailing: count > 0 ? _CountBadge(count: count, color: AppColors.accentRed) : null,
    );

  /// Фабрика для заголовка секции уведомлений
  factory BreezSectionHeader.notifications({
    required String title,
    required int count,
    Key? key,
  }) => BreezSectionHeader(
      key: key,
      icon: Icons.notifications_outlined,
      title: title,
      iconColor: AppColors.accent,
      trailing: count > 0 ? _CountBadge(count: count, color: AppColors.accentRed) : null,
    );

  /// Фабрика для заголовка секции расписания
  factory BreezSectionHeader.schedule({
    required String title,
    Key? key,
    Widget? trailing,
  }) => BreezSectionHeader(
      key: key,
      icon: Icons.schedule_outlined,
      title: title,
      iconColor: AppColors.accent,
      trailing: trailing,
    );

  /// Фабрика для заголовка экрана с кнопкой назад
  factory BreezSectionHeader.screen({
    required String title,
    required IconData icon,
    required Widget backButton,
    Key? key,
    Widget? trailing,
  }) => BreezSectionHeader(
      key: key,
      icon: icon,
      title: title,
      iconColor: AppColors.accent,
      leading: backButton,
      trailing: trailing,
      large: true,
    );

  /// Фабрика для заголовка диалога с кнопкой закрытия
  factory BreezSectionHeader.dialog({
    required String title,
    required IconData icon,
    required VoidCallback onClose,
    required String closeLabel,
    Key? key,
  }) => BreezSectionHeader(
      key: key,
      icon: icon,
      title: title,
      iconColor: AppColors.accent,
      trailing: _DialogCloseButton(onClose: onClose, label: closeLabel),
    );

  final IconData icon;
  final String title;
  final Color? iconColor;
  final Widget? trailing;
  final Widget? leading;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final color = iconColor ?? AppColors.accent;
    final fontSize = large ? AppFontSizes.h2 : AppFontSizes.h4;
    final iconSize = large ? AppFontSizes.h3 : AppFontSizes.h4;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: AppSpacing.xs),
        ],
        // Иконка + заголовок центрированы между собой
        Expanded(
          child: Row(
            children: [
              Icon(
                icon,
                size: iconSize,
                color: color,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: colors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Бейдж со счётчиком для BreezSectionHeader
class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.count,
    required this.color,
  });

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppColors.opacitySubtle),
        borderRadius: BorderRadius.circular(AppRadius.nested),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: AppFontSizes.captionSmall,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
}

/// Кнопка закрытия для заголовка диалога
class _DialogCloseButton extends StatelessWidget {
  const _DialogCloseButton({
    required this.onClose,
    required this.label,
  });

  static const double _iconSize = 18;
  static const double _padding = 6;

  final VoidCallback onClose;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return BreezButton(
      onTap: onClose,
      enforceMinTouchTarget: false,
      showBorder: false,
      backgroundColor: colors.buttonBg.withValues(alpha: AppColors.opacityMedium),
      hoverColor: colors.text.withValues(alpha: AppColors.opacitySubtle),
      padding: const EdgeInsets.all(_padding),
      semanticLabel: label,
      child: Icon(
        Icons.close,
        size: _iconSize,
        color: colors.textMuted,
      ),
    );
  }
}

// =============================================================================
// BREEZ BADGE
// =============================================================================

/// Универсальный badge с цветным фоном и рамкой
///
/// Используется для статусов, меток, счётчиков.
/// Автоматически применяет opacity к цвету для фона и рамки.
class BreezBadge extends StatelessWidget {
  const BreezBadge({
    required this.color,
    required this.child,
    super.key,
    this.padding,
    this.backgroundOpacity = AppColors.opacitySubtle,
    this.borderOpacity = AppColors.opacityLow,
    this.borderRadius = AppRadius.button,
    this.showBorder = true,
  });

  /// Фабрика для статус-badge (иконка + текст)
  factory BreezBadge.status({
    required Color color,
    required IconData icon,
    required String label,
    Key? key,
    double iconSize = AppFontSizes.caption,
    double fontSize = AppFontSizes.captionSmall,
  }) => BreezBadge(
      key: key,
      color: color,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );

  /// Фабрика для простого текстового badge
  factory BreezBadge.text({
    required Color color,
    required String text,
    Key? key,
    double fontSize = AppFontSizes.captionSmall,
    FontWeight fontWeight = FontWeight.w600,
  }) => BreezBadge(
      key: key,
      color: color,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );

  /// Фабрика для badge с точкой-индикатором
  factory BreezBadge.dot({
    required Color color,
    required String label,
    Key? key,
    double dotSize = 6,
    double fontSize = AppFontSizes.captionSmall,
  }) => BreezBadge(
      key: key,
      color: color,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );

  final Color color;
  final Widget child;
  final EdgeInsets? padding;
  final double backgroundOpacity;
  final double borderOpacity;
  final double borderRadius;
  final bool showBorder;

  @override
  Widget build(BuildContext context) => Container(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: backgroundOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(color: color.withValues(alpha: borderOpacity))
            : null,
      ),
      child: child,
    );
}

// =============================================================================
// EMPTY STATE
// =============================================================================

/// Виджет пустого состояния для списков
class BreezEmptyState extends StatelessWidget {

  const BreezEmptyState({
    required this.icon, required this.title, required this.subtitle, super.key,
    this.iconColor,
    this.compact = false,
  });

  /// Фабрика для пустого списка аварий
  factory BreezEmptyState.noAlarms(AppLocalizations l10n, {bool compact = false}) => BreezEmptyState(
      icon: Icons.check_circle_outline,
      title: l10n.noAlarms,
      subtitle: l10n.systemWorkingNormally,
      iconColor: AppColors.accentGreen,
      compact: compact,
    );

  /// Фабрика для пустого списка уведомлений
  factory BreezEmptyState.noNotifications(AppLocalizations l10n, {bool compact = false}) => BreezEmptyState(
      icon: Icons.check_circle_outline,
      title: l10n.noNotifications,
      subtitle: l10n.systemWorkingNormally,
      iconColor: AppColors.accentGreen,
      compact: compact,
    );

  /// Фабрика для пустого расписания
  factory BreezEmptyState.noSchedule(AppLocalizations l10n, {bool compact = false}) => BreezEmptyState(
      icon: Icons.schedule_outlined,
      title: l10n.noSchedule,
      subtitle: l10n.addFirstEntry,
      iconColor: AppColors.accent,
      compact: compact,
    );
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final bool compact;

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
              const SizedBox(height: AppSpacing.xxs),
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
