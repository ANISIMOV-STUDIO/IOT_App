/// BREEZ Tab - базовый таб с состоянием
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Базовый компонент таба
///
/// Поддерживает:
/// - Выбранное состояние (isSelected)
/// - Активное состояние (isActive) - показывает индикатор
/// - Hover эффект и курсор pointer
/// - Компактный режим
class BreezTab extends StatefulWidget {
  /// Текст таба
  final String label;

  /// Выбран ли таб
  final bool isSelected;

  /// Активен ли таб (показывает индикатор, например зелёную точку)
  final bool isActive;

  /// Callback при нажатии
  final VoidCallback? onTap;

  /// Компактный режим
  final bool compact;

  /// Цвет индикатора активности
  final Color? activeIndicatorColor;

  const BreezTab({
    super.key,
    required this.label,
    this.isSelected = false,
    this.isActive = false,
    this.onTap,
    this.compact = false,
    this.activeIndicatorColor,
  });

  @override
  State<BreezTab> createState() => _BreezTabState();
}

class _BreezTabState extends State<BreezTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    final indicatorColor = widget.activeIndicatorColor ?? AppColors.accentGreen;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            vertical: widget.compact ? 6 : 8,
            horizontal: widget.compact ? 8 : 12,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.accent.withValues(alpha: 0.15)
                : _isHovered
                    ? colors.border.withValues(alpha: 0.3)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.accent
                  : widget.isActive
                      ? indicatorColor.withValues(alpha: 0.5)
                      : colors.border,
              width: widget.isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.compact ? 10 : 11,
                  fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isSelected
                      ? AppColors.accent
                      : widget.isActive
                          ? colors.text
                          : colors.textMuted,
                ),
              ),
              const SizedBox(height: 2),
              // Индикатор активности (всегда занимает место для одинаковой высоты)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: widget.isActive ? indicatorColor : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Горизонтальная группа табов
class BreezTabGroup extends StatelessWidget {
  /// Список меток табов
  final List<String> labels;

  /// Индекс выбранного таба
  final int selectedIndex;

  /// Индексы активных табов (показывают индикатор)
  final Set<int>? activeIndices;

  /// Callback при выборе таба
  final ValueChanged<int>? onTabSelected;

  /// Компактный режим
  final bool compact;

  const BreezTabGroup({
    super.key,
    required this.labels,
    required this.selectedIndex,
    this.activeIndices,
    this.onTabSelected,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: BreezTab(
              label: labels[index],
              isSelected: index == selectedIndex,
              isActive: activeIndices?.contains(index) ?? false,
              onTap: onTabSelected != null ? () => onTabSelected!(index) : null,
              compact: compact,
            ),
          ),
        );
      }),
    );
  }
}
