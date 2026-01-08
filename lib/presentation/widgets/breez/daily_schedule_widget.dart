/// Daily Schedule Widget - Weekly schedule with day tabs
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/mode_settings.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';
import 'breez_tab.dart';
import 'breez_time_input.dart';

/// Callback для изменения настроек дня
typedef DaySettingsCallback = void Function(
  String day,
  int onHour,
  int onMinute,
  int offHour,
  int offMinute,
  bool enabled,
);

/// Виджет расписания с табами по дням недели
class DailyScheduleWidget extends StatefulWidget {
  /// Настройки таймера по дням (ключ = monday, tuesday, etc.)
  final Map<String, TimerSettings>? timerSettings;

  /// Callback при изменении настроек дня
  final DaySettingsCallback? onDaySettingsChanged;

  /// Компактный режим
  final bool compact;

  static const List<String> daysOrder = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  const DailyScheduleWidget({
    super.key,
    this.timerSettings,
    this.onDaySettingsChanged,
    this.compact = false,
  });

  @override
  State<DailyScheduleWidget> createState() => _DailyScheduleWidgetState();
}

class _DailyScheduleWidgetState extends State<DailyScheduleWidget> {
  late int _selectedIndex;

  // Локальный кэш для optimistic updates
  final Map<String, TimerSettings> _localSettings = {};

  @override
  void initState() {
    super.initState();
    // По умолчанию выбираем текущий день недели
    final now = DateTime.now();
    _selectedIndex = now.weekday - 1;
  }

  String get _selectedDay => DailyScheduleWidget.daysOrder[_selectedIndex];

  TimerSettings _getSettings(String day) {
    return _localSettings[day] ??
        widget.timerSettings?[day] ??
        const TimerSettings(
          onHour: 8,
          onMinute: 0,
          offHour: 22,
          offMinute: 0,
          enabled: false,
        );
  }

  Set<int> get _activeIndices {
    final settings = _localSettings.isNotEmpty ? _localSettings : (widget.timerSettings ?? {});
    return DailyScheduleWidget.daysOrder
        .asMap()
        .entries
        .where((e) => settings[e.value]?.enabled ?? false)
        .map((e) => e.key)
        .toSet();
  }

  void _updateSettings(String day, TimerSettings newSettings) {
    setState(() {
      _localSettings[day] = newSettings;
    });

    widget.onDaySettingsChanged?.call(
      day,
      newSettings.onHour,
      newSettings.onMinute,
      newSettings.offHour,
      newSettings.offMinute,
      newSettings.enabled,
    );
  }

  List<String> _getDayLabels(AppLocalizations l10n) {
    return [
      l10n.mondayShort,
      l10n.tuesdayShort,
      l10n.wednesdayShort,
      l10n.thursdayShort,
      l10n.fridayShort,
      l10n.saturdayShort,
      l10n.sundayShort,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final selectedSettings = _getSettings(_selectedDay);

    return BreezCard(
      padding: EdgeInsets.all(widget.compact ? AppSpacing.sm : AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            l10n.schedule,
            style: TextStyle(
              fontSize: widget.compact ? 14 : 16,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          SizedBox(height: widget.compact ? AppSpacing.xs : AppSpacing.sm),

          // Day tabs - используем BreezTabGroup
          BreezTabGroup(
            labels: _getDayLabels(l10n),
            selectedIndex: _selectedIndex,
            activeIndices: _activeIndices,
            compact: widget.compact,
            onTabSelected: (index) => setState(() => _selectedIndex = index),
          ),

          SizedBox(height: widget.compact ? AppSpacing.sm : AppSpacing.md),

          // Selected day settings
          Expanded(
            child: _DaySettings(
              day: _selectedDay,
              settings: selectedSettings,
              compact: widget.compact,
              onSettingsChanged: widget.onDaySettingsChanged != null
                  ? (onHour, onMinute, offHour, offMinute, enabled) {
                      _updateSettings(
                        _selectedDay,
                        TimerSettings(
                          onHour: onHour,
                          onMinute: onMinute,
                          offHour: offHour,
                          offMinute: offMinute,
                          enabled: enabled,
                        ),
                      );
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Настройки выбранного дня
class _DaySettings extends StatelessWidget {
  final String day;
  final TimerSettings settings;
  final bool compact;
  final void Function(
    int onHour,
    int onMinute,
    int offHour,
    int offMinute,
    bool enabled,
  )? onSettingsChanged;

  const _DaySettings({
    required this.day,
    required this.settings,
    required this.compact,
    this.onSettingsChanged,
  });

  String _getFullDayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (day) {
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
        return day;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isEnabled = settings.enabled;

    return Column(
      children: [
        // День и переключатель
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getFullDayName(context),
              style: TextStyle(
                fontSize: compact ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: colors.text,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEnabled ? l10n.statusEnabled : l10n.statusDisabled,
                  style: TextStyle(
                    fontSize: compact ? 12 : 13,
                    color: isEnabled ? AppColors.accentGreen : colors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: SizedBox(
                    height: compact ? 24 : 28,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Switch(
                        value: isEnabled,
                        onChanged: onSettingsChanged != null
                            ? (v) => onSettingsChanged!(
                                  settings.onHour,
                                  settings.onMinute,
                                  settings.offHour,
                                  settings.offMinute,
                                  v,
                                )
                            : null,
                        activeTrackColor: AppColors.accent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        const Spacer(),

        // Время включения/выключения - используем BreezTimeInput
        if (isEnabled) ...[
          BreezTimeInput(
            label: l10n.scheduleStartLabel,
            hour: settings.onHour,
            minute: settings.onMinute,
            compact: compact,
            onTimeChanged: onSettingsChanged != null
                ? (hour, minute) => onSettingsChanged!(
                      hour,
                      minute,
                      settings.offHour,
                      settings.offMinute,
                      settings.enabled,
                    )
                : null,
          ),
          SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
          BreezTimeInput(
            label: l10n.scheduleEndLabel,
            hour: settings.offHour,
            minute: settings.offMinute,
            compact: compact,
            onTimeChanged: onSettingsChanged != null
                ? (hour, minute) => onSettingsChanged!(
                      settings.onHour,
                      settings.onMinute,
                      hour,
                      minute,
                      settings.enabled,
                    )
                : null,
          ),
        ] else ...[
          // Placeholder когда день выключен
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: compact ? 32 : 48,
                  color: colors.textMuted.withValues(alpha: 0.5),
                ),
                SizedBox(height: compact ? 4 : 8),
                Text(
                  l10n.noSchedule,
                  style: TextStyle(
                    fontSize: compact ? 12 : 14,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],

        const Spacer(),
      ],
    );
  }
}
