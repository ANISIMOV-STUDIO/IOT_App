/// Main Temperature Card Header - Header section with date, unit name, alarms, controls
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';

/// Header section of MainTempCard with date, unit name, alarm badge, and controls
class MainTempCardHeader extends StatelessWidget {
  final String unitName;
  final String? status;
  final bool isPowered;
  final bool showControls;
  final int alarmCount;
  final bool isPowerLoading;
  final bool isScheduleEnabled;
  final bool isScheduleLoading;
  final VoidCallback? onPowerToggle;
  final VoidCallback? onScheduleToggle;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onAlarmsTap;
  final bool isOnline;

  const MainTempCardHeader({
    super.key,
    required this.unitName,
    this.status,
    required this.isPowered,
    this.showControls = false,
    this.alarmCount = 0,
    this.isPowerLoading = false,
    this.isScheduleEnabled = false,
    this.isScheduleLoading = false,
    this.onPowerToggle,
    this.onScheduleToggle,
    this.onSettingsTap,
    this.onAlarmsTap,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Date and unit name
        _DateUnitSection(
          unitName: unitName,
          colors: colors,
          l10n: l10n,
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
            isPowerLoading: isPowerLoading,
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

/// Date section (without unit name - it's in the header)
class _DateUnitSection extends StatelessWidget {
  final String unitName;
  final BreezColors colors;
  final AppLocalizations l10n;

  const _DateUnitSection({
    required this.unitName,
    required this.colors,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat('d MMM', locale);
    final dateText = l10n.todayDate(dateFormat.format(DateTime.now()));

    return Text(
      dateText,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colors.textMuted,
      ),
    );
  }
}

/// Alarm badge widget
class _AlarmBadge extends StatelessWidget {
  final int alarmCount;
  final VoidCallback? onTap;

  const _AlarmBadge({
    required this.alarmCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.xs),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
          decoration: BoxDecoration(
            color: AppColors.accentRed.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(
              color: AppColors.accentRed.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 12,
                color: AppColors.accentRed,
              ),
              SizedBox(width: AppSpacing.xxs),
              Text(
                '$alarmCount',
                style: const TextStyle(
                  fontSize: 10,
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
}

/// Controls section with settings, schedule, and power buttons
class _ControlsSection extends StatelessWidget {
  final bool isPowered;
  final bool isPowerLoading;
  final bool isScheduleEnabled;
  final bool isScheduleLoading;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onScheduleToggle;
  final VoidCallback? onPowerToggle;
  final bool isOnline;

  const _ControlsSection({
    required this.isPowered,
    required this.isPowerLoading,
    this.isScheduleEnabled = false,
    this.isScheduleLoading = false,
    this.onSettingsTap,
    this.onScheduleToggle,
    this.onPowerToggle,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    // Цвет кнопок серый если offline
    final mutedColor = colors.textMuted;
    
    return Row(
      children: [
        BreezIconButton(
          icon: Icons.settings_outlined,
          iconColor: isOnline ? null : mutedColor,
          onTap: onSettingsTap,
        ),
        SizedBox(width: AppSpacing.xs),
        // Schedule toggle button
        if (isScheduleLoading)
          const SizedBox(
            width: 32,
            height: 32,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
          )
        else
          BreezIconButton(
            icon: Icons.schedule,
            iconColor: !isOnline ? mutedColor : isScheduleEnabled ? AppColors.accentGreen : mutedColor,
            onTap: onScheduleToggle,
          ),
        SizedBox(width: AppSpacing.xs),
        // Power toggle button
        if (isPowerLoading)
          const SizedBox(
            width: 32,
            height: 32,
            child: Padding(
              padding: EdgeInsets.all(6),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
          )
        else
          BreezIconButton(
            icon: Icons.power_settings_new,
            iconColor: !isOnline ? mutedColor : isPowered ? AppColors.accentGreen : mutedColor,
            onTap: onPowerToggle,
          ),
      ],
    );
  }
}

/// Status badge showing powered state
class _StatusBadge extends StatelessWidget {
  final bool isPowered;
  final String? status;
  final AppLocalizations l10n;

  const _StatusBadge({
    required this.isPowered,
    this.status,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isPowered ? AppColors.accentGreen : AppColors.accentRed;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
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
          SizedBox(width: AppSpacing.xxs),
          Text(
            status ?? l10n.statusRunning,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
