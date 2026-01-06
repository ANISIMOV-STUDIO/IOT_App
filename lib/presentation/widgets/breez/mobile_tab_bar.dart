/// Mobile Tab Bar - компактный tab bar для mobile layout
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';

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

    return Container(
      height: 40,
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
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelColor: AppColors.accent,
        unselectedLabelColor: colors.textMuted,
        labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        tabs: tabs.map(_buildTab).toList(),
      ),
    );
  }

  Widget _buildTab(MobileTab tab) {
    final hasBadge = tab.badgeCount != null && tab.badgeCount! > 0;

    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            tab.icon,
            size: 14,
            color: tab.iconColor,
          ),
          const SizedBox(width: 4),
          Text(tab.label.toUpperCase()),
          if (hasBadge) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: tab.badgeColor ?? AppColors.accentRed,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${tab.badgeCount}',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
