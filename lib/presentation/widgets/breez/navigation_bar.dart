/// Navigation Bar Component
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/breakpoints.dart';
import '../../../core/theme/spacing.dart';
import 'breez_card.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для BreezNavigationBar
abstract class _NavBarConstants {
  // Размеры - компактный режим (mobile)
  static const double barHeightCompact = 72.0;
  static const double buttonSizeCompact = 56.0;
  static const double iconSizeCompact = 24.0;

  // Размеры - полный режим (tablet/desktop)
  static const double barHeightNormal = 80.0;
  static const double buttonSizeNormal = 64.0;
  static const double iconSizeNormal = 28.0;

  // Тень
  static const double shadowBlur = 16.0;
  static const double shadowOffsetY = -4.0;
  static const double shadowOpacity = 0.1;

  // Отступы
  static const double dividerHeightRatio = 0.6;
}

// =============================================================================
// TYPES
// =============================================================================

/// Navigation item data
class NavigationItem {
  final IconData icon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.label,
  });
}

/// Bottom navigation bar component (adaptive)
class BreezNavigationBar extends StatelessWidget {
  final List<NavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final VoidCallback? onThemeToggle;

  const BreezNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onItemSelected,
    this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Адаптивная высота и размер кнопок на основе ширины экрана
        final screenWidth = MediaQuery.sizeOf(context).width;
        final isCompact = screenWidth < AppBreakpoints.mobile;
        final barHeight = isCompact
            ? _NavBarConstants.barHeightCompact
            : _NavBarConstants.barHeightNormal;
        final buttonSize = isCompact
            ? _NavBarConstants.buttonSizeCompact
            : _NavBarConstants.buttonSizeNormal;
        final iconSize = isCompact
            ? _NavBarConstants.iconSizeCompact
            : _NavBarConstants.iconSizeNormal;

        return Semantics(
          label: 'Панель навигации',
          child: Container(
            height: barHeight,
            margin: EdgeInsets.fromLTRB(
              AppSpacing.sm,
              0,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _NavBarConstants.shadowOpacity),
                  blurRadius: _NavBarConstants.shadowBlur,
                  offset: Offset(0, _NavBarConstants.shadowOffsetY),
                ),
              ],
            ),
            child: Row(
              children: [
                // Navigation items
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isSelected = index == selectedIndex;
                      return Semantics(
                        label: item.label,
                        selected: isSelected,
                        child: BreezButton(
                          onTap: () => onItemSelected?.call(index),
                          width: buttonSize,
                          height: buttonSize,
                          padding: EdgeInsets.zero,
                          backgroundColor: isSelected
                              ? AppColors.accent.withValues(alpha: 0.15)
                              : Colors.transparent,
                          hoverColor: isSelected
                              ? AppColors.accent.withValues(alpha: 0.25)
                              : colors.buttonBg,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent.withValues(alpha: 0.3)
                                : Colors.transparent,
                          ),
                          child: Icon(
                            item.icon,
                            size: iconSize,
                            color: isSelected ? AppColors.accent : colors.textMuted,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Additional actions (theme toggle)
                if (onThemeToggle != null) ...[
                  Container(
                    width: 1,
                    height: buttonSize * _NavBarConstants.dividerHeightRatio,
                    color: colors.border,
                    margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: AppSpacing.xxs),
                    child: Builder(
                      builder: (context) {
                        final isDark = Theme.of(context).brightness == Brightness.dark;
                        return Semantics(
                          label: isDark ? 'Светлая тема' : 'Тёмная тема',
                          child: BreezButton(
                            onTap: onThemeToggle,
                            width: buttonSize,
                            height: buttonSize,
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            hoverColor: colors.buttonBg,
                            child: Icon(
                              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              size: iconSize,
                              color: isDark ? colors.textMuted : AppColors.warning,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
