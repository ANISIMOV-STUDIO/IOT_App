/// Daily Schedule Widget - Simple daily on/off time configuration
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/mode_settings.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';

/// Callback для изменения настроек дня
typedef DaySettingsCallback = void Function(
  String day,
  int onHour,
  int onMinute,
  int offHour,
  int offMinute,
  bool enabled,
);

/// Виджет расписания по дням недели
/// Показывает табы для выбора дня и настройки выбранного дня
class DailyScheduleWidget extends StatefulWidget {
  /// Настройки таймера по дням (ключ = monday, tuesday, etc.)
  final Map<String, TimerSettings>? timerSettings;

  /// Callback при изменении настроек дня
  final DaySettingsCallback? onDaySettingsChanged;

  /// Компактный режим
  final bool compact;

  static const List<String> _daysOrder = [
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
  late String _selectedDay;

  @override
  void initState() {
    super.initState();
    // По умолчанию выбираем текущий день недели
    final now = DateTime.now();
    _selectedDay = DailyScheduleWidget._daysOrder[now.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    final settings = widget.timerSettings?[_selectedDay] ??
        const TimerSettings(
          onHour: 8,
          onMinute: 0,
          offHour: 22,
          offMinute: 0,
          enabled: false,
        );

    return BreezCard(
      padding: EdgeInsets.all(widget.compact ? AppSpacing.sm : AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            l10n.schedule,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Day selector tabs
          _DaySelector(
            days: DailyScheduleWidget._daysOrder,
            selectedDay: _selectedDay,
            timerSettings: widget.timerSettings,
            compact: widget.compact,
            onDaySelected: (day) => setState(() => _selectedDay = day),
          ),

          SizedBox(height: widget.compact ? AppSpacing.sm : AppSpacing.md),

          // Selected day settings
          Expanded(
            child: _DayContent(
              day: _selectedDay,
              settings: settings,
              compact: widget.compact,
              onSettingsChanged: widget.onDaySettingsChanged != null
                  ? (onHour, onMinute, offHour, offMinute, enabled) {
                      widget.onDaySettingsChanged!(
                        _selectedDay,
                        onHour,
                        onMinute,
                        offHour,
                        offMinute,
                        enabled,
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

/// Day selector row with tabs
class _DaySelector extends StatelessWidget {
  final List<String> days;
  final String selectedDay;
  final Map<String, TimerSettings>? timerSettings;
  final bool compact;
  final ValueChanged<String> onDaySelected;

  const _DaySelector({
    required this.days,
    required this.selectedDay,
    required this.timerSettings,
    required this.compact,
    required this.onDaySelected,
  });

  bool _hasSettings(String day) {
    final settings = timerSettings?[day];
    return settings?.enabled ?? false;
  }

  String _getDayShortName(BuildContext context, String day) {
    final l10n = AppLocalizations.of(context)!;
    switch (day) {
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
        return day;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final spacing = compact ? AppSpacing.xs : AppSpacing.sm;

    final List<Widget> children = [];
    for (var i = 0; i < days.length; i++) {
      final day = days[i];
      final isSelected = selectedDay == day;
      final hasSettings = _hasSettings(day);
      final shortName = _getDayShortName(context, day);

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
                : hasSettings
                    ? AppColors.accent.withValues(alpha: 0.1)
                    : colors.buttonBg,
            hoverColor: isSelected
                ? AppColors.accent
                : hasSettings
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
                        : hasSettings
                            ? AppColors.accent
                            : colors.textMuted,
                  ),
                ),
                if (hasSettings && !isSelected) ...[
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
                if (!hasSettings || isSelected)
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

/// Content area for selected day's settings
class _DayContent extends StatelessWidget {
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

  const _DayContent({
    required this.day,
    required this.settings,
    required this.compact,
    this.onSettingsChanged,
  });

  String _getDayName(BuildContext context) {
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
    final isEnabled = settings.enabled;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day name and enable toggle
          Row(
            children: [
              Expanded(
                child: Text(
                  _getDayName(context),
                  style: TextStyle(
                    fontSize: compact ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: colors.text,
                  ),
                ),
              ),
              // Enable switch
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEnabled ? 'Включено' : 'Выключено',
                    style: TextStyle(
                      fontSize: compact ? 12 : 14,
                      color: colors.textMuted,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Switch(
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
                ],
              ),
            ],
          ),

          SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),

          // Time settings (always shown) - in a row
          Row(
            children: [
              // ON time
              Expanded(
                child: _TimeSection(
                  label: 'Время включения',
                  hour: settings.onHour,
                  minute: settings.onMinute,
                  compact: compact,
                  onChanged: onSettingsChanged != null
                      ? (hour, minute) => onSettingsChanged!(
                            hour,
                            minute,
                            settings.offHour,
                            settings.offMinute,
                            settings.enabled,
                          )
                      : null,
                ),
              ),

              SizedBox(width: compact ? AppSpacing.sm : AppSpacing.md),

              // OFF time
              Expanded(
                child: _TimeSection(
                  label: 'Время выключения',
                  hour: settings.offHour,
                  minute: settings.offMinute,
                  compact: compact,
                  onChanged: onSettingsChanged != null
                      ? (hour, minute) => onSettingsChanged!(
                            settings.onHour,
                            settings.onMinute,
                            hour,
                            minute,
                            settings.enabled,
                          )
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Time section with hour and minute pickers
class _TimeSection extends StatelessWidget {
  final String label;
  final int hour;
  final int minute;
  final bool compact;
  final void Function(int hour, int minute)? onChanged;

  const _TimeSection({
    required this.label,
    required this.hour,
    required this.minute,
    required this.compact,
    this.onChanged,
  });

  void _incrementHour() {
    final newHour = (hour + 1) % 24;
    onChanged?.call(newHour, minute);
  }

  void _decrementHour() {
    final newHour = (hour - 1 + 24) % 24;
    onChanged?.call(newHour, minute);
  }

  void _incrementMinute() {
    int newMinute = minute + 5;
    int newHour = hour;
    if (newMinute >= 60) {
      newMinute = 0;
      newHour = (hour + 1) % 24;
    }
    onChanged?.call(newHour, newMinute);
  }

  void _decrementMinute() {
    int newMinute = minute - 5;
    int newHour = hour;
    if (newMinute < 0) {
      newMinute = 55;
      newHour = (hour - 1 + 24) % 24;
    }
    onChanged?.call(newHour, newMinute);
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: compact ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: colors.textMuted,
          ),
        ),
        SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hour controls
            _TimeControl(
              value: hour.toString().padLeft(2, '0'),
              onIncrement: onChanged != null ? _incrementHour : null,
              onDecrement: onChanged != null ? _decrementHour : null,
              compact: compact,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: compact ? 20 : 28,
                  fontWeight: FontWeight.w600,
                  color: colors.text,
                ),
              ),
            ),
            // Minute controls
            _TimeControl(
              value: minute.toString().padLeft(2, '0'),
              onIncrement: onChanged != null ? _incrementMinute : null,
              onDecrement: onChanged != null ? _decrementMinute : null,
              compact: compact,
            ),
          ],
        ),
      ],
    );
  }
}

/// Контрол для одного значения времени (час или минута)
class _TimeControl extends StatelessWidget {
  final String value;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final bool compact;

  const _TimeControl({
    required this.value,
    this.onIncrement,
    this.onDecrement,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    // Larger sizes since we have more space with tab layout
    final buttonSize = compact ? 28.0 : 36.0;
    final iconSize = compact ? 18.0 : 22.0;
    final fontSize = compact ? 18.0 : 24.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Increment button
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.keyboard_arrow_up,
              size: iconSize,
              color: onIncrement != null ? AppColors.accent : colors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Value
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: colors.text,
          ),
        ),
        const SizedBox(height: 4),
        // Decrement button
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: iconSize,
              color: onDecrement != null ? AppColors.accent : colors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
