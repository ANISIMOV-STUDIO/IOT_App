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
            padding: EdgeInsets.only(right: 12.w),
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? HvacColors.backgroundCard : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
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
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isOnline ? HvacColors.success : HvacColors.textTertiary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
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
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: HvacColors.backgroundCard,
            shape: BoxShape.circle,
            border: Border.all(
              color: HvacColors.backgroundCardBorder,
            ),
          ),
          child: Icon(
            Icons.add,
            size: 20.sp,
            color: HvacColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
