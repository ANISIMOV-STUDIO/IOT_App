/// Main Temperature Card Header - Header section with date, unit name, alarms, controls
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_loader.dart';
import 'package:intl/intl.dart';

/// Header section of MainTempCard with date, unit name, alarm badge, and controls
class MainTempCardHeader extends StatelessWidget {

  const MainTempCardHeader({
    required this.unitName,
    required this.isPowered,
    super.key,
    this.status,
    this.showControls = false,
    this.alarmCount = 0,
    this.isScheduleEnabled = false,
    this.isScheduleLoading = false,
    this.onPowerToggle,
    this.onScheduleToggle,
    this.onSettingsTap,
    this.onAlarmsTap,
    this.isOnline = true,
    this.updatedAt,
  });
  final String unitName;
  final String? status;
  final bool isPowered;
  final bool showControls;
  final int alarmCount;
  final bool isScheduleEnabled;
  final bool isScheduleLoading;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onScheduleToggle;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onAlarmsTap;
  final bool isOnline;
  /// Время последней синхронизации с сервером
  final DateTime? updatedAt;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sync time
        _SyncTimeSection(
          colors: colors,
          updatedAt: updatedAt,
        ),
        // Alarm badge (if any)
        if (alarmCount > 0)
          _AlarmBadge(
            alarmCount: alarmCount,
            onTap: onAlarmsTap,
          ),
        // Controls or Status badge
        if (showControls)
          _ControlsSection(
            isPowered: isPowered,
            isScheduleEnabled: isScheduleEnabled,
            isScheduleLoading: isScheduleLoading,
            onSettingsTap: onSettingsTap,
            onScheduleToggle: onScheduleToggle,
            onPowerToggle: onPowerToggle,
            isOnline: isOnline,
          )
        else
          _StatusBadge(
            isPowered: isPowered,
            status: status,
            l10n: l10n,
          ),
      ],
    );
  }
}

/// Sync time section - показывает время последней синхронизации
class _SyncTimeSection extends StatelessWidget {

  const _SyncTimeSection({
    required this.colors,
    this.updatedAt,
  });
  final BreezColors colors;
  final DateTime? updatedAt;

  @override
  Widget build(BuildContext context) {
    if (updatedAt == null) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final formattedDateTime = _formatRelativeDateTime(updatedAt!, l10n);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.buttonBg.withValues(alpha: AppColors.opacityLow),
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sync,
            size: AppIconSizes.standard,
            color: colors.textMuted,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            formattedDateTime,
            style: TextStyle(
              fontSize: AppFontSizes.captionSmall,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  /// Форматирует дату относительно: X мин назад, вчера в 13:20, 2 дня назад
  String _formatRelativeDateTime(DateTime dateTime, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    final timeFormat = DateFormat('HH:mm');
    final time = timeFormat.format(dateTime);

    // Менее минуты назад
    if (difference.inMinutes < 1) {
      return l10n.syncedJustNow;
    }

    // Менее часа назад
    if (difference.inHours < 1) {
      return l10n.syncedMinutesAgo(difference.inMinutes);
    }

    // Сегодня (менее 24 часов и тот же день)
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (dateDay == today) {
      return l10n.syncedHoursAgo(difference.inHours);
    }

    // Вчера
    final yesterday = today.subtract(const Duration(days: 1));
    if (dateDay == yesterday) {
      return l10n.syncedYesterdayAt(time);
    }

    // До 7 дней назад
    if (difference.inDays <= 7) {
      return l10n.syncedDaysAgoAt(difference.inDays, time);
    }

    // Старше недели - показываем дату
    final dateFormat = DateFormat('dd.MM');
    return l10n.syncedAt(dateFormat.format(dateTime), time);
  }
}

/// Alarm badge widget
class _AlarmBadge extends StatelessWidget {

  const _AlarmBadge({
    required this.alarmCount,
    this.onTap,
  });
  final int alarmCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
          decoration: BoxDecoration(
            color: AppColors.accentRed.withValues(alpha: AppColors.opacitySubtle),
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(
              color: AppColors.accentRed.withValues(alpha: AppColors.opacityLow),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: AppIconSizes.standard,
                color: AppColors.accentRed,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '$alarmCount',
                style: const TextStyle(
                  fontSize: AppFontSizes.captionSmall,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
}

/// Controls section with settings, schedule, and power buttons
class _ControlsSection extends StatelessWidget {

  const _ControlsSection({
    required this.isPowered,
    this.isScheduleEnabled = false,
    this.isScheduleLoading = false,
    this.onSettingsTap,
    this.onScheduleToggle,
    this.onPowerToggle,
    this.isOnline = true,
  });
  final bool isPowered;
  final bool isScheduleEnabled;
  final bool isScheduleLoading;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onScheduleToggle;
  final VoidCallback? onPowerToggle;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    // Цвет кнопок серый если offline
    final mutedColor = colors.textMuted;
    
    return Row(
      children: [
        // Power toggle button
        BreezIconButton(
          icon: Icons.power_settings_new,
          iconColor: !isOnline ? mutedColor : isPowered ? AppColors.accentGreen : mutedColor,
          onTap: onPowerToggle,
        ),
        const SizedBox(width: AppSpacing.xs),
        // Schedule toggle button
        if (isScheduleLoading)
          const SizedBox(
            width: 32,
            height: 32,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xs),
              child: BreezLoader.small(),
            ),
          )
        else
          BreezIconButton(
            icon: Icons.schedule,
            iconColor: !isOnline ? mutedColor : isScheduleEnabled ? AppColors.accentGreen : mutedColor,
            onTap: onScheduleToggle,
          ),
        const SizedBox(width: AppSpacing.xs),
        BreezIconButton(
          icon: Icons.settings_outlined,
          iconColor: isOnline ? null : mutedColor,
          onTap: onSettingsTap,
        ),
      ],
    );
  }
}

/// Status badge showing powered state
class _StatusBadge extends StatelessWidget {

  const _StatusBadge({
    required this.isPowered,
    required this.l10n,
    this.status,
  });
  final bool isPowered;
  final String? status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final statusColor = isPowered ? AppColors.accentGreen : AppColors.accentRed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: AppColors.opacitySubtle),
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(
          color: statusColor.withValues(alpha: AppColors.opacityLow),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            status ?? l10n.statusRunning,
            style: TextStyle(
              fontSize: AppFontSizes.captionSmall,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
