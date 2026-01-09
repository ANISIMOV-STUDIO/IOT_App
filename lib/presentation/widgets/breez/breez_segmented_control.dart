/// BREEZ Segmented Control - Сегментированный переключатель с accessibility
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n/app_localizations.dart';
import 'breez_button.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

abstract class _SegmentedControlConstants {
  static const double defaultHeight = 40.0;
  static const double fontSize = 13.0;
  static const double iconSize = 16.0;
  static const double iconTextGap = 6.0;
  static const Duration animationDuration = Duration(milliseconds: 150);
}

/// Стилизованный сегментированный контрол в дизайн-системе BREEZ
///
/// Особенности:
/// - Анимированный индикатор выбора
/// - Встроенная поддержка accessibility (Semantics, labels)
/// - Настраиваемое оформление
/// - Поддержка иконок + текста
class BreezSegmentedControl<T> extends StatelessWidget {
  /// Текущее выбранное значение
  final T value;

  /// Список сегментов
  final List<BreezSegment<T>> segments;

  /// Вызывается при изменении выбора
  final ValueChanged<T>? onChanged;

  /// Включен ли контрол
  final bool enabled;

  /// Семантическая метка для всего контрола
  final String? semanticLabel;

  /// Высота контрола
  final double height;

  /// Растягивать ли на всю доступную ширину
  final bool expanded;

  const BreezSegmentedControl({
    super.key,
    required this.value,
    required this.segments,
    required this.onChanged,
    this.enabled = true,
    this.semanticLabel,
    this.height = _SegmentedControlConstants.defaultHeight,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      label: semanticLabel ?? l10n.segmentSelection,
      enabled: enabled,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(AppSpacing.xxs),
        decoration: BoxDecoration(
          color: colors.buttonBg,
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(color: colors.border),
        ),
        child: expanded
            ? Row(
                children: _buildSegments(context, colors),
              )
            : IntrinsicWidth(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildSegments(context, colors),
                ),
              ),
      ),
    );
  }

  List<Widget> _buildSegments(BuildContext context, BreezColors colors) {
    return segments.asMap().entries.map((entry) {
      final index = entry.key;
      final segment = entry.value;
      final isSelected = segment.value == value;
      final isFirst = index == 0;
      final isLast = index == segments.length - 1;

      Widget segmentWidget = _SegmentButton<T>(
        segment: segment,
        isSelected: isSelected,
        isFirst: isFirst,
        isLast: isLast,
        enabled: enabled && segment.enabled,
        onTap: enabled && segment.enabled
            ? () => onChanged?.call(segment.value)
            : null,
        colors: colors,
      );

      if (expanded) {
        segmentWidget = Expanded(child: segmentWidget);
      }

      return segmentWidget;
    }).toList();
  }
}

/// Кнопка отдельного сегмента
class _SegmentButton<T> extends StatelessWidget {
  final BreezSegment<T> segment;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final bool enabled;
  final VoidCallback? onTap;
  final BreezColors colors;

  const _SegmentButton({
    required this.segment,
    required this.isSelected,
    required this.isFirst,
    required this.isLast,
    required this.enabled,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor();

    return BreezButton(
      onTap: onTap,
      backgroundColor: isSelected
          ? AppColors.accent.withValues(alpha: 0.15)
          : Colors.transparent,
      hoverColor: isSelected
          ? AppColors.accent.withValues(alpha: 0.25)
          : colors.buttonHover,
      border: isSelected
          ? Border.all(color: AppColors.accent.withValues(alpha: 0.3))
          : null,
      showBorder: false,
      enableGlow: false,
      enableScale: false,
      borderRadius: AppRadius.nested,
      semanticLabel: segment.semanticLabel ?? segment.label,
      tooltip: segment.tooltip,
      child: AnimatedDefaultTextStyle(
        duration: _SegmentedControlConstants.animationDuration,
        style: TextStyle(
          fontSize: _SegmentedControlConstants.fontSize,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: textColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (segment.icon != null) ...[
              Icon(
                segment.icon,
                size: _SegmentedControlConstants.iconSize,
                color: textColor,
              ),
              if (segment.label.isNotEmpty)
                const SizedBox(width: _SegmentedControlConstants.iconTextGap),
            ],
            if (segment.label.isNotEmpty)
              Text(
                segment.label,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  Color _getTextColor() {
    if (!enabled) {
      return colors.textMuted.withValues(alpha: 0.5);
    }
    if (isSelected) {
      return AppColors.accent;
    }
    return colors.textMuted;
  }
}

/// Данные сегмента для BreezSegmentedControl
class BreezSegment<T> {
  /// Значение которое представляет сегмент
  final T value;

  /// Отображаемый текст
  final String label;

  /// Опциональная иконка
  final IconData? icon;

  /// Включен ли этот сегмент
  final bool enabled;

  /// Семантическая метка для screen readers
  final String? semanticLabel;

  /// Текст tooltip
  final String? tooltip;

  const BreezSegment({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
    this.semanticLabel,
    this.tooltip,
  });

  /// Создать сегмент только с иконкой
  const BreezSegment.icon({
    required this.value,
    required IconData this.icon,
    this.enabled = true,
    this.semanticLabel,
    this.tooltip,
  }) : label = '';
}

/// Строковый сегментированный контрол для простых случаев
class BreezStringSegmentedControl extends StatelessWidget {
  final String value;
  final List<String> segments;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final String? semanticLabel;
  final double height;
  final bool expanded;

  const BreezStringSegmentedControl({
    super.key,
    required this.value,
    required this.segments,
    required this.onChanged,
    this.enabled = true,
    this.semanticLabel,
    this.height = _SegmentedControlConstants.defaultHeight,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return BreezSegmentedControl<String>(
      value: value,
      segments: segments
          .map((s) => BreezSegment(value: s, label: s))
          .toList(),
      onChanged: onChanged,
      enabled: enabled,
      semanticLabel: semanticLabel,
      height: height,
      expanded: expanded,
    );
  }
}

/// Иконочный сегментированный контрол для переключения режимов
class BreezIconSegmentedControl<T> extends StatelessWidget {
  final T value;
  final List<BreezIconSegment<T>> segments;
  final ValueChanged<T>? onChanged;
  final bool enabled;
  final String? semanticLabel;
  final double height;

  const BreezIconSegmentedControl({
    super.key,
    required this.value,
    required this.segments,
    required this.onChanged,
    this.enabled = true,
    this.semanticLabel,
    this.height = _SegmentedControlConstants.defaultHeight,
  });

  @override
  Widget build(BuildContext context) {
    return BreezSegmentedControl<T>(
      value: value,
      segments: segments
          .map((s) => BreezSegment<T>.icon(
                value: s.value,
                icon: s.icon,
                enabled: s.enabled,
                semanticLabel: s.semanticLabel,
                tooltip: s.tooltip,
              ))
          .toList(),
      onChanged: onChanged,
      enabled: enabled,
      semanticLabel: semanticLabel,
      height: height,
      expanded: false,
    );
  }
}

/// Данные иконочного сегмента
class BreezIconSegment<T> {
  final T value;
  final IconData icon;
  final bool enabled;
  final String? semanticLabel;
  final String? tooltip;

  const BreezIconSegment({
    required this.value,
    required this.icon,
    this.enabled = true,
    this.semanticLabel,
    this.tooltip,
  });
}
