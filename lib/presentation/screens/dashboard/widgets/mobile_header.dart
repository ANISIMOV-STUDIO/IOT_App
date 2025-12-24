/// Mobile Header - Header with unit tabs for mobile layout
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../domain/entities/unit_state.dart';
import '../../../widgets/common/hover_builder.dart';
import 'header_icon_button.dart';
import 'add_unit_button.dart';

/// Mobile header with unit tabs and controls
class MobileHeader extends StatelessWidget {
  final List<UnitState> units;
  final int selectedUnitIndex;
  final ValueChanged<int>? onUnitSelected;
  final VoidCallback? onAddUnit;
  final bool isDark;
  final VoidCallback? onThemeToggle;

  const MobileHeader({
    super.key,
    required this.units,
    required this.selectedUnitIndex,
    this.onUnitSelected,
    this.onAddUnit,
    required this.isDark,
    this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.sm),
      child: Column(
        children: [
          // Top row: Logo + controls
          Row(
            children: [
              // Logo
              const _Logo(),
              const Spacer(),
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
            ],
          ),

          SizedBox(height: AppSpacing.sm),

          // Unit tabs row
          _buildUnitTabs(),
        ],
      ),
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
}

/// BREEZ logo
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BREEZ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: Colors.white,
          ),
        ),
        Text(
          'SMART SYSTEMS',
          style: TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: AppColors.darkTextMuted,
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
