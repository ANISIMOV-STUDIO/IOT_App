/// BREEZ Tab - базовый таб с состоянием
///
/// Компоненты:
/// - [BreezTab] - единичный таб с поддержкой selected/active состояний
/// - [BreezTabGroup] - горизонтальная группа табов
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_control/core/theme/app_theme.dart';
import 'package:hvac_control/core/theme/spacing.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для табов
abstract class _TabConstants {
  // Размеры
  static const double indicatorSize = 6;
  static const double paddingVerticalCompact = 6; // Between xxs (4) and xs (8)

  // Анимации
  static const Duration animationDuration = Duration(milliseconds: 150);

  // Типографика
  static const double fontSizeCompact = 10;
  static const double fontSizeNormal = 11;
}

// =============================================================================
// BREEZ TAB
// =============================================================================

/// Базовый компонент таба
///
/// Поддерживает:
/// - Выбранное состояние ([isSelected]) - визуальное выделение
/// - Активное состояние ([isActive]) - показывает индикатор (зелёную точку)
/// - Hover эффект и курсор pointer
/// - Компактный режим для mobile ([compact])
/// - Long press для дополнительного действия ([onLongPress])
/// - Accessibility через Semantics
///
/// Пример использования:
/// ```dart
/// BreezTab(
///   label: 'Пн',
///   isSelected: selectedDay == 0,
///   isActive: schedule[0].enabled,
///   onTap: () => selectDay(0),
///   onLongPress: () => toggleDay(0),
/// )
/// ```
class BreezTab extends StatefulWidget {

  const BreezTab({
    required this.label,
    super.key,
    this.isSelected = false,
    this.isActive = false,
    this.onTap,
    this.onLongPress,
    this.compact = false,
    this.activeIndicatorColor,
  });
  /// Текст таба
  final String label;

  /// Выбран ли таб (визуальное выделение)
  final bool isSelected;

  /// Активен ли таб (показывает индикатор, например зелёную точку)
  final bool isActive;

  /// Callback при нажатии
  final VoidCallback? onTap;

  /// Callback при долгом нажатии
  final VoidCallback? onLongPress;

  /// Компактный режим (меньше padding и font size)
  final bool compact;

  /// Цвет индикатора активности (по умолчанию [AppColors.accentGreen])
  final Color? activeIndicatorColor;

  @override
  State<BreezTab> createState() => _BreezTabState();
}

class _BreezTabState extends State<BreezTab> {
  bool _isHovered = false;

  bool get _isEnabled => widget.onTap != null;
  bool get _hasLongPress => widget.onLongPress != null;

  Color get _indicatorColor => widget.activeIndicatorColor ?? AppColors.accentGreen;

  void _handleLongPress() {
    if (_hasLongPress) {
      HapticFeedback.mediumImpact();
      widget.onLongPress!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: widget.label,
      child: MouseRegion(
        cursor: _isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          onLongPress: _hasLongPress ? _handleLongPress : null,
          child: AnimatedContainer(
            duration: _TabConstants.animationDuration,
            padding: EdgeInsets.symmetric(
              vertical: widget.compact ? _TabConstants.paddingVerticalCompact : AppSpacing.xs,
              horizontal: widget.compact ? AppSpacing.xs : AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: _buildBackgroundColor(colors),
              borderRadius: BorderRadius.circular(AppRadius.chip),
              border: Border.all(
                color: _buildBorderColor(colors),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label - фиксированный fontWeight для предотвращения layout shift
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: widget.compact
                        ? _TabConstants.fontSizeCompact
                        : _TabConstants.fontSizeNormal,
                    fontWeight: FontWeight.w600,
                    color: _buildTextColor(colors),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxs),

                // Индикатор активности (всегда занимает место для одинаковой высоты)
                Container(
                  width: _TabConstants.indicatorSize,
                  height: _TabConstants.indicatorSize,
                  decoration: BoxDecoration(
                    color: widget.isActive ? _indicatorColor : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _buildBackgroundColor(BreezColors colors) {
    if (widget.isSelected) {
      return colors.accent.withValues(alpha: AppColors.opacitySubtle);
    }
    if (_isHovered && _isEnabled) {
      return colors.border.withValues(alpha: AppColors.opacityLow);
    }
    return Colors.transparent;
  }

  Color _buildBorderColor(BreezColors colors) {
    if (widget.isSelected) {
      return colors.accent;
    }
    if (widget.isActive) {
      return _indicatorColor.withValues(alpha: AppColors.opacityMedium);
    }
    return colors.border;
  }

  Color _buildTextColor(BreezColors colors) {
    if (widget.isSelected) {
      return colors.accent;
    }
    if (widget.isActive) {
      return colors.text;
    }
    return colors.textMuted;
  }
}

// =============================================================================
// BREEZ TAB GROUP
// =============================================================================

/// Горизонтальная группа табов
///
/// Автоматически распределяет табы по ширине с равными промежутками.
/// Первый и последний таб не имеют внешних отступов для выравнивания
/// по краям родительского контейнера.
///
/// Пример использования:
/// ```dart
/// BreezTabGroup(
///   labels: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
///   selectedIndex: _selectedDay,
///   activeIndices: _enabledDays,
///   onTabSelected: (index) => setState(() => _selectedDay = index),
///   onTabLongPress: (index) => toggleEnabled(index),
/// )
/// ```
class BreezTabGroup extends StatelessWidget {

  const BreezTabGroup({
    required this.labels,
    required this.selectedIndex,
    super.key,
    this.activeIndices,
    this.onTabSelected,
    this.onTabLongPress,
    this.compact = false,
  });
  /// Список меток табов
  final List<String> labels;

  /// Индекс выбранного таба
  final int selectedIndex;

  /// Индексы активных табов (показывают индикатор)
  final Set<int>? activeIndices;

  /// Callback при выборе таба
  final ValueChanged<int>? onTabSelected;

  /// Callback при долгом нажатии на таб
  final ValueChanged<int>? onTabLongPress;

  /// Компактный режим
  final bool compact;

  @override
  Widget build(BuildContext context) => Semantics(
      label: 'Выбор дня недели',
      child: Row(
        children: List.generate(labels.length, _buildTab),
      ),
    );

  Widget _buildTab(int index) {
    final isFirst = index == 0;
    final isLast = index == labels.length - 1;

    return Expanded(
      child: Padding(
        // Отступы только между табами, не по краям
        padding: EdgeInsets.only(
          left: isFirst ? 0 : AppSpacing.xxs,
          right: isLast ? 0 : AppSpacing.xxs,
        ),
        child: BreezTab(
          label: labels[index],
          isSelected: index == selectedIndex,
          isActive: activeIndices?.contains(index) ?? false,
          onTap: onTabSelected != null ? () => onTabSelected!(index) : null,
          onLongPress: onTabLongPress != null ? () => onTabLongPress!(index) : null,
          compact: compact,
        ),
      ),
    );
  }
}
