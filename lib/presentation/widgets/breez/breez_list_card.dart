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

/// Unified list item card used for alarms, notifications, and similar lists
class BreezListCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final String? trailing;
  final ListCardType type;
  final VoidCallback? onTap;
  final bool showUnreadIndicator;

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
  });

  /// Factory for alarm card
  factory BreezListCard.alarm({
    Key? key,
    required String code,
    required String description,
    required AppLocalizations l10n,
    VoidCallback? onTap,
  }) {
    return BreezListCard(
      key: key,
      icon: Icons.error_outline,
      title: l10n.alarmCode(code),
      subtitle: description,
      badge: l10n.activeAlarm,
      type: ListCardType.error,
      onTap: onTap,
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        hoverColor: typeColor.withValues(alpha: 0.12),
        splashColor: typeColor.withValues(alpha: 0.2),
        highlightColor: typeColor.withValues(alpha: 0.1),
        child: Ink(
          padding: const EdgeInsets.all(12),
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
              // Icon container
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: typeColor,
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
                            title,
                            style: TextStyle(
                              fontSize: 12,
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
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Unread indicator
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

/// Empty state widget for lists
class BreezEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const BreezEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  });

  /// Factory for no alarms state
  factory BreezEmptyState.noAlarms(AppLocalizations l10n) {
    return BreezEmptyState(
      icon: Icons.check_circle_outline,
      title: l10n.noAlarms,
      subtitle: l10n.systemWorkingNormally,
      iconColor: AppColors.accentGreen,
    );
  }

  /// Factory for no notifications state
  factory BreezEmptyState.noNotifications(AppLocalizations l10n) {
    return BreezEmptyState(
      icon: Icons.check_circle_outline,
      title: l10n.noNotifications,
      subtitle: l10n.systemWorkingNormally,
      iconColor: AppColors.accentGreen,
    );
  }

  /// Factory for no schedule entries
  factory BreezEmptyState.noSchedule(AppLocalizations l10n) {
    return BreezEmptyState(
      icon: Icons.schedule_outlined,
      title: l10n.noSchedule,
      subtitle: l10n.addFirstEntry,
      iconColor: AppColors.accent,
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
            size: 40,
            color: color.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: colors.textMuted.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
