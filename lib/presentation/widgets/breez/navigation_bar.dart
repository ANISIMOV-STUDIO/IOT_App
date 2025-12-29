/// Navigation Bar Component
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/spacing.dart';
import 'breez_card.dart';

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
  final bool isDark;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onNotificationsTap;
  final String? notificationsBadge;

  const BreezNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onItemSelected,
    this.isDark = true,
    this.onThemeToggle,
    this.onNotificationsTap,
    this.notificationsBadge,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Адаптивная высота и размер кнопок на основе ширины экрана
        final screenWidth = MediaQuery.sizeOf(context).width;
        final isCompact = screenWidth < 600; // телефон
        final barHeight = isCompact ? 72.0 : 80.0;
        final buttonSize = isCompact ? 56.0 : 64.0;
        final iconSize = isCompact ? 24.0 : 28.0;

        return Container(
          height: barHeight,
          margin: const EdgeInsets.fromLTRB(
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
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, -4),
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
                    return BreezButton(
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
                    );
                  }).toList(),
                ),
              ),

              // Additional actions (theme toggle, notifications)
              if (onThemeToggle != null || onNotificationsTap != null) ...[
                Container(
                  width: 1,
                  height: buttonSize * 0.6,
                  color: colors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ],

              // Theme toggle
              if (onThemeToggle != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
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
                      color: isDark
                          ? colors.textMuted
                          : AppColors.warning, // Желто-оранжевая иконка солнца в светлой теме
                    ),
                  ),
                ),

              // Notifications
              if (onNotificationsTap != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      BreezButton(
                        onTap: onNotificationsTap,
                        width: buttonSize,
                        height: buttonSize,
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        hoverColor: colors.buttonBg,
                        child: Icon(
                          Icons.notifications_outlined,
                          size: iconSize,
                          color: notificationsBadge != null
                              ? AppColors.accent // Синяя иконка если есть уведомления
                              : colors.textMuted,
                        ),
                      ),
                      if (notificationsBadge != null)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.accentRed,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Center(
                              child: Text(
                                notificationsBadge!,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
