/// Daily Schedule Widget - Weekly schedule with day tabs
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
  late String _selectedDay;

  @override
  void initState() {
    super.initState();
    // По умолчанию выбираем текущий день недели
    final now = DateTime.now();
    _selectedDay = DailyScheduleWidget.daysOrder[now.weekday - 1];
  }

  TimerSettings _getSettings(String day) {
    return widget.timerSettings?[day] ??
        const TimerSettings(
          onHour: 8,
          onMinute: 0,
          offHour: 22,
          offMinute: 0,
          enabled: false,
        );
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

          // Day tabs
          _DayTabs(
            selectedDay: _selectedDay,
            timerSettings: widget.timerSettings,
            compact: widget.compact,
            onDaySelected: (day) => setState(() => _selectedDay = day),
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

/// Табы дней недели
class _DayTabs extends StatelessWidget {
  final String selectedDay;
  final Map<String, TimerSettings>? timerSettings;
  final bool compact;
  final ValueChanged<String> onDaySelected;

  const _DayTabs({
    required this.selectedDay,
    required this.timerSettings,
    required this.compact,
    required this.onDaySelected,
  });

  String _getShortDayName(String day, AppLocalizations l10n) {
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
        return day.substring(0, 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: DailyScheduleWidget.daysOrder.map((day) {
        final isSelected = day == selectedDay;
        final isEnabled = timerSettings?[day]?.enabled ?? false;

        return Expanded(
          child: GestureDetector(
            onTap: () => onDaySelected(day),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: compact ? 6 : 8,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? AppColors.accent
                      : isEnabled
                          ? AppColors.accentGreen.withValues(alpha: 0.5)
                          : colors.border,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getShortDayName(day, l10n),
                    style: TextStyle(
                      fontSize: compact ? 10 : 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.accent
                          : isEnabled
                              ? colors.text
                              : colors.textMuted,
                    ),
                  ),
                  if (isEnabled) ...[
                    const SizedBox(height: 2),
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
            ),
          ),
        );
      }).toList(),
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
                SizedBox(
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
              ],
            ),
          ],
        ),

        const Spacer(),

        // Время включения/выключения
        if (isEnabled) ...[
          _TimeRow(
            label: l10n.scheduleStartLabel,
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
          SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
          _TimeRow(
            label: l10n.scheduleEndLabel,
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

/// Строка с временем
class _TimeRow extends StatelessWidget {
  final String label;
  final int hour;
  final int minute;
  final bool compact;
  final VoidCallback? onTap;

  const _TimeRow({
    required this.label,
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: compact ? 13 : 14,
            color: colors.textMuted,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 16,
              vertical: compact ? 8 : 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              timeText,
              style: TextStyle(
                fontSize: compact ? 16 : 20,
                fontWeight: FontWeight.w700,
                color: colors.text,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
