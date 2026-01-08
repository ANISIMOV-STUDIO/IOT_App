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

    // Простая структура без Expanded - заполняет доступное пространство
    return BreezCard(
      padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          Text(
            l10n.schedule,
            style: TextStyle(
              fontSize: compact ? 14 : 16,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),

          // Days list
          for (int index = 0; index < _daysOrder.length; index++) ...[
            if (index > 0) Divider(height: 1, color: colors.border),
            _DayRow(
              day: _daysOrder[index],
              settings: timerSettings?[_daysOrder[index]] ??
                  const TimerSettings(
                    onHour: 8,
                    onMinute: 0,
                    offHour: 22,
                    offMinute: 0,
                    enabled: false,
                  ),
              compact: compact,
              onSettingsChanged: onDaySettingsChanged != null
                  ? (onHour, onMinute, offHour, offMinute, enabled) {
                      onDaySettingsChanged!(
                        _daysOrder[index],
                        onHour,
                        onMinute,
                        offHour,
                        offMinute,
                        enabled,
                      );
                    }
                  : null,
            ),
          ],
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
            width: compact ? 32 : 40,
            child: Text(
              _getDayName(context),
              style: TextStyle(
                fontSize: compact ? 11 : 13,
                fontWeight: FontWeight.w600,
                color: isEnabled ? colors.text : colors.textMuted,
              ),
            ),
          ),

          // Enable toggle
          SizedBox(
            width: compact ? 36 : 44,
            height: compact ? 20 : 24,
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

          SizedBox(width: compact ? AppSpacing.xs : AppSpacing.sm),

          // Time range или placeholder
          Expanded(
            child: isEnabled
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _TimeDisplay(
                        hour: settings.onHour,
                        minute: settings.onMinute,
                        compact: compact,
                        onTap: onSettingsChanged != null
                            ? () => _showTimePicker(
                                  context,
                                  settings.onHour,
                                  settings.onMinute,
                                  (hour, minute) {
                                    onSettingsChanged?.call(
                                      hour,
                                      minute,
                                      settings.offHour,
                                      settings.offMinute,
                                      settings.enabled,
                                    );
                                  },
                                )
                            : null,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: compact ? 4 : AppSpacing.xs,
                        ),
                        child: Text(
                          '—',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: compact ? 11 : 13,
                          ),
                        ),
                      ),
                      _TimeDisplay(
                        hour: settings.offHour,
                        minute: settings.offMinute,
                        compact: compact,
                        onTap: onSettingsChanged != null
                            ? () => _showTimePicker(
                                  context,
                                  settings.offHour,
                                  settings.offMinute,
                                  (hour, minute) {
                                    onSettingsChanged?.call(
                                      settings.onHour,
                                      settings.onMinute,
                                      hour,
                                      minute,
                                      settings.enabled,
                                    );
                                  },
                                )
                            : null,
                      ),
                    ],
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '—',
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: compact ? 11 : 13,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTimePicker(
    BuildContext context,
    int currentHour,
    int currentMinute,
    void Function(int hour, int minute) onTimeSelected,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentHour, minute: currentMinute),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (time != null) {
      onTimeSelected(time.hour, time.minute);
    }
  }
}

/// Компактное отображение времени с возможностью нажатия
class _TimeDisplay extends StatelessWidget {
  final int hour;
  final int minute;
  final bool compact;
  final VoidCallback? onTap;

  const _TimeDisplay({
    required this.hour,
    required this.minute,
    required this.compact,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final timeText =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 8,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          timeText,
          style: TextStyle(
            fontSize: compact ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: colors.text,
          ),
        ),
      ),
    );
  }
}

