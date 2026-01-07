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
/// Показывает 7 дней с временем включения/выключения и toggle
class DailyScheduleWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BreezCard(
      padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
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

          // Days list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _daysOrder.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: colors.border,
              ),
              itemBuilder: (context, index) {
                final day = _daysOrder[index];
                final settings = timerSettings?[day] ??
                    const TimerSettings(
                      onHour: 8,
                      onMinute: 0,
                      offHour: 22,
                      offMinute: 0,
                      enabled: false,
                    );

                return _DayRow(
                  day: day,
                  settings: settings,
                  compact: compact,
                  onSettingsChanged: onDaySettingsChanged != null
                      ? (onHour, onMinute, offHour, offMinute, enabled) {
                          onDaySettingsChanged!(
                            day,
                            onHour,
                            onMinute,
                            offHour,
                            offMinute,
                            enabled,
                          );
                        }
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Строка одного дня с настройками
class _DayRow extends StatelessWidget {
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

  const _DayRow({
    required this.day,
    required this.settings,
    required this.compact,
    this.onSettingsChanged,
  });

  String _getDayName(BuildContext context) {
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
    final isEnabled = settings.enabled;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: compact ? AppSpacing.xs : AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Day name
          SizedBox(
            width: 36,
            child: Text(
              _getDayName(context),
              style: TextStyle(
                fontSize: compact ? 12 : 14,
                fontWeight: FontWeight.w600,
                color: isEnabled ? colors.text : colors.textMuted,
              ),
            ),
          ),

          // Enable toggle
          SizedBox(
            width: 40,
            height: 24,
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

          const SizedBox(width: AppSpacing.sm),

          // On time
          if (isEnabled) ...[
            _TimePicker(
              hour: settings.onHour,
              minute: settings.onMinute,
              enabled: onSettingsChanged != null,
              compact: compact,
              onChanged: (hour, minute) {
                onSettingsChanged?.call(
                  hour,
                  minute,
                  settings.offHour,
                  settings.offMinute,
                  settings.enabled,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Text(
                '—',
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: compact ? 12 : 14,
                ),
              ),
            ),
            // Off time
            _TimePicker(
              hour: settings.offHour,
              minute: settings.offMinute,
              enabled: onSettingsChanged != null,
              compact: compact,
              onChanged: (hour, minute) {
                onSettingsChanged?.call(
                  settings.onHour,
                  settings.onMinute,
                  hour,
                  minute,
                  settings.enabled,
                );
              },
            ),
          ] else ...[
            Text(
              '—',
              style: TextStyle(
                color: colors.textMuted,
                fontSize: compact ? 12 : 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Пикер времени с кнопками +/-
class _TimePicker extends StatelessWidget {
  final int hour;
  final int minute;
  final bool enabled;
  final bool compact;
  final void Function(int hour, int minute)? onChanged;

  const _TimePicker({
    required this.hour,
    required this.minute,
    required this.enabled,
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hour controls
        _TimeControl(
          value: hour.toString().padLeft(2, '0'),
          onIncrement: enabled ? _incrementHour : null,
          onDecrement: enabled ? _decrementHour : null,
          compact: compact,
        ),
        Text(
          ':',
          style: TextStyle(
            fontSize: compact ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: colors.text,
          ),
        ),
        // Minute controls
        _TimeControl(
          value: minute.toString().padLeft(2, '0'),
          onIncrement: enabled ? _incrementMinute : null,
          onDecrement: enabled ? _decrementMinute : null,
          compact: compact,
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
    final buttonSize = compact ? 20.0 : 24.0;
    final iconSize = compact ? 14.0 : 16.0;

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
        const SizedBox(height: 2),
        // Value
        Text(
          value,
          style: TextStyle(
            fontSize: compact ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: colors.text,
          ),
        ),
        const SizedBox(height: 2),
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
