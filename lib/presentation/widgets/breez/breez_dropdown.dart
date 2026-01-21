/// BREEZ Dropdown - Стилизованный выпадающий список с поддержкой accessibility
library;

import 'package:flutter/material.dart';
import 'package:hvac_control/core/theme/app_icon_sizes.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezDropdown
abstract class _DropdownConstants {
  static const double labelFontSize = 12;
  static const double textFontSize = 14;
  static const double subtitleFontSize = 12;
  static const double helperFontSize = 11;
  static const double disabledAlpha = 0.5;
}

// =============================================================================
// MAIN WIDGET
// =============================================================================

/// Стилизованный выпадающий список в дизайн-системе BREEZ
///
/// Особенности:
/// - Единый стиль с другими BREEZ компонентами
/// - Встроенная поддержка accessibility (Semantics, labels)
/// - Опциональные label и helper text
/// - Поддержка состояния ошибки
class BreezDropdown<T> extends StatelessWidget {

  const BreezDropdown({
    required this.value, required this.items, required this.onChanged, super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.semanticLabel,
    this.prefixIcon,
  });
  /// Текущее выбранное значение
  final T? value;

  /// Список доступных элементов
  final List<BreezDropdownItem<T>> items;

  /// Вызывается при изменении выбора
  final ValueChanged<T?>? onChanged;

  /// Опциональный label над dropdown
  final String? label;

  /// Опциональный hint когда ничего не выбрано
  final String? hint;

  /// Опциональный вспомогательный текст под dropdown
  final String? helperText;

  /// Опциональный текст ошибки (показывает состояние ошибки)
  final String? errorText;

  /// Включен ли dropdown
  final bool enabled;

  /// Семантическая метка для screen readers
  final String? semanticLabel;

  /// Иконка в начале
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Semantics(
      label: semanticLabel ?? label,
      enabled: enabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          if (label != null) ...[
            Text(
              label!,
              style: TextStyle(
                fontSize: _DropdownConstants.labelFontSize,
                fontWeight: FontWeight.w500,
                color: hasError ? AppColors.accentRed : colors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs + 2), // 6px
          ],

          // Dropdown
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.buttonBg,
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(
                color: hasError ? AppColors.accentRed : colors.border,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<T>(
                  value: value,
                  isExpanded: true,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: enabled
                        ? colors.textMuted
                        : colors.textMuted.withValues(alpha: _DropdownConstants.disabledAlpha),
                  ),
                  hint: hint != null
                      ? Text(
                          hint!,
                          style: TextStyle(
                            fontSize: _DropdownConstants.textFontSize,
                            color: colors.textMuted,
                          ),
                        )
                      : null,
                  style: TextStyle(
                    fontSize: _DropdownConstants.textFontSize,
                    color: colors.text,
                  ),
                  dropdownColor: colors.card,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  padding: EdgeInsets.only(
                    left: prefixIcon != null ? AppSpacing.xs : AppSpacing.sm,
                    right: AppSpacing.xs,
                  ),
                  onChanged: enabled ? onChanged : null,
                  selectedItemBuilder: (context) => items.map((item) => Row(
                        children: [
                          if (prefixIcon != null) ...[
                            Icon(prefixIcon, size: AppIconSizes.standard, color: colors.textMuted),
                            const SizedBox(width: AppSpacing.xs),
                          ],
                          Expanded(
                            child: Text(
                              item.label,
                              style: TextStyle(
                                fontSize: _DropdownConstants.textFontSize,
                                color: enabled ? colors.text : colors.textMuted,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )).toList(),
                  items: items.map((item) {
                    final isSelected = item.value == value;
                    return DropdownMenuItem<T>(
                      value: item.value,
                      child: Row(
                        children: [
                          if (item.icon != null) ...[
                            Icon(
                              item.icon,
                              size: AppIconSizes.standard,
                              color: isSelected ? AppColors.accent : colors.textMuted,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: _DropdownConstants.textFontSize,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    color: isSelected ? AppColors.accent : colors.text,
                                  ),
                                ),
                                if (item.subtitle != null)
                                  Text(
                                    item.subtitle!,
                                    style: TextStyle(
                                      fontSize: _DropdownConstants.subtitleFontSize,
                                      color: colors.textMuted,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              size: AppIconSizes.standard,
                              color: AppColors.accent,
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Helper/Error text
          if (helperText != null || errorText != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              errorText ?? helperText ?? '',
              style: TextStyle(
                fontSize: _DropdownConstants.helperFontSize,
                color: hasError ? AppColors.accentRed : colors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Элемент для BreezDropdown
class BreezDropdownItem<T> {

  const BreezDropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
  /// Значение которое представляет элемент
  final T value;

  /// Отображаемый текст
  final String label;

  /// Опциональный подзаголовок
  final String? subtitle;

  /// Опциональная иконка
  final IconData? icon;
}

/// Простой строковый dropdown для типичных случаев
class BreezStringDropdown extends StatelessWidget {

  const BreezStringDropdown({
    required this.value, required this.items, required this.onChanged, super.key,
    this.label,
    this.hint,
    this.enabled = true,
    this.semanticLabel,
  });
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? label;
  final String? hint;
  final bool enabled;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => BreezDropdown<String>(
      value: value,
      items: items.map((s) => BreezDropdownItem(value: s, label: s)).toList(),
      onChanged: onChanged,
      label: label,
      hint: hint,
      enabled: enabled,
      semanticLabel: semanticLabel,
    );
}
