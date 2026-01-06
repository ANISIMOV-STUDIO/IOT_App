/// Unit Tab Button - Unified tab button for unit selection with accessibility
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../domain/entities/unit_state.dart';
import 'breez_button.dart';

/// Unified unit tab button used across all layouts (mobile, tablet, desktop)
class UnitTabButton extends StatelessWidget {
  final UnitState unit;
  final bool isSelected;
  final VoidCallback? onTap;

  /// Semantic label for screen readers (defaults to unit name + status)
  final String? semanticLabel;

  const UnitTabButton({
    super.key,
    required this.unit,
    required this.isSelected,
    this.onTap,
    this.semanticLabel,
  });

  /// Create from unit data with name and power status
  factory UnitTabButton.fromData({
    Key? key,
    required String name,
    required bool power,
    required bool isSelected,
    VoidCallback? onTap,
    String? semanticLabel,
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
      semanticLabel: semanticLabel,
    );
  }

  String _buildSemanticLabel() {
    final status = unit.power ? 'включен' : 'выключен';
    final selected = isSelected ? ', выбран' : '';
    return '${unit.name}, $status$selected';
  }

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);

    return BreezButton(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: AppRadius.nested,
      backgroundColor: isSelected ? AppColors.accent : Colors.transparent,
      hoverColor: isSelected ? AppColors.accentLight : colors.buttonBg,
      showBorder: false,
      enableGlow: isSelected,
      semanticLabel: semanticLabel ?? _buildSemanticLabel(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status indicator with semantic meaning
          Semantics(
            label: unit.power ? 'Работает' : 'Выключен',
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: unit.power
                    ? (isSelected ? Colors.white : AppColors.success)
                    : colors.textMuted,
                shape: BoxShape.circle,
              ),
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
    return Semantics(
      label: 'Список устройств',
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.cardSmall),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
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
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
