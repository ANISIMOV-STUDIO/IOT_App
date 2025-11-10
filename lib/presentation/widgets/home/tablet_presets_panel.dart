/// Tablet Presets Panel
///
/// Mode preset selector for tablet home layout with consistent HVAC UI Kit styling
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/mode_preset.dart';
import '../../../domain/entities/ventilation_mode.dart';
import '../../../generated/l10n/app_localizations.dart';

class TabletPresetsPanel extends StatelessWidget {
  final Function(ModePreset) onPresetSelected;

  const TabletPresetsPanel({
    super.key,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final presets = [
      ModePreset.defaults[VentilationMode.economic]!,
      ModePreset.defaults[VentilationMode.basic]!,
      ModePreset.defaults[VentilationMode.maximum]!,
      ModePreset.defaults[VentilationMode.vacation]!,
    ];

    return HvacCard(
      padding: const EdgeInsets.all(HvacSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.presets,
            style: HvacTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: HvacSpacing.md),
          ...presets.map((preset) => Padding(
                padding: const EdgeInsets.only(bottom: HvacSpacing.sm),
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
            horizontal: HvacSpacing.md,
            vertical: HvacSpacing.sm,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: HvacColors.backgroundCardBorder,
              width: 1.0,
            ),
            borderRadius: HvacRadius.mdRadius,
          ),
          child: Row(
            children: [
              Icon(
                _getPresetIcon(preset),
                size: 20.0,
                color: _getPresetColor(preset),
              ),
              const SizedBox(width: HvacSpacing.sm),
              Expanded(
                child: Text(
                  preset.mode.displayName,
                  style: HvacTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: HvacColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20.0,
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
        return HvacColors.primary;
      case VentilationMode.maximum:
        return HvacColors.error;
      case VentilationMode.vacation:
        return HvacColors.info;
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