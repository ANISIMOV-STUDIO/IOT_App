/// Daily Schedule Widget - Weekly schedule with day tabs
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/mode_settings.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';
import 'breez_tab.dart';

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
  // По умолчанию выбираем текущий день недели (инициализация без late для hot reload)
  int _selectedIndex = DateTime.now().weekday - 1;

  // Локальный кэш для optimistic updates
  final Map<String, TimerSettings> _localSettings = {};

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
          // Header - только для desktop
          if (!widget.compact) ...[
            Text(
              l10n.schedule,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.text,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
          ],

          // Day tabs - используем BreezTabGroup
          BreezTabGroup(
            labels: _getDayLabels(l10n),
            selectedIndex: _selectedIndex,
            activeIndices: _activeIndices,
            compact: widget.compact,
            onTabSelected: (index) => setState(() => _selectedIndex = index),
          ),

          SizedBox(height: widget.compact ? AppSpacing.xs : AppSpacing.md),

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

    if (compact) {
      // Мобильный layout - компактный и центрированный
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // День и переключатель
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getFullDayName(context),
                style: TextStyle(
                  fontSize: 16,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isEnabled ? AppColors.accentGreen : colors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
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
                ],
              ),
            ],
          ),

          SizedBox(height: AppSpacing.sm),

          // Время в одну строку - растягивается на оставшееся место
          Expanded(
            child: Opacity(
              opacity: isEnabled ? 1.0 : 0.4,
              child: IgnorePointer(
                ignoring: !isEnabled,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _TimeBlock(
                        label: l10n.scheduleStartLabel,
                        hour: settings.onHour,
                        minute: settings.onMinute,
                        onTimeChanged: onSettingsChanged != null && isEnabled
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
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _TimeBlock(
                        label: l10n.scheduleEndLabel,
                        hour: settings.offHour,
                        minute: settings.offMinute,
                        onTimeChanged: onSettingsChanged != null && isEnabled
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
              ),
            ),
          ),
        ],
      );
    }

    // Desktop layout - горизонтальный с фиксированной высотой
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // День и переключатель
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getFullDayName(context),
              style: TextStyle(
                fontSize: 16,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isEnabled ? AppColors.accentGreen : colors.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
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
              ],
            ),
          ],
        ),

        SizedBox(height: AppSpacing.md),

        // Время в одну строку с фиксированной высотой
        Opacity(
          opacity: isEnabled ? 1.0 : 0.4,
          child: IgnorePointer(
            ignoring: !isEnabled,
            child: SizedBox(
              height: 80, // Фиксированная максимальная высота
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _TimeBlock(
                      label: l10n.scheduleStartLabel,
                      hour: settings.onHour,
                      minute: settings.onMinute,
                      onTimeChanged: onSettingsChanged != null && isEnabled
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
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _TimeBlock(
                      label: l10n.scheduleEndLabel,
                      hour: settings.offHour,
                      minute: settings.offMinute,
                      onTimeChanged: onSettingsChanged != null && isEnabled
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
            ),
          ),
        ),
      ],
    );
  }
}

/// Вертикальный блок времени для мобильного layout
class _TimeBlock extends StatefulWidget {
  final String label;
  final int hour;
  final int minute;
  final void Function(int hour, int minute)? onTimeChanged;

  const _TimeBlock({
    required this.label,
    required this.hour,
    required this.minute,
    this.onTimeChanged,
  });

  @override
  State<_TimeBlock> createState() => _TimeBlockState();
}

class _TimeBlockState extends State<_TimeBlock> {
  bool _isHovered = false;

  String get _timeText =>
      '${widget.hour.toString().padLeft(2, '0')}:${widget.minute.toString().padLeft(2, '0')}';

  bool get _isEnabled => widget.onTimeChanged != null;

  Future<void> _showTimePicker() async {
    if (!_isEnabled) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: widget.hour, minute: widget.minute),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (time != null) {
      widget.onTimeChanged?.call(time.hour, time.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return MouseRegion(
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _showTimePicker,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.xxs,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: _isHovered && _isEnabled
                ? AppColors.accent.withValues(alpha: 0.15)
                : AppColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered && _isEnabled
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : AppColors.accent.withValues(alpha: 0.2),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _timeText,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _isEnabled ? colors.text : colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
