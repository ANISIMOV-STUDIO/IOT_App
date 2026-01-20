/// Daily Schedule Widget - Weekly schedule with day tabs
library;

// Callback typedef uses positional bool for consistency with Flutter callback patterns
// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';
import 'package:hvac_control/domain/entities/mode_settings.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_card.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_tab.dart';
import 'package:hvac_control/presentation/widgets/breez/breez_time_picker.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы виджета расписания
abstract class _ScheduleConstants {
  static const double borderRadius = 10;
  static const double timeFontSize = 22;
  static const double powerButtonWidth = 44;
  static const double powerIconSize = 16;
}

// =============================================================================
// TYPES
// =============================================================================

/// Callback для изменения настроек дня
typedef DaySettingsCallback = void Function(
  String day,
  int onHour,
  int onMinute,
  int offHour,
  int offMinute,
  bool enabled,
);

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Виджет расписания с табами по дням недели
///
/// Поддерживает:
/// - Выбор дня недели через табы
/// - Включение/выключение расписания для каждого дня
/// - Настройку времени начала и конца
/// - Optimistic updates для мгновенного отклика UI
/// - Адаптивный layout (compact для mobile, полный для desktop)
class DailyScheduleWidget extends StatefulWidget {

  const DailyScheduleWidget({
    super.key,
    this.timerSettings,
    this.onDaySettingsChanged,
    this.compact = false,
    this.showCard = true,
    this.isEnabled = true,
  });
  /// Настройки таймера по дням (ключ = monday, tuesday, etc.)
  final Map<String, TimerSettings>? timerSettings;

  /// Callback при изменении настроек дня
  final DaySettingsCallback? onDaySettingsChanged;

  /// Компактный режим (для mobile)
  final bool compact;

  /// Порядок дней недели (ISO 8601: понедельник = 1)
  static const List<String> daysOrder = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  /// Показывать обёртку-карточку
  final bool showCard;

  /// Включен ли виджет (для offline состояния)
  final bool isEnabled;

  @override
  State<DailyScheduleWidget> createState() => _DailyScheduleWidgetState();
}

class _DailyScheduleWidgetState extends State<DailyScheduleWidget>
    with AutomaticKeepAliveClientMixin {
  /// Индекс выбранного дня (инициализация без late для hot reload)
  int _selectedIndex = DateTime.now().weekday - 1;

  /// Локальный кэш для optimistic updates
  final Map<String, TimerSettings> _localSettings = {};

  @override
  bool get wantKeepAlive => true;

  String get _selectedDay => DailyScheduleWidget.daysOrder[_selectedIndex];

  TimerSettings _getSettings(String day) => _localSettings[day] ??
        widget.timerSettings?[day] ??
        const TimerSettings(
          onHour: 8,
          onMinute: 0,
          offHour: 22,
          offMinute: 0,
        );

  Set<int> get _activeIndices =>
      // Merge local and server settings: prioritize local, fallback to server
      DailyScheduleWidget.daysOrder
          .asMap()
          .entries
          .where((e) {
            final day = e.value;
            final settings = _localSettings[day] ?? widget.timerSettings?[day];
            return settings?.enabled ?? false;
          })
          .map((e) => e.key)
          .toSet();

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

  void _handleSettingsChanged(
    int onHour,
    int onMinute,
    int offHour,
    int offMinute,
    bool enabled,
  ) {
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

  /// Toggle enabled state for a day
  void _handleDayToggle(bool enabled) {
    final settings = _getSettings(_selectedDay);
    _updateSettings(
      _selectedDay,
      TimerSettings(
        onHour: settings.onHour,
        onMinute: settings.onMinute,
        offHour: settings.offHour,
        offMinute: settings.offMinute,
        enabled: enabled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final selectedSettings = _getSettings(_selectedDay);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header - только для desktop
        if (!widget.compact) ...[
          Text(
            l10n.schedule,
            style: TextStyle(
              fontSize: AppFontSizes.h4,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],

        // Day tabs
        BreezTabGroup(
          labels: _DayNameResolver.getShortNames(l10n),
          selectedIndex: _selectedIndex,
          activeIndices: _activeIndices,
          compact: widget.compact,
          onTabSelected: (index) => setState(() => _selectedIndex = index),
        ),

        const SizedBox(height: AppSpacing.xs),

        // Time inputs with toggle
        Expanded(
          child: _DaySettingsPanel(
            dayKey: _selectedDay,
            settings: selectedSettings,
            compact: widget.compact,
            onSettingsChanged:
                widget.onDaySettingsChanged != null ? _handleSettingsChanged : null,
            onToggle: widget.onDaySettingsChanged != null ? _handleDayToggle : null,
          ),
        ),
      ],
    );

    if (!widget.showCard) {
      return Opacity(
        opacity: widget.isEnabled ? 1.0 : 0.4,
        child: IgnorePointer(
          ignoring: !widget.isEnabled,
          child: content,
        ),
      );
    }

    return Opacity(
      opacity: widget.isEnabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !widget.isEnabled,
        child: BreezCard(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: content,
        ),
      ),
    );
  }
}

// =============================================================================
// DAY NAME RESOLVER
// =============================================================================

/// Резолвер имён дней недели
abstract class _DayNameResolver {
  /// Получить список коротких имён
  static List<String> getShortNames(AppLocalizations l10n) => [
      l10n.mondayShort,
      l10n.tuesdayShort,
      l10n.wednesdayShort,
      l10n.thursdayShort,
      l10n.fridayShort,
      l10n.saturdayShort,
      l10n.sundayShort,
    ];
}

// =============================================================================
// DAY SETTINGS PANEL
// =============================================================================

/// Панель настроек выбранного дня
class _DaySettingsPanel extends StatelessWidget {

  const _DaySettingsPanel({
    required this.dayKey,
    required this.settings,
    required this.compact,
    this.onSettingsChanged,
    this.onToggle,
  });
  final String dayKey;
  final TimerSettings settings;
  final bool compact;
  final void Function(
    int onHour,
    int onMinute,
    int offHour,
    int offMinute,
    bool enabled,
  )? onSettingsChanged;
  final void Function(bool enabled)? onToggle;

  void _onStartTimeChanged(int hour, int minute) {
    onSettingsChanged?.call(
      hour,
      minute,
      settings.offHour,
      settings.offMinute,
      settings.enabled,
    );
  }

  void _onEndTimeChanged(int hour, int minute) {
    onSettingsChanged?.call(
      settings.onHour,
      settings.onMinute,
      hour,
      minute,
      settings.enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // IntrinsicHeight ensures all children have the same height
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Start time column
          Expanded(
            child: Opacity(
              opacity: settings.enabled ? 1.0 : 0.4,
              child: IgnorePointer(
                ignoring: !settings.enabled,
                child: _TimeColumn(
                  label: l10n.scheduleStartLabel,
                  hour: settings.onHour,
                  minute: settings.onMinute,
                  onTimeChanged: onSettingsChanged != null && settings.enabled
                      ? _onStartTimeChanged
                      : null,
                ),
              ),
            ),
          ),
          // Power toggle button between time columns
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
            child: _PowerToggleButton(
              enabled: settings.enabled,
              onToggle: onToggle,
            ),
          ),
          // End time column
          Expanded(
            child: Opacity(
              opacity: settings.enabled ? 1.0 : 0.4,
              child: IgnorePointer(
                ignoring: !settings.enabled,
                child: _TimeColumn(
                  label: l10n.scheduleEndLabel,
                  hour: settings.offHour,
                  minute: settings.offMinute,
                  onTimeChanged: onSettingsChanged != null && settings.enabled
                      ? _onEndTimeChanged
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// POWER TOGGLE BUTTON
// =============================================================================

/// Кнопка включения/выключения дня (на базе BreezButton)
class _PowerToggleButton extends StatelessWidget {
  const _PowerToggleButton({
    required this.enabled,
    this.onToggle,
  });

  final bool enabled;
  final void Function(bool)? onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return SizedBox(
      width: _ScheduleConstants.powerButtonWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Spacer to align with time column labels
          const Text(
            '',
            style: TextStyle(fontSize: AppFontSizes.captionSmall),
          ),
          const SizedBox(height: AppSpacing.xxs),
          // Button - uses BreezButton as base
          Expanded(
            child: BreezButton(
              onTap: onToggle != null ? () => onToggle!(!enabled) : null,
              backgroundColor: enabled
                  ? AppColors.accent.withValues(alpha: 0.08)
                  : colors.buttonBg.withValues(alpha: AppColors.opacityMedium),
              hoverColor: enabled
                  ? AppColors.accent.withValues(alpha: AppColors.opacitySubtle)
                  : colors.buttonBg.withValues(alpha: AppColors.opacityHigh),
              border: Border.all(
                color: enabled
                    ? AppColors.accent.withValues(alpha: AppColors.opacityLow)
                    : colors.border,
              ),
              borderRadius: _ScheduleConstants.borderRadius,
              padding: EdgeInsets.zero,
              enforceMinTouchTarget: false,
              enableScale: false,
              showBorder: false,
              semanticLabel: enabled ? 'Выключить расписание' : 'Включить расписание',
              child: Icon(
                Icons.power_settings_new_rounded,
                size: _ScheduleConstants.powerIconSize,
                color: enabled ? AppColors.accent : colors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TIME COLUMN
// =============================================================================

/// Колонка времени с подписью сверху
class _TimeColumn extends StatelessWidget {

  const _TimeColumn({
    required this.label,
    required this.hour,
    required this.minute,
    this.onTimeChanged,
  });
  final String label;
  final int hour;
  final int minute;
  final void Function(int hour, int minute)? onTimeChanged;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Label above
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.captionSmall,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        // Time block - takes remaining space
        Expanded(
          child: _ScheduleTimeBlock(
            hour: hour,
            minute: minute,
            onTimeChanged: onTimeChanged,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// SCHEDULE TIME BLOCK
// =============================================================================

/// Компактный блок времени (на базе BreezButton)
class _ScheduleTimeBlock extends StatelessWidget {
  const _ScheduleTimeBlock({
    required this.hour,
    required this.minute,
    this.onTimeChanged,
  });

  final int hour;
  final int minute;
  final void Function(int hour, int minute)? onTimeChanged;

  String get _formattedTime =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  Future<void> _showTimePicker(BuildContext context) async {
    if (onTimeChanged == null) {
      return;
    }

    final time = await showBreezTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );

    if (time != null) {
      onTimeChanged?.call(time.hour, time.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BreezButton(
      onTap: onTimeChanged != null ? () => _showTimePicker(context) : null,
      backgroundColor: AppColors.accent.withValues(alpha: 0.08),
      hoverColor: AppColors.accent.withValues(alpha: AppColors.opacitySubtle),
      border: Border.all(
        color: AppColors.accent.withValues(alpha: AppColors.opacityLow),
      ),
      borderRadius: _ScheduleConstants.borderRadius,
      padding: EdgeInsets.zero,
      enforceMinTouchTarget: false,
      enableScale: false,
      showBorder: false,
      semanticLabel: _formattedTime,
      child: Text(
        _formattedTime,
        style: TextStyle(
          fontSize: _ScheduleConstants.timeFontSize,
          fontWeight: FontWeight.w700,
          color: onTimeChanged != null ? colors.text : colors.textMuted,
        ),
      ),
    );
  }
}
