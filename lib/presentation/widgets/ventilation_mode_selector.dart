/// Ventilation Mode Selector Widget
///
/// Dropdown for selecting ventilation operating mode
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../domain/entities/ventilation_mode.dart';

class VentilationModeSelector extends StatelessWidget {
  final VentilationMode? currentMode;
  final ValueChanged<VentilationMode?> onModeChanged;
  final bool enabled;

  const VentilationModeSelector({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: HvacSpacing.md, vertical: HvacSpacing.xxs),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.smRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<VentilationMode>(
          value: currentMode,
          isExpanded: true,
          dropdownColor: HvacColors.backgroundCard,
          style: const TextStyle(
            fontSize: 14,
            color: HvacColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: HvacColors.textSecondary,
          ),
          onChanged: enabled ? onModeChanged : null,
          items: VentilationMode.values.map((mode) {
            return DropdownMenuItem<VentilationMode>(
              value: mode,
              child: Text(mode.displayName),
            );
          }).toList(),
        ),
      ),
    );
  }
}
