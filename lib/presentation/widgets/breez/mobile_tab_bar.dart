/// Mobile Tab Bar - сегментированный контрол для переключения контента
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_animations.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для MobileTabBar
abstract class _MobileTabConstants {
  static const double iconSize = 14.0;
  static const double fontSize = 11.0;
  static const double badgeSize = 16.0;
  static const double badgeFontSize = 9.0;
  static const double segmentPadding = 3.0; // Slightly less than xxs (4px) for tighter fit
}

// =============================================================================
// TYPES
// =============================================================================

/// Данные вкладки для MobileTabBar
class MobileTab {
  final IconData icon;
  final String label;
  final int? badgeCount;
  final Color? badgeColor;
  final Color? iconColor;

  const MobileTab({
    required this.icon,
    required this.label,
    this.badgeCount,
    this.badgeColor,
    this.iconColor,
  });
}

/// Сегментированный контрол для мобильного layout
///
/// Визуально отличается от навигации - выглядит как переключатель контента.
/// Поддерживает:
/// - Иконку + текст для каждого сегмента
/// - Badge с счётчиком
/// - Плавную анимацию переключения
/// - Accessibility через Semantics
class MobileTabBar extends StatefulWidget {
  final TabController controller;
  final List<MobileTab> tabs;

  const MobileTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  State<MobileTabBar> createState() => _MobileTabBarState();
}

class _MobileTabBarState extends State<MobileTabBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.controller.index;
    widget.controller.addListener(_handleTabChange);
  }

  @override
  void didUpdateWidget(MobileTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleTabChange);
      widget.controller.addListener(_handleTabChange);
      _currentIndex = widget.controller.index;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTabChange);
    super.dispose();
  }

  /// Обновляем только когда реально сменился индекс (не на каждый кадр анимации)
  void _handleTabChange() {
    if (widget.controller.index != _currentIndex) {
      setState(() {
        _currentIndex = widget.controller.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Semantics(
      label: 'Переключатель контента',
      child: Container(
        height: AppSizes.tabHeight,
        padding: EdgeInsets.all(_MobileTabConstants.segmentPadding),
        decoration: BoxDecoration(
          color: colors.buttonBg.withValues(alpha: AppColors.opacityMedium),
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        child: Row(
          children: List.generate(widget.tabs.length, (index) {
            final isSelected = _currentIndex == index;
            return Expanded(
              child: _SegmentButton(
                tab: widget.tabs[index],
                isSelected: isSelected,
                onTap: () => widget.controller.animateTo(index),
                colors: colors,
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Кнопка-сегмент
class _SegmentButton extends StatelessWidget {
  final MobileTab tab;
  final bool isSelected;
  final VoidCallback onTap;
  final BreezColors colors;

  const _SegmentButton({
    required this.tab,
    required this.isSelected,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final hasBadge = tab.badgeCount != null && tab.badgeCount! > 0;

    // Цвета: выбранный — акцентный текст на прозрачном фоне с подсветкой
    final textColor = isSelected ? AppColors.accent : colors.textMuted;
    final iconColor = isSelected
        ? (tab.iconColor ?? AppColors.accent)
        : (tab.iconColor ?? colors.textMuted);

    return Semantics(
      label: '${tab.label}${hasBadge ? ', ${tab.badgeCount} уведомлений' : ''}',
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.normal,
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accent.withValues(alpha: AppColors.opacitySubtle)
                : colors.bg.withValues(alpha: 0.0),
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: isSelected
                ? Border.all(color: AppColors.accent.withValues(alpha: AppColors.opacityLow))
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  tab.icon,
                  size: _MobileTabConstants.iconSize,
                  color: iconColor,
                ),
                SizedBox(width: AppSpacing.xxs),
                Text(
                  tab.label,
                  style: TextStyle(
                    fontSize: _MobileTabConstants.fontSize,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                  ),
                ),
                if (hasBadge) ...[
                  SizedBox(width: AppSpacing.xxs),
                  Container(
                    width: _MobileTabConstants.badgeSize,
                    height: _MobileTabConstants.badgeSize,
                    decoration: BoxDecoration(
                      color: tab.badgeColor ?? AppColors.accentRed,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${tab.badgeCount}',
                        style: const TextStyle(
                          fontSize: _MobileTabConstants.badgeFontSize,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
