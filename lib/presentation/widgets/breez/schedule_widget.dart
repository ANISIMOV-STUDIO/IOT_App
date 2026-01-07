/// Schedule Widget - Weekly schedule display
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/schedule_entry.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';

export '../../../domain/entities/schedule_entry.dart';

/// Weekly schedule widget with day selector
class ScheduleWidget extends StatefulWidget {
  final List<ScheduleEntry> entries;
  final VoidCallback? onSeeAll;
  final VoidCallback? onAddEntry;
  final ValueChanged<ScheduleEntry>? onEntryTap;
  final bool compact;

  const ScheduleWidget({
    super.key,
    required this.entries,
    this.onSeeAll,
    this.onAddEntry,
    this.onEntryTap,
    this.compact = false,
  });

  /// Перевод английского названия дня недели в локализованное
  static String translateDayName(String englishDay, AppLocalizations l10n) {
    switch (englishDay.toLowerCase()) {
      case 'monday':
        return l10n.monday;
      case 'tuesday':
        return l10n.tuesday;
      case 'wednesday':
        return l10n.wednesday;
      case 'thursday':
        return l10n.thursday;
      case 'friday':
        return l10n.friday;
      case 'saturday':
        return l10n.saturday;
      case 'sunday':
        return l10n.sunday;
      default:
        return englishDay;
    }
  }

  /// Перевод локализованного названия дня в английское (для API)
  static String dayNameToEnglish(String localizedDay, AppLocalizations l10n) {
    if (localizedDay == l10n.monday) return 'monday';
    if (localizedDay == l10n.tuesday) return 'tuesday';
    if (localizedDay == l10n.wednesday) return 'wednesday';
    if (localizedDay == l10n.thursday) return 'thursday';
    if (localizedDay == l10n.friday) return 'friday';
    if (localizedDay == l10n.saturday) return 'saturday';
    if (localizedDay == l10n.sunday) return 'sunday';
    return localizedDay;
  }

  /// Короткие названия дней недели (локализованные)
  static String getShortDayName(String englishDay, AppLocalizations l10n) {
    switch (englishDay.toLowerCase()) {
      case 'monday':
        return l10n.mondayShort;
      case 'tuesday':
        return l10n.tuesdayShort;
      case 'wednesday':
        return l10n.wednesdayShort;
      case 'thursday':
        return l10n.thursdayShort;
      case 'friday':
        return l10n.fridayShort;
      case 'saturday':
        return l10n.saturdayShort;
      case 'sunday':
        return l10n.sundayShort;
      default:
        return englishDay.substring(0, 2);
    }
  }

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  String? _selectedDay;

  static const List<String> _daysOrder = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  @override
  void initState() {
    super.initState();
    // По умолчанию выбираем текущий день недели
    final now = DateTime.now();
    _selectedDay = _daysOrder[now.weekday - 1];
  }

  List<ScheduleEntry> get _filteredEntries {
    if (_selectedDay == null) return widget.entries;
    return widget.entries
        .where((e) => e.day.toLowerCase() == _selectedDay!.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: EdgeInsets.all(widget.compact ? AppSpacing.sm : AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title, "See All" and "Add" buttons
          if (!widget.compact) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.schedule,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.text,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Add button
                    if (widget.onAddEntry != null)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: BreezButton(
                          onTap: widget.onAddEntry,
                          padding: const EdgeInsets.all(AppSpacing.xxs + 2),
                          backgroundColor: AppColors.accent,
                          hoverColor: AppColors.accentLight,
                          showBorder: false,
                          enforceMinTouchTarget: false,
                          child: const Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    // See all button
                    BreezButton(
                      onTap: widget.onSeeAll ?? () {},
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs + 2,
                      ),
                      backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                      hoverColor: AppColors.accent.withValues(alpha: 0.15),
                      showBorder: false,
                      enforceMinTouchTarget: false,
                      child: Center(
                        child: Text(
                          l10n.seeAll,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Day selector
          _DaySelector(
            days: _daysOrder,
            selectedDay: _selectedDay,
            entries: widget.entries,
            compact: widget.compact,
            onDaySelected: (day) => setState(() => _selectedDay = day),
          ),

          SizedBox(height: widget.compact ? AppSpacing.xs : AppSpacing.sm),

          // Schedule entries with scroll
          Expanded(
            child: _filteredEntries.isEmpty
                ? GestureDetector(
                    onTap: widget.onAddEntry ?? widget.onSeeAll,
                    behavior: HitTestBehavior.opaque,
                    child: _EmptyDayState(
                      day: _selectedDay ?? 'monday',
                      compact: widget.compact,
                      showAddHint: widget.onAddEntry != null,
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: _filteredEntries.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: widget.compact ? AppSpacing.xs : AppSpacing.sm,
                    ),
                    itemBuilder: (context, index) {
                      final entry = _filteredEntries[index];
                      return _ScheduleRow(
                        entry: entry,
                        onTap: () => widget.onEntryTap?.call(entry),
                        compact: widget.compact,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Day selector row using BreezButton
class _DaySelector extends StatelessWidget {
  final List<String> days;
  final String? selectedDay;
  final List<ScheduleEntry> entries;
  final bool compact;
  final ValueChanged<String> onDaySelected;

  const _DaySelector({
    required this.days,
    required this.selectedDay,
    required this.entries,
    required this.compact,
    required this.onDaySelected,
  });

  bool _hasEntries(String day) {
    return entries.any((e) => e.day.toLowerCase() == day.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final spacing = compact ? AppSpacing.xs : AppSpacing.sm;

    final List<Widget> children = [];
    for (var i = 0; i < days.length; i++) {
      final day = days[i];
      final isSelected = selectedDay?.toLowerCase() == day.toLowerCase();
      final hasEntries = _hasEntries(day);
      final shortName = ScheduleWidget.getShortDayName(day, l10n);

      // Add spacing between buttons
      if (i > 0) {
        children.add(SizedBox(width: spacing));
      }

      children.add(
        Expanded(
          child: BreezButton(
            onTap: () => onDaySelected(day),
            padding: EdgeInsets.symmetric(
              vertical: compact ? AppSpacing.xxs + 2 : AppSpacing.xs,
              horizontal: 0,
            ),
            backgroundColor: isSelected
                ? AppColors.accent
                : hasEntries
                    ? AppColors.accent.withValues(alpha: 0.1)
                    : colors.buttonBg,
            hoverColor: isSelected
                ? AppColors.accent
                : hasEntries
                    ? AppColors.accent.withValues(alpha: 0.2)
                    : colors.buttonHover,
            showBorder: false,
            enableScale: false,
            enforceMinTouchTarget: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  shortName,
                  style: TextStyle(
                    fontSize: compact ? 10 : 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : hasEntries
                            ? AppColors.accent
                            : colors.textMuted,
                  ),
                ),
                if (hasEntries && !isSelected) ...[
                  const SizedBox(height: 2),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
                if (!hasEntries || isSelected)
                  const SizedBox(height: 6), // Placeholder for alignment
              ],
            ),
          ),
        ),
      );
    }

    return Row(children: children);
  }
}

/// Empty state for selected day
class _EmptyDayState extends StatelessWidget {
  final String day;
  final bool compact;
  final bool showAddHint;

  const _EmptyDayState({
    required this.day,
    required this.compact,
    this.showAddHint = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              showAddHint ? Icons.add_circle_outline : Icons.event_busy_outlined,
              size: compact ? 28 : 36,
              color: showAddHint
                  ? AppColors.accent.withValues(alpha: 0.6)
                  : colors.textMuted.withValues(alpha: 0.5),
            ),
            SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
            Text(
              'Нет записей на ${ScheduleWidget.translateDayName(day, l10n).toLowerCase()}',
              style: TextStyle(
                fontSize: compact ? 11 : 12,
                color: colors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            if (!compact) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                showAddHint ? 'Нажмите, чтобы добавить' : l10n.addFirstEntry,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.accent.withValues(alpha: 0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Individual schedule row
class _ScheduleRow extends StatelessWidget {
  final ScheduleEntry entry;
  final VoidCallback? onTap;
  final bool compact;

  const _ScheduleRow({
    required this.entry,
    this.onTap,
    this.compact = false,
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
    final iconSize = compact ? 24.0 : 32.0;
    final fontSize = compact ? 11.0 : 13.0;
    final smallFontSize = compact ? 10.0 : 12.0;

    return BreezButton(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: compact ? AppSpacing.xs : AppSpacing.sm,
      ),
      backgroundColor: entry.isActive
          ? AppColors.accent.withValues(alpha: 0.08)
          : colors.buttonBg,
      hoverColor: entry.isActive
          ? AppColors.accent.withValues(alpha: 0.15)
          : colors.buttonHover,
      showBorder: entry.isActive,
      border: entry.isActive
          ? Border.all(color: AppColors.accent.withValues(alpha: 0.3))
          : null,
      enableScale: false,
      child: Row(
        children: [
          // Time range
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? AppSpacing.xs - 2 : AppSpacing.xs,
              vertical: compact ? 3 : 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Text(
              entry.timeRange,
              style: TextStyle(
                fontSize: compact ? 9 : 10,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ),

          SizedBox(width: compact ? AppSpacing.xs : AppSpacing.sm),

          // Mode icon
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Icon(
              _getModeIcon(),
              size: compact ? 12 : 16,
              color: AppColors.accent,
            ),
          ),

          SizedBox(width: compact ? AppSpacing.xs : AppSpacing.sm),

          // Mode name
          Expanded(
            child: Text(
              entry.mode,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: colors.text,
              ),
            ),
          ),

          // Temperature range
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${entry.tempDay}°',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: colors.text,
                ),
              ),
              Text(
                '${entry.tempNight}°',
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),

          // Active indicator
          if (entry.isActive) ...[
            SizedBox(width: compact ? AppSpacing.xs - 2 : AppSpacing.xs),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.accentGreen,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
