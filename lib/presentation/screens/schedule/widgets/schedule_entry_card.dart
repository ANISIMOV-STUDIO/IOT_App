/// Schedule Entry Card - Individual schedule item display
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';
import 'package:hvac_control/presentation/widgets/breez/schedule_widget.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _ScheduleEntryCardConstants {
  static const double fontSize = 14;
  static const double fontSizeSmall = 12;
  static const double fontSizeMedium = 13;
  static const double iconSizeSmall = 16;
  static const double iconSizeMedium = 18;
  static const double modeIconContainerSize = 36;
  static const double badgePaddingHorizontal = 12;
  static const double badgePaddingVertical = 6;
}

/// Карточка записи расписания
class ScheduleEntryCard extends StatelessWidget {

  const ScheduleEntryCard({
    required this.entry, required this.onEdit, required this.onDelete, required this.onToggle, super.key,
  });
  final ScheduleEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

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

  Widget _buildHeaderRow(BreezColors colors) => Row(
      children: [
        _DayBadge(day: entry.day, isActive: entry.isActive),
        const SizedBox(width: AppSpacing.sm),
        _TimeRange(timeRange: entry.timeRange),
        const Spacer(),
        _ActiveSwitch(isActive: entry.isActive, onToggle: onToggle),
      ],
    );

  Widget _buildModeRow(BreezColors colors, AppLocalizations l10n) => Row(
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
        BreezIconButton(
          icon: Icons.edit_outlined,
          iconColor: colors.textMuted,
          backgroundColor: Colors.transparent,
          showBorder: false,
          compact: true,
          onTap: onEdit,
          tooltip: l10n.tooltipEdit,
          semanticLabel: l10n.tooltipEdit,
        ),
        BreezIconButton(
          icon: Icons.delete_outline,
          iconColor: Colors.red,
          backgroundColor: Colors.transparent,
          showBorder: false,
          compact: true,
          onTap: onDelete,
          tooltip: l10n.tooltipDelete,
          semanticLabel: l10n.tooltipDelete,
        ),
      ],
    );
}

/// Badge showing day name
class _DayBadge extends StatelessWidget {

  const _DayBadge({required this.day, required this.isActive});
  final String day;
  final bool isActive;

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

  const _TimeRange({required this.timeRange});
  final String timeRange;

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

  const _ActiveSwitch({required this.isActive, required this.onToggle});
  final bool isActive;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) => Switch(
      value: isActive,
      onChanged: onToggle,
      activeTrackColor: AppColors.accent,
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.white;
        }
        return null;
      }),
    );
}

/// Mode icon container
class _ModeIcon extends StatelessWidget {

  const _ModeIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
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
