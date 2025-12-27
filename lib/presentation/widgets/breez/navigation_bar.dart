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

/// Bottom navigation bar component
class BreezNavigationBar extends StatelessWidget {
  final List<NavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final double? height;

  const BreezNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onItemSelected,
    this.height = 72,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return Container(
      height: height,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == selectedIndex;
          return BreezButton(
            onTap: () => onItemSelected?.call(index),
            width: 56,
            height: 56,
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
              size: 24,
              color: isSelected ? AppColors.accent : colors.textMuted,
            ),
          );
        }).toList(),
      ),
    );
  }
}
