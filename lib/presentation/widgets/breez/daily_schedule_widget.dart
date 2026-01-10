/// Daily Schedule Widget - Weekly schedule with day tabs
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';
import '../../../domain/entities/mode_settings.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_card.dart';
import 'breez_tab.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы виджета расписания
abstract class _ScheduleConstants {
  static const double desktopTimeBlockHeight = 80.0;
  static const double borderRadius = 10.0;
  static const Duration animationDuration = Duration(milliseconds: 150);
  static const double timeFontSize = 22.0;
  static const double labelFontSize = 11.0;
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

  const DailyScheduleWidget({
    super.key,
    this.timerSettings,
    this.onDaySettingsChanged,
    this.compact = false,
    this.showCard = true,
    this.isEnabled = true,
  });

  @override
  State<DailyScheduleWidget> createState() => _DailyScheduleWidgetState();
}

class _DailyScheduleWidgetState extends State<DailyScheduleWidget> {
  /// Индекс выбранного дня (инициализация без late для hot reload)
  int _selectedIndex = DateTime.now().weekday - 1;

  /// Локальный кэш для optimistic updates
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
    // Merge local and server settings: prioritize local, fallback to server
    return DailyScheduleWidget.daysOrder
        .asMap()
        .entries
        .where((e) {
          final day = e.value;
          final settings = _localSettings[day] ?? widget.timerSettings?[day];
          return settings?.enabled ?? false;
        })
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

  @override
  Widget build(BuildContext context) {
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
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.text,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
        ],

        // Day tabs
        BreezTabGroup(
          labels: _DayNameResolver.getShortNames(l10n),
          selectedIndex: _selectedIndex,
          activeIndices: _activeIndices,
          compact: widget.compact,
          onTabSelected: (index) => setState(() => _selectedIndex = index),
        ),

        SizedBox(height: AppSpacing.xs),

        // Selected day settings
        Expanded(
          child: _DaySettingsPanel(
            dayKey: _selectedDay,
            settings: selectedSettings,
            compact: widget.compact,
            onSettingsChanged:
                widget.onDaySettingsChanged != null ? _handleSettingsChanged : null,
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
          padding: EdgeInsets.all(AppSpacing.xs),
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
  /// Маппинг ключей дней на полные имена
  static String getFullName(String dayKey, AppLocalizations l10n) {
    const dayKeys = DailyScheduleWidget.daysOrder;
    final dayNames = [
      l10n.monday,
      l10n.tuesday,
      l10n.wednesday,
      l10n.thursday,
      l10n.friday,
      l10n.saturday,
      l10n.sunday,
    ];

    final index = dayKeys.indexOf(dayKey);
    return index >= 0 ? dayNames[index] : dayKey;
  }

  /// Получить список коротких имён
  static List<String> getShortNames(AppLocalizations l10n) {
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
}

// =============================================================================
// DAY SETTINGS PANEL
// =============================================================================

/// Панель настроек выбранного дня
class _DaySettingsPanel extends StatelessWidget {
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

  const _DaySettingsPanel({
    required this.dayKey,
    required this.settings,
    required this.compact,
    this.onSettingsChanged,
  });

  void _onEnabledChanged(bool value) {
    onSettingsChanged?.call(
      settings.onHour,
      settings.onMinute,
      settings.offHour,
      settings.offMinute,
      value,
    );
  }

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

    return Column(
      mainAxisAlignment: compact ? MainAxisAlignment.center : MainAxisAlignment.start,
      mainAxisSize: compact ? MainAxisSize.max : MainAxisSize.min,
      children: [
        // Header: день и переключатель (общий для обоих layout)
        _DayHeader(
          dayKey: dayKey,
          isEnabled: settings.enabled,
          onEnabledChanged: onSettingsChanged != null ? _onEnabledChanged : null,
        ),

        SizedBox(height: AppSpacing.xs),

        // Time inputs
        _buildTimeInputs(l10n),
      ],
    );
  }

  Widget _buildTimeInputs(AppLocalizations l10n) {
    final timeRow = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _ScheduleTimeBlock(
            label: l10n.scheduleStartLabel,
            hour: settings.onHour,
            minute: settings.onMinute,
            onTimeChanged: onSettingsChanged != null && settings.enabled
                ? _onStartTimeChanged
                : null,
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _ScheduleTimeBlock(
            label: l10n.scheduleEndLabel,
            hour: settings.offHour,
            minute: settings.offMinute,
            onTimeChanged: onSettingsChanged != null && settings.enabled
                ? _onEndTimeChanged
                : null,
          ),
        ),
      ],
    );

    // Обёртка с opacity и ignore pointer для disabled состояния
    final wrappedRow = Opacity(
      opacity: settings.enabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !settings.enabled,
        child: timeRow,
      ),
    );

    if (compact) {
      // Mobile: растягиваем на всё доступное место
      return Expanded(child: wrappedRow);
    }

    // Desktop: фиксированная высота
    return SizedBox(
      height: _ScheduleConstants.desktopTimeBlockHeight,
      child: wrappedRow,
    );
  }
}

// =============================================================================
// DAY HEADER
// =============================================================================

/// Заголовок дня с переключателем
class _DayHeader extends StatelessWidget {
  final String dayKey;
  final bool isEnabled;
  final ValueChanged<bool>? onEnabledChanged;

  const _DayHeader({
    required this.dayKey,
    required this.isEnabled,
    this.onEnabledChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Название дня
        Semantics(
          header: true,
          child: Text(
            _DayNameResolver.getFullName(dayKey, l10n),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.text,
            ),
          ),
        ),

        // Статус и переключатель
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
            SizedBox(width: AppSpacing.xs),
            Semantics(
              label: isEnabled ? l10n.statusEnabled : l10n.statusDisabled,
              toggled: isEnabled,
              child: MouseRegion(
                cursor: onEnabledChanged != null
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                child: Switch(
                  value: isEnabled,
                  onChanged: onEnabledChanged,
                  activeTrackColor: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================================================
// SCHEDULE TIME BLOCK
// =============================================================================

/// Блок выбора времени для расписания
///
/// Отображает label и время, открывает системный TimePicker по клику.
/// Адаптируется к доступному размеру через FittedBox.
class _ScheduleTimeBlock extends StatefulWidget {
  final String label;
  final int hour;
  final int minute;
  final void Function(int hour, int minute)? onTimeChanged;

  const _ScheduleTimeBlock({
    required this.label,
    required this.hour,
    required this.minute,
    this.onTimeChanged,
  });

  @override
  State<_ScheduleTimeBlock> createState() => _ScheduleTimeBlockState();
}

class _ScheduleTimeBlockState extends State<_ScheduleTimeBlock> {
  bool _isHovered = false;

  String get _formattedTime =>
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

    if (time != null && mounted) {
      widget.onTimeChanged?.call(time.hour, time.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Semantics(
      button: true,
      label: '${widget.label}: $_formattedTime',
      child: MouseRegion(
        cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: _showTimePicker,
          child: AnimatedContainer(
            duration: _ScheduleConstants.animationDuration,
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.xxs,
              horizontal: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: _isHovered && _isEnabled
                  ? AppColors.accent.withValues(alpha: 0.15)
                  : AppColors.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(_ScheduleConstants.borderRadius),
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
                      fontSize: _ScheduleConstants.labelFontSize,
                      color: colors.textMuted,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(
                    _formattedTime,
                    style: TextStyle(
                      fontSize: _ScheduleConstants.timeFontSize,
                      fontWeight: FontWeight.w700,
                      color: _isEnabled ? colors.text : colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
