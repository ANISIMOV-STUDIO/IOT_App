/// BREEZ Slider - Стилизованный слайдер с поддержкой accessibility
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezSlider
abstract class _SliderConstants {
  static const double defaultTrackHeight = 6;
  static const double defaultThumbRadius = 8;
  static const double overlayAlpha = 0.2;
  static const double disabledActiveAlpha = 0.5;
  static const double disabledInactiveAlpha = 0.2;
}

/// Константы для BreezLabeledSlider
abstract class _LabeledSliderConstants {
  static const double labelFontSize = 11;
  static const double valueFontSize = 11;
}

// =============================================================================
// SCROLL BEHAVIOR
// =============================================================================

/// ScrollBehavior для слайдера - разрешает touch для drag (не scroll)
class _SliderScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.mouse,
    // НЕ включаем touch - чтобы слайдер мог его использовать
  };
}

/// Стилизованный слайдер в дизайн-системе BREEZ
///
/// Особенности:
/// - Полная поддержка accessibility (Semantics)
/// - Настраиваемые цвета и стилизация
/// - Опциональные label и отображение значения
/// - Локальное состояние для мгновенной визуальной обратной связи
class BreezSlider extends StatefulWidget {

  const BreezSlider({
    required this.value, super.key,
    this.min = 0,
    this.max = 100,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.activeColor,
    this.inactiveColor,
    this.trackHeight = _SliderConstants.defaultTrackHeight,
    this.thumbRadius = _SliderConstants.defaultThumbRadius,
    this.enabled = true,
    this.semanticLabel,
    this.valueFormat,
  });
  /// Текущее значение (0-100 или кастомный диапазон)
  final double value;

  /// Минимальное значение
  final double min;

  /// Максимальное значение
  final double max;

  /// Вызывается при изменении значения
  final ValueChanged<double>? onChanged;

  /// Вызывается при начале перетаскивания
  final ValueChanged<double>? onChangeStart;

  /// Вызывается при окончании перетаскивания
  final ValueChanged<double>? onChangeEnd;

  /// Цвет активного трека
  final Color? activeColor;

  /// Цвет неактивного трека
  final Color? inactiveColor;

  /// Высота трека (по умолчанию 6.0)
  final double trackHeight;

  /// Радиус ползунка (по умолчанию 8.0)
  final double thumbRadius;

  /// Включен ли слайдер
  final bool enabled;

  /// Семантическая метка для screen readers
  final String? semanticLabel;

  /// Функция форматирования значения для объявлений accessibility
  final String Function(double)? valueFormat;

  @override
  State<BreezSlider> createState() => _BreezSliderState();
}

class _BreezSliderState extends State<BreezSlider> {
  late double _localValue;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _localValue = widget.value.clamp(widget.min, widget.max);
  }

  @override
  void didUpdateWidget(BreezSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Синхронизируем с внешним значением только когда не перетаскиваем
    if (!_isDragging && widget.value != oldWidget.value) {
      _localValue = widget.value.clamp(widget.min, widget.max);
    }
  }

  String _formatValue(double value) {
    if (widget.valueFormat != null) {
      return widget.valueFormat!(value);
    }
    return '${value.round()}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = widget.activeColor ?? AppColors.accent;
    final inactiveColor = widget.inactiveColor ??
        (isDark ? AppColors.darkHoverOverlay : AppColors.lightHoverOverlay);

    return Semantics(
      label: widget.semanticLabel,
      value: _formatValue(_localValue),
      slider: true,
      enabled: widget.enabled,
      onIncrease: widget.enabled && widget.onChanged != null
          ? () {
              final newValue = (_localValue + 1).clamp(widget.min, widget.max);
              widget.onChanged!(newValue);
            }
          : null,
      increasedValue: widget.enabled && widget.onChanged != null
          ? _formatValue((_localValue + 1).clamp(widget.min, widget.max))
          : null,
      onDecrease: widget.enabled && widget.onChanged != null
          ? () {
              final newValue = (_localValue - 1).clamp(widget.min, widget.max);
              widget.onChanged!(newValue);
            }
          : null,
      decreasedValue: widget.enabled && widget.onChanged != null
          ? _formatValue((_localValue - 1).clamp(widget.min, widget.max))
          : null,
      child: ScrollConfiguration(
        behavior: _SliderScrollBehavior(),
        child: SliderTheme(
          data: SliderThemeData(
            activeTrackColor: activeColor,
            inactiveTrackColor: inactiveColor,
            thumbColor: activeColor,
            overlayColor: activeColor.withValues(alpha: _SliderConstants.overlayAlpha),
            disabledActiveTrackColor: colors.textMuted.withValues(alpha: _SliderConstants.disabledActiveAlpha),
            disabledInactiveTrackColor: colors.textMuted.withValues(alpha: _SliderConstants.disabledInactiveAlpha),
            disabledThumbColor: colors.textMuted,
            trackHeight: widget.trackHeight,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: widget.thumbRadius,
            ),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius: widget.thumbRadius * 2,
            ),
          ),
          child: Slider(
            value: _localValue,
            min: widget.min,
            max: widget.max,
            onChangeStart: widget.enabled
                ? (v) {
                    setState(() => _isDragging = true);
                    widget.onChangeStart?.call(v);
                  }
                : null,
            // Только обновляем визуальное состояние при перетаскивании
            // callback onChanged вызывается синхронно для smooth UI
            onChanged: widget.enabled
                ? (v) {
                    setState(() => _localValue = v);
                    // Вызываем onChanged если передан (для синхронного UI feedback)
                    widget.onChanged?.call(v);
                  }
                : null,
            // Вызываем onChangeEnd когда пользователь отпустил ползунок
            onChangeEnd: widget.enabled
                ? (v) {
                    setState(() => _isDragging = false);
                    widget.onChangeEnd?.call(v);
                  }
                : null,
          ),
        ),
      ),
    );
  }
}

/// Слайдер с меткой, иконкой и отображением значения
///
/// Типичный случай для скорости вентилятора, громкости, яркости и т.д.
class BreezLabeledSlider extends StatelessWidget {

  const BreezLabeledSlider({
    required this.label, required this.value, super.key,
    this.min = 0,
    this.max = 100,
    this.color,
    this.icon,
    this.onChanged,
    this.onChangeEnd,
    this.enabled = true,
    this.semanticLabel,
    this.suffix,
    this.valueFormat,
    this.valueOverride,
  });
  final String label;
  final double value;
  final double min;
  final double max;
  final Color? color;
  final IconData? icon;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;
  final bool enabled;
  final String? semanticLabel;
  final String? suffix;
  final String Function(double)? valueFormat;

  /// Переопределение отображаемого значения (например, "—" когда данных нет)
  final String? valueOverride;

  String _formatDisplay() {
    // Если есть переопределение — используем его (например, "—")
    if (valueOverride != null) {
      return valueOverride!;
    }
    if (valueFormat != null) {
      return valueFormat!(value);
    }
    final displaySuffix = suffix ?? '%';
    return '${value.round()}$displaySuffix';
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final effectiveColor = color ?? AppColors.accent;

    return Semantics(
      label: semanticLabel ?? '$label: ${_formatDisplay()}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row with value aligned to slider bounds
          Padding(
            padding: const EdgeInsets.only(
              left: _SliderConstants.defaultThumbRadius,
              right: _SliderConstants.defaultThumbRadius * 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: AppIconSizes.standard, color: effectiveColor),
                      const SizedBox(width: AppSpacing.xxs),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: _LabeledSliderConstants.labelFontSize,
                        fontWeight: FontWeight.w500,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatDisplay(),
                  style: TextStyle(
                    fontSize: _LabeledSliderConstants.valueFontSize,
                    fontWeight: FontWeight.w700,
                    color: effectiveColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          BreezSlider(
            value: value,
            min: min,
            max: max,
            activeColor: effectiveColor,
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
            enabled: enabled,
            semanticLabel: semanticLabel ?? label,
            valueFormat: (v) => '${v.round()}${suffix ?? '%'}',
          ),
        ],
      ),
    );
  }
}
