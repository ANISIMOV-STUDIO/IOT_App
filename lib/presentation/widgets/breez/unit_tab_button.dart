/// Unit Tab Button - Unified tab button for unit selection
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../domain/entities/unit_state.dart';

/// Unified unit tab button used across all layouts (mobile, tablet, desktop)
class UnitTabButton extends StatelessWidget {
  final UnitState unit;
  final bool isSelected;
  final VoidCallback? onTap;

  const UnitTabButton({
    super.key,
    required this.unit,
    required this.isSelected,
    this.onTap,
  });

  /// Create from unit data with name and power status
  factory UnitTabButton.fromData({
    Key? key,
    required String name,
    required bool power,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return UnitTabButton(
      key: key,
      unit: UnitState(
        id: '',
        name: name,
        power: power,
        temp: 0,
        humidity: 0,
        mode: '',
        supplyFan: 0,
        exhaustFan: 0,
        outsideTemp: 0,
        filterPercent: 100,
        airflowRate: 0,
      ),
      isSelected: isSelected,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.nested),
        hoverColor: isSelected ? AppColors.accentLight : colors.buttonBg,
        splashColor: AppColors.accent.withValues(alpha: 0.2),
        highlightColor: AppColors.accent.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.nested),
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
                      : colors.textMuted,
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
                  color: isSelected ? Colors.white : colors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Unit tabs container - wraps unit tab buttons in a styled container
class UnitTabsContainer extends StatelessWidget {
  final List<UnitState> units;
  final int selectedIndex;
  final ValueChanged<int>? onUnitSelected;
  final Widget? leading;
  final Widget? trailing;

  const UnitTabsContainer({
    super.key,
    required this.units,
    required this.selectedIndex,
    this.onUnitSelected,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.cardSmall),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          // Leading widget (e.g., logo)
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          // Unit tabs list
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: units.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final unit = units[index];
                final isSelected = index == selectedIndex;
                return UnitTabButton(
                  unit: unit,
                  isSelected: isSelected,
                  onTap: () => onUnitSelected?.call(index),
                );
              },
            ),
          ),
          // Trailing widget (e.g., add button)
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
