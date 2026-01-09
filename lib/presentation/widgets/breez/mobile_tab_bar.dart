/// Mobile Tab Bar - компактный tab bar для mobile layout
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';

// =============================================================================
// CONSTANTS
// =============================================================================

/// Константы для MobileTabBar
abstract class _MobileTabConstants {
  static const double height = 40.0;
  static const double iconSize = 14.0;
  static const double fontSize = 10.0;
  static const double badgeFontSize = 9.0;
  static const double badgePaddingH = 4.0;
  static const double badgePaddingV = 1.0;
  static const double badgeRadius = 6.0;
  static const double indicatorPadding = 4.0;
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

/// Компактный tab bar для мобильного layout
///
/// Поддерживает:
/// - Иконку + текст для каждой вкладки
/// - Badge с счётчиком
/// - Кастомные цвета иконки
/// - Accessibility через Semantics
class MobileTabBar extends StatelessWidget {
  final TabController controller;
  final List<MobileTab> tabs;

  const MobileTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Semantics(
      label: 'Панель вкладок',
      child: Container(
        height: _MobileTabConstants.height,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.cardSmall),
          border: Border.all(color: colors.border),
        ),
        child: TabBar(
          controller: controller,
          indicator: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppRadius.cardSmall - 2),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.all(_MobileTabConstants.indicatorPadding),
          labelPadding: EdgeInsets.zero,
          dividerColor: Colors.transparent,
          labelColor: AppColors.accent,
          unselectedLabelColor: colors.textMuted,
          labelStyle: TextStyle(
            fontSize: _MobileTabConstants.fontSize,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: _MobileTabConstants.fontSize,
            fontWeight: FontWeight.w500,
          ),
          tabs: tabs.map(_buildTab).toList(),
        ),
      ),
    );
  }

  Widget _buildTab(MobileTab tab) {
    final hasBadge = tab.badgeCount != null && tab.badgeCount! > 0;

    return Semantics(
      label: '${tab.label}${hasBadge ? ', ${tab.badgeCount} уведомлений' : ''}',
      child: Tab(
        height: _MobileTabConstants.height - _MobileTabConstants.indicatorPadding * 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tab.icon,
              size: _MobileTabConstants.iconSize,
              color: tab.iconColor,
            ),
            SizedBox(width: AppSpacing.xxs),
            Text(tab.label.toUpperCase()),
            if (hasBadge) ...[
              SizedBox(width: AppSpacing.xxs),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _MobileTabConstants.badgePaddingH,
                  vertical: _MobileTabConstants.badgePaddingV,
                ),
                decoration: BoxDecoration(
                  color: tab.badgeColor ?? AppColors.accentRed,
                  borderRadius: BorderRadius.circular(_MobileTabConstants.badgeRadius),
                ),
                child: Text(
                  '${tab.badgeCount}',
                  style: TextStyle(
                    fontSize: _MobileTabConstants.badgeFontSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
