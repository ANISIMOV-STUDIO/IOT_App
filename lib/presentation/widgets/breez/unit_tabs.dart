/// Unit Tabs with consistent styling
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';

/// Unit tab data
class UnitTabData {
  final String id;
  final String name;
  final bool isActive;

  const UnitTabData({
    required this.id,
    required this.name,
    this.isActive = false,
  });
}

/// Single unit tab button
class UnitTab extends StatelessWidget {
  final String name;
  final bool isSelected;
  final bool isActive;
  final VoidCallback? onTap;

  const UnitTab({
    super.key,
    required this.name,
    this.isSelected = false,
    this.isActive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BreezButton(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: 20,
      backgroundColor: isSelected
          ? AppColors.accent
          : Colors.white.withValues(alpha: 0.05),
      hoverColor: isSelected
          ? AppColors.accentLight
          : Colors.white.withValues(alpha: 0.1),
      border: Border.all(
        color: isSelected ? AppColors.accent : Colors.transparent,
      ),
      shadows: isSelected
          ? [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: 12,
              ),
            ]
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isActive)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.accentRed,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Text(
            name.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: isSelected ? Colors.white : AppColors.darkTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// Unit tabs bar
class UnitTabs extends StatelessWidget {
  final List<UnitTabData> units;
  final int selectedIndex;
  final ValueChanged<int>? onUnitSelected;
  final VoidCallback? onAddUnit;

  const UnitTabs({
    super.key,
    required this.units,
    required this.selectedIndex,
    this.onUnitSelected,
    this.onAddUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        border: Border(
          bottom: BorderSide(color: AppColors.darkBorder),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ...units.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: UnitTab(
                  name: entry.value.name,
                  isSelected: entry.key == selectedIndex,
                  isActive: entry.value.isActive,
                  onTap: () => onUnitSelected?.call(entry.key),
                ),
              );
            }),
            // Add button (48px touch target)
            BreezButton(
              onTap: onAddUnit,
              width: 32,
              height: 32,
              padding: const EdgeInsets.all(8), // Expands touch area
              borderRadius: 16,
              child: Icon(
                Icons.add,
                size: 16,
                color: AppColors.darkTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
