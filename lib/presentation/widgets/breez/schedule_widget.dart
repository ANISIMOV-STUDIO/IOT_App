/// Schedule Widget - Weekly schedule display
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../domain/entities/schedule_entry.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';

export '../../../domain/entities/schedule_entry.dart';

/// Weekly schedule widget
class ScheduleWidget extends StatelessWidget {
  final List<ScheduleEntry> entries;
  final VoidCallback? onSeeAll;
  final ValueChanged<int>? onEntryTap;

  const ScheduleWidget({
    super.key,
    required this.entries,
    this.onSeeAll,
    this.onEntryTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.schedule,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.text,
                ),
              ),
              if (entries.length > 3)
                BreezButton(
                  onTap: onSeeAll,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                  hoverColor: AppColors.accent.withValues(alpha: 0.15),
                  showBorder: false,
                  child: Text(
                    l10n.allCount(entries.length - 3),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Schedule entries (flexible, max 3 visible)
          Expanded(
            child: entries.isEmpty
                ? _EmptyState()
                : Column(
              children: entries.take(3).toList().asMap().entries.map((entry) {
                final index = entry.key;
                final scheduleEntry = entry.value;
                return Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: index < 2 ? 4 : 0),
                    child: _ScheduleRow(
                      entry: scheduleEntry,
                      onTap: () => onEntryTap?.call(index),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Active schedule highlight (compact)
          if (entries.isNotEmpty && entries.any((e) => e.isActive))
            _ActiveScheduleCard(
              entry: entries.firstWhere((e) => e.isActive),
            ),
        ],
      ),
    );
  }
}

/// Individual schedule row
class _ScheduleRow extends StatelessWidget {
  final ScheduleEntry entry;
  final VoidCallback? onTap;

  const _ScheduleRow({
    required this.entry,
    this.onTap,
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
    return BreezButton(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      backgroundColor: Colors.transparent,
      hoverColor: colors.buttonBg,
      showBorder: false,
      enableScale: false,
      child: Row(
        children: [
          // Day
          SizedBox(
            width: 80,
            child: Text(
              entry.day,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: entry.isActive ? colors.text : colors.textMuted,
              ),
            ),
          ),

          // Mode icon
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Icon(
              _getModeIcon(),
              size: 14,
              color: AppColors.accent,
            ),
          ),

          const SizedBox(width: 10),

          // Mode name
          Expanded(
            child: Text(
              entry.mode,
              style: TextStyle(
                fontSize: 12,
                color: colors.textMuted,
              ),
            ),
          ),

          // Temperature range
          Text(
            '${entry.tempDay}° / ${entry.tempNight}°',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// Active schedule card (highlighted)
class _ActiveScheduleCard extends StatelessWidget {
  final ScheduleEntry entry;

  const _ActiveScheduleCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.accent,
            AppColors.accentLight,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            l10n.nowLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: const Icon(
              Icons.wb_cloudy_outlined,
              size: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              entry.mode,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            '${entry.tempDay}° / ${entry.tempNight}°',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state for schedule
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 40,
            color: AppColors.accent.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noSchedule,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.addScheduleForDevice,
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
