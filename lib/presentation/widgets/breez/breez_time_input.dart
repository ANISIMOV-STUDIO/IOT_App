/// BREEZ Time Input - компонент выбора времени
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_animations.dart';
import 'package:hvac_control/core/theme/app_theme.dart';

/// Компонент отображения и выбора времени
///
/// Показывает время в формате HH:MM и открывает системный TimePicker по клику.
/// Поддерживает:
/// - Компактный режим
/// - Hover эффект
/// - Кастомные цвета
/// - Label (опционально)
class BreezTimeInput extends StatefulWidget {

  const BreezTimeInput({
    required this.hour, required this.minute, super.key,
    this.onTimeChanged,
    this.label,
    this.compact = false,
    this.backgroundColor,
    this.borderColor,
  });
  /// Часы (0-23)
  final int hour;

  /// Минуты (0-59)
  final int minute;

  /// Callback при изменении времени
  final void Function(int hour, int minute)? onTimeChanged;

  /// Label над инпутом
  final String? label;

  /// Компактный режим
  final bool compact;

  /// Цвет фона
  final Color? backgroundColor;

  /// Цвет границы
  final Color? borderColor;

  @override
  State<BreezTimeInput> createState() => _BreezTimeInputState();
}

class _BreezTimeInputState extends State<BreezTimeInput> {
  bool _isHovered = false;

  String get _timeText =>
      '${widget.hour.toString().padLeft(2, '0')}:${widget.minute.toString().padLeft(2, '0')}';

  bool get _isEnabled => widget.onTimeChanged != null;

  Future<void> _showTimePicker() async {
    if (!_isEnabled) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: widget.hour, minute: widget.minute),
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        ),
    );

    if (time != null) {
      widget.onTimeChanged?.call(time.hour, time.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final bgColor = widget.backgroundColor ?? colors.accent.withValues(alpha: 0.1);
    final brColor = widget.borderColor ?? colors.accent.withValues(alpha: 0.3);

    final input = MouseRegion(
      cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _showTimePicker,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 12 : 16,
            vertical: widget.compact ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: _isHovered && _isEnabled
                ? bgColor.withValues(alpha: 0.2)
                : bgColor,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(
              color: _isHovered && _isEnabled
                  ? colors.accent.withValues(alpha: 0.5)
                  : brColor,
            ),
          ),
          child: Text(
            _timeText,
            style: TextStyle(
              fontSize: widget.compact ? 16 : 20,
              fontWeight: FontWeight.w700,
              color: _isEnabled ? colors.text : colors.textMuted,
            ),
          ),
        ),
      ),
    );

    if (widget.label != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: widget.compact ? 13 : 14,
              color: colors.textMuted,
            ),
          ),
          input,
        ],
      );
    }

    return input;
  }
}

/// Компактный inline time display (без TimePicker)
class BreezTimeDisplay extends StatelessWidget {

  const BreezTimeDisplay({
    required this.hour, required this.minute, super.key,
    this.fontSize,
    this.color,
  });
  /// Часы (0-23)
  final int hour;

  /// Минуты (0-59)
  final int minute;

  /// Размер шрифта
  final double? fontSize;

  /// Цвет текста
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final timeText =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

    return Text(
      timeText,
      style: TextStyle(
        fontSize: fontSize ?? 14,
        fontWeight: FontWeight.w600,
        color: color ?? colors.text,
      ),
    );
  }
}
