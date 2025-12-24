/// Desktop Header - Header with unit tabs for desktop layout
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../widgets/common/hover_builder.dart';
import 'header_icon_button.dart';
import 'add_unit_button.dart';

/// Desktop header with unit tabs and user info
class DesktopHeader extends StatelessWidget {
  final List<UnitState> units;
  final int selectedUnitIndex;
  final ValueChanged<int>? onUnitSelected;
  final VoidCallback? onAddUnit;
  final bool isDark;
  final VoidCallback? onThemeToggle;
  final String userName;
  final String userRole;

  const DesktopHeader({
    super.key,
    required this.units,
    required this.selectedUnitIndex,
    this.onUnitSelected,
    this.onAddUnit,
    required this.isDark,
    this.onThemeToggle,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Unit tabs
        Expanded(child: _buildUnitTabs()),
        const SizedBox(width: 16),
        // Theme toggle
        HeaderIconButton(
          icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          onTap: onThemeToggle,
        ),
        const SizedBox(width: 8),
        // Notifications
        HeaderIconButton(
          icon: Icons.notifications_outlined,
          badge: '3',
          onTap: () {},
        ),
        const SizedBox(width: 16),
        // User info
        _buildUserInfo(),
      ],
    );
  }

  Widget _buildUnitTabs() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          // Unit tabs list
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: units.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final unit = units[index];
                final isSelected = index == selectedUnitIndex;
                return _UnitTab(
                  unit: unit,
                  isSelected: isSelected,
                  onTap: () => onUnitSelected?.call(index),
                );
              },
            ),
          ),
          // Add unit button
          AddUnitButton(onTap: onAddUnit),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        Text(
          userName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.accent, AppColors.accentLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(
              Icons.person,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/// Individual unit tab
class _UnitTab extends StatelessWidget {
  final UnitState unit;
  final bool isSelected;
  final VoidCallback? onTap;

  const _UnitTab({
    required this.unit,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      onTap: onTap,
      builder: (context, isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status indicator
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: unit.power
                      ? (isSelected ? Colors.white : AppColors.accentGreen)
                      : AppColors.darkTextMuted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              // Unit name
              Text(
                unit.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.darkTextMuted,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
