/// Home Device Selector Widget
///
/// Device selection tabs with add button
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';

class HomeDeviceSelector extends StatelessWidget {
  final List<HvacUnit> units;
  final String? selectedUnit;
  final ValueChanged<String> onUnitSelected;
  final VoidCallback? onAddPressed;

  const HomeDeviceSelector({
    super.key,
    required this.units,
    this.selectedUnit,
    required this.onUnitSelected,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...units.map((unit) {
          final label = unit.name;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: _buildUnitTab(
              label,
              selectedUnit == label,
              unit.power,
            ),
          );
        }),
        // Add new unit button
        if (onAddPressed != null) _buildAddButton(),
      ],
    );
  }

  Widget _buildUnitTab(String label, bool isSelected, bool isOnline) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onUnitSelected(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? HvacColors.backgroundCard : Colors.transparent,
            borderRadius: HvacRadius.smRadius,
            border: Border.all(
              color: isSelected
                  ? HvacColors.backgroundCardBorder
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status indicator
              Container(
                width: 6.0,
                height: 6.0,
                decoration: BoxDecoration(
                  color:
                      isOnline ? HvacColors.success : HvacColors.textTertiary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  color: isSelected
                      ? HvacColors.textPrimary
                      : HvacColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onAddPressed,
        child: Container(
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            color: HvacColors.backgroundCard,
            shape: BoxShape.circle,
            border: Border.all(
              color: HvacColors.backgroundCardBorder,
            ),
          ),
          child: const Icon(
            Icons.add,
            size: 20.0,
            color: HvacColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
