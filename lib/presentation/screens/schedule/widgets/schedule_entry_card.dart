/// Schedule Entry Card - Individual schedule item display
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../generated/l10n/app_localizations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/spacing.dart';
import '../../../widgets/breez/breez_card.dart';
import '../../../widgets/breez/schedule_widget.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _ScheduleEntryCardConstants {
  static const double fontSize = 14.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 13.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 18.0;
  static const double modeIconContainerSize = 36.0;
  static const double badgePaddingHorizontal = 12.0;
  static const double badgePaddingVertical = 6.0;
}

/// Карточка записи расписания
class ScheduleEntryCard extends StatelessWidget {
  final ScheduleEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const ScheduleEntryCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  IconData _getModeIcon() {
    switch (entry.mode.toLowerCase()) {
      case 'cooling':
        return Icons.ac_unit;
      case 'heating':
        return Icons.whatshot;
      case 'ventilation':
        return Icons.air;
      case 'auto':
        return Icons.autorenew;
      case 'eco':
        return Icons.eco;
      default:
        return Icons.thermostat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(colors),
          const SizedBox(height: AppSpacing.sm),
          _buildModeRow(colors, l10n),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(BreezColors colors) {
    return Row(
      children: [
        _DayBadge(day: entry.day, isActive: entry.isActive),
        const SizedBox(width: AppSpacing.sm),
        _TimeRange(timeRange: entry.timeRange),
        const Spacer(),
        _ActiveSwitch(isActive: entry.isActive, onToggle: onToggle),
      ],
    );
  }

  Widget _buildModeRow(BreezColors colors, AppLocalizations l10n) {
    return Row(
      children: [
        _ModeIcon(icon: _getModeIcon()),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.mode,
                style: TextStyle(
                  fontSize: _ScheduleEntryCardConstants.fontSize,
                  fontWeight: FontWeight.w500,
                  color: colors.text,
                ),
              ),
              Text(
                l10n.scheduleDayNightTemp(entry.tempDay, entry.tempNight),
                style: TextStyle(
                  fontSize: _ScheduleEntryCardConstants.fontSizeSmall,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit_outlined, color: colors.textMuted),
          onPressed: onEdit,
          tooltip: l10n.tooltipEdit,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
          tooltip: l10n.tooltipDelete,
        ),
      ],
    );
  }
}

/// Badge showing day name
class _DayBadge extends StatelessWidget {
  final String day;
  final bool isActive;

  const _DayBadge({required this.day, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _ScheduleEntryCardConstants.badgePaddingHorizontal,
        vertical: _ScheduleEntryCardConstants.badgePaddingVertical,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.accent.withValues(alpha: 0.15)
            : colors.buttonBg,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      child: Text(
        ScheduleWidget.translateDayName(day, l10n),
        style: TextStyle(
          fontSize: _ScheduleEntryCardConstants.fontSizeMedium,
          fontWeight: FontWeight.w600,
          color: isActive ? AppColors.accent : colors.text,
        ),
      ),
    );
  }
}

/// Time range display
class _TimeRange extends StatelessWidget {
  final String timeRange;

  const _TimeRange({required this.timeRange});

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time,
          size: _ScheduleEntryCardConstants.iconSizeSmall,
          color: colors.textMuted,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          timeRange,
          style: TextStyle(
            fontSize: _ScheduleEntryCardConstants.fontSizeMedium,
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }
}

/// Active toggle switch
class _ActiveSwitch extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onToggle;

  const _ActiveSwitch({required this.isActive, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isActive,
      onChanged: onToggle,
      activeTrackColor: AppColors.accent,
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return null;
      }),
    );
  }
}

/// Mode icon container
class _ModeIcon extends StatelessWidget {
  final IconData icon;

  const _ModeIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _ScheduleEntryCardConstants.modeIconContainerSize,
      height: _ScheduleEntryCardConstants.modeIconContainerSize,
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Icon(
        icon,
        size: _ScheduleEntryCardConstants.iconSizeMedium,
        color: AppColors.accent,
      ),
    );
  }
}
