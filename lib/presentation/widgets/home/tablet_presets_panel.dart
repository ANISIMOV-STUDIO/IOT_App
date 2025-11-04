/// Tablet Presets Panel
///
/// Mode preset selector for tablet home layout
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/mode_preset.dart';
import '../../../domain/entities/ventilation_mode.dart';

class TabletPresetsPanel extends StatelessWidget {
  final Function(ModePreset) onPresetSelected;

  const TabletPresetsPanel({
    super.key,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final presets = [
      ModePreset.defaults[VentilationMode.economic]!,
      ModePreset.defaults[VentilationMode.basic]!,
      ModePreset.defaults[VentilationMode.maximum]!,
      ModePreset.defaults[VentilationMode.vacation]!,
    ];

    return Container(
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.lgRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1.w,
        ),
      ),
      padding: const EdgeInsets.all(HvacSpacing.lgR),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Presets',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: HvacSpacing.mdV),
          ...presets.map((preset) => Padding(
            padding: const EdgeInsets.only(bottom: HvacSpacing.smV),
            child: _buildPresetButton(preset),
          )),
        ],
      ),
    );
  }

  Widget _buildPresetButton(ModePreset preset) {
    return Material(
      color: HvacColors.backgroundCard,
      borderRadius: HvacRadius.mdRadius,
      child: InkWell(
        onTap: () => onPresetSelected(preset),
        borderRadius: HvacRadius.mdRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.mdR,
            vertical: HvacSpacing.smV,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: HvacColors.backgroundCardBorder,
              width: 1.w,
            ),
            borderRadius: HvacRadius.mdRadius,
          ),
          child: Row(
            children: [
              Icon(
                _getPresetIcon(preset),
                size: 20.sp,
                color: _getPresetColor(preset),
              ),
              const SizedBox(width: HvacSpacing.smR),
              Expanded(
                child: Text(
                  preset.mode.displayName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: HvacColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20.sp,
                color: HvacColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPresetIcon(ModePreset preset) {
    switch (preset.mode) {
      case VentilationMode.economic:
        return Icons.eco;
      case VentilationMode.basic:
        return Icons.weekend;
      case VentilationMode.maximum:
        return Icons.flash_on;
      case VentilationMode.vacation:
        return Icons.nights_stay;
      case VentilationMode.intensive:
        return Icons.speed;
      case VentilationMode.kitchen:
        return Icons.kitchen;
      case VentilationMode.fireplace:
        return Icons.fireplace;
      default:
        return Icons.settings;
    }
  }

  Color _getPresetColor(ModePreset preset) {
    switch (preset.mode) {
      case VentilationMode.economic:
        return HvacColors.success;
      case VentilationMode.basic:
        return HvacColors.primaryOrange;
      case VentilationMode.maximum:
        return HvacColors.error;
      case VentilationMode.vacation:
        return HvacColors.primaryBlue;
      case VentilationMode.intensive:
        return HvacColors.warning;
      case VentilationMode.kitchen:
        return HvacColors.modeFan;
      case VentilationMode.fireplace:
        return HvacColors.modeHeat;
      default:
        return HvacColors.textSecondary;
    }
  }
}