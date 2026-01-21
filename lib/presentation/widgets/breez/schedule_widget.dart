/// Schedule Widget - Weekly schedule display
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/schedule_entry.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_list_card.dart';

export '../../../domain/entities/schedule_entry.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _ScheduleWidgetConstants {

  // Button icons
  static const double seeAllFontSize = 12;

  // Day selector
  static const double dayFontSizeCompact = 10;
  static const double dayFontSizeNormal = 11;
  static const double indicatorGap = 2;
  static const double indicatorSize = 4;

  // Empty state
  static const double emptyFontSizeCompact = 11;
  static const double emptyFontSizeNormal = 12;
  static const double hintFontSize = 11;

  // Schedule row
  static const double rowFontSizeCompact = 11;
  static const double rowFontSizeNormal = 13;
  static const double rowSmallFontSizeCompact = 10;
  static const double rowSmallFontSizeNormal = 12;
  static const double timeRangeFontSizeCompact = 9;
  static const double timeRangeFontSizeNormal = 10;
  static const double activeIndicatorSize = 6;

  // Padding values
  static const double buttonPaddingVertical = 6; // AppSpacing.xxs + 2
  static const double timePaddingVerticalCompact = 3;
  static const double timePaddingVerticalNormal = 4;
}

/// Weekly schedule widget with day selector
class ScheduleWidget extends StatefulWidget {

  const ScheduleWidget({
    required this.entries,
    super.key,
    this.onSeeAll,
    this.onAddEntry,
    this.onEntryTap,
    this.compact = false,
  });
  final List<ScheduleEntry> entries;
  final VoidCallback? onSeeAll;
  final VoidCallback? onAddEntry;
  final ValueChanged<ScheduleEntry>? onEntryTap;
  final bool compact;

  /// Перевод английского названия дня недели в локализованное
  ///
  /// Использует Map вместо switch-case для лучшей читаемости и производительности
  static String translateDayName(String englishDay, AppLocalizations l10n) {
    final dayMap = <String, String>{
      'monday': l10n.monday,
      'tuesday': l10n.tuesday,
      'wednesday': l10n.wednesday,
      'thursday': l10n.thursday,
      'friday': l10n.friday,
      'saturday': l10n.saturday,
      'sunday': l10n.sunday,
    };
    return dayMap[englishDay.toLowerCase()] ?? englishDay;
  }

  /// Перевод локализованного названия дня в английское (для API)
  static String dayNameToEnglish(String localizedDay, AppLocalizations l10n) {
    final reverseMap = <String, String>{
      l10n.monday: 'monday',
      l10n.tuesday: 'tuesday',
      l10n.wednesday: 'wednesday',
      l10n.thursday: 'thursday',
      l10n.friday: 'friday',
      l10n.saturday: 'saturday',
      l10n.sunday: 'sunday',
    };
    return reverseMap[localizedDay] ?? localizedDay;
  }

  /// Короткие названия дней недели (локализованные)
  static String getShortDayName(String englishDay, AppLocalizations l10n) {
    final shortDayMap = <String, String>{
      'monday': l10n.mondayShort,
      'tuesday': l10n.tuesdayShort,
      'wednesday': l10n.wednesdayShort,
      'thursday': l10n.thursdayShort,
      'friday': l10n.fridayShort,
      'saturday': l10n.saturdayShort,
      'sunday': l10n.sundayShort,
    };
    return shortDayMap[englishDay.toLowerCase()] ?? englishDay.substring(0, 2);
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
    if (_selectedDay == null) {
      return widget.entries;
    }
    return widget.entries
        .where((e) => e.day.toLowerCase() == _selectedDay!.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title, "See All" and "Add" buttons
          if (!widget.compact) ...[
            BreezSectionHeader.schedule(
              title: l10n.schedule,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Add button
                  if (widget.onAddEntry != null)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: BreezButton(
                        onTap: widget.onAddEntry,
                        padding: const EdgeInsets.all(
                          _ScheduleWidgetConstants.buttonPaddingVertical,
                        ),
                        backgroundColor: AppColors.accent,
                        hoverColor: AppColors.accentLight,
                        showBorder: false,
                        enforceMinTouchTarget: false,
                        child: const Icon(
                          Icons.add,
                          size: AppIconSizes.standard,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  // See all button
                  BreezButton(
                    onTap: widget.onSeeAll ?? () {},
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: _ScheduleWidgetConstants.buttonPaddingVertical,
                    ),
                    backgroundColor: AppColors.accent.withValues(alpha: AppColors.opacityLight),
                    hoverColor: AppColors.accent.withValues(alpha: AppColors.opacitySubtle),
                    showBorder: false,
                    enforceMinTouchTarget: false,
                    child: Center(
                      child: Text(
                        l10n.seeAll,
                        style: const TextStyle(
                          fontSize: _ScheduleWidgetConstants.seeAllFontSize,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

  const _DaySelector({
    required this.days,
    required this.selectedDay,
    required this.entries,
    required this.compact,
    required this.onDaySelected,
  });
  final List<String> days;
  final String? selectedDay;
  final List<ScheduleEntry> entries;
  final bool compact;
  final ValueChanged<String> onDaySelected;

  bool _hasEntries(String day) =>
      entries.any((e) => e.day.toLowerCase() == day.toLowerCase());

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final spacing = compact ? AppSpacing.xs : AppSpacing.sm;

    final children = <Widget>[];
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
              vertical: compact
                  ? _ScheduleWidgetConstants.buttonPaddingVertical
                  : AppSpacing.xs,
            ),
            backgroundColor: isSelected
                ? AppColors.accent
                : hasEntries
                    ? AppColors.accent.withValues(alpha: AppColors.opacityLight)
                    : colors.buttonBg,
            hoverColor: isSelected
                ? AppColors.accent
                : hasEntries
                    ? AppColors.accent.withValues(alpha: AppColors.opacityMediumLight)
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
                    fontSize: compact
                        ? _ScheduleWidgetConstants.dayFontSizeCompact
                        : _ScheduleWidgetConstants.dayFontSizeNormal,
                    // Фиксированный fontWeight для предотвращения layout shift
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.white
                        : hasEntries
                            ? AppColors.accent
                            : colors.textMuted,
                  ),
                ),
                // Фиксированный контейнер для индикатора
                const SizedBox(height: _ScheduleWidgetConstants.indicatorGap),
                SizedBox(
                  width: _ScheduleWidgetConstants.indicatorSize,
                  height: _ScheduleWidgetConstants.indicatorSize,
                  child: (hasEntries && !isSelected)
                      ? Container(
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null, // Пустой контейнер сохраняет размер
                ),
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

  const _EmptyDayState({
    required this.day,
    required this.compact,
    this.showAddHint = false,
  });
  final String day;
  final bool compact;
  final bool showAddHint;

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
              size: AppIconSizes.standard,
              color: showAddHint
                  ? AppColors.accent.withValues(alpha: AppColors.opacityMedium)
                  : colors.textMuted.withValues(alpha: AppColors.opacityMedium),
            ),
            SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
            Text(
              l10n.noEntriesForDay(ScheduleWidget.translateDayName(day, l10n).toLowerCase()),
              style: TextStyle(
                fontSize: compact
                    ? _ScheduleWidgetConstants.emptyFontSizeCompact
                    : _ScheduleWidgetConstants.emptyFontSizeNormal,
                color: colors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            if (!compact) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(
                showAddHint ? l10n.tapToAdd : l10n.addFirstEntry,
                style: TextStyle(
                  fontSize: _ScheduleWidgetConstants.hintFontSize,
                  color: AppColors.accent.withValues(alpha: AppColors.opacityHigh),
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

  const _ScheduleRow({
    required this.entry,
    this.onTap,
    this.compact = false,
  });
  final ScheduleEntry entry;
  final VoidCallback? onTap;
  final bool compact;

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
    const iconSize = AppIconSizes.standard;
    final fontSize = compact
        ? _ScheduleWidgetConstants.rowFontSizeCompact
        : _ScheduleWidgetConstants.rowFontSizeNormal;
    final smallFontSize = compact
        ? _ScheduleWidgetConstants.rowSmallFontSizeCompact
        : _ScheduleWidgetConstants.rowSmallFontSizeNormal;

    return BreezButton(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.xs),
      backgroundColor: entry.isActive
          ? AppColors.accent.withValues(alpha: AppColors.opacityVerySubtle)
          : colors.buttonBg,
      hoverColor: entry.isActive
          ? AppColors.accent.withValues(alpha: AppColors.opacitySubtle)
          : colors.buttonHover,
      showBorder: entry.isActive,
      border: entry.isActive
          ? Border.all(color: AppColors.accent.withValues(alpha: AppColors.opacityLow))
          : null,
      enableScale: false,
      child: Row(
        children: [
          // Time range
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? AppSpacing.xs - 2 : AppSpacing.xs,
              vertical: compact
                  ? _ScheduleWidgetConstants.timePaddingVerticalCompact
                  : _ScheduleWidgetConstants.timePaddingVerticalNormal,
            ),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: AppColors.opacityLight),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Text(
              entry.timeRange,
              style: TextStyle(
                fontSize: compact
                    ? _ScheduleWidgetConstants.timeRangeFontSizeCompact
                    : _ScheduleWidgetConstants.timeRangeFontSizeNormal,
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
              color: AppColors.accent.withValues(alpha: AppColors.opacityLight),
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Icon(
              _getModeIcon(),
              size: AppIconSizes.standard,
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
              width: _ScheduleWidgetConstants.activeIndicatorSize,
              height: _ScheduleWidgetConstants.activeIndicatorSize,
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
