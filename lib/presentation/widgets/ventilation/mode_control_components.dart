/// Ventilation Mode Control Components
///
/// Component widgets for ventilation mode control
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../domain/entities/ventilation_mode.dart';

/// Mode Control Header
class ModeControlHeader extends StatelessWidget {
  final String mode;
  final VoidCallback onModeToggle;
  final bool showModeSelector;

  const ModeControlHeader({
    super.key,
    required this.mode,
    required this.onModeToggle,
    required this.showModeSelector,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = ResponsiveUtils.isMobile(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(HvacSpacing.xs),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [HvacColors.blue400, HvacColors.primaryDark],
                  ),
                  borderRadius: HvacRadius.smRadius,
                ),
                child: Icon(
                  Icons.air,
                  color: HvacColors.textLight,
                  size: isMobile ? 20.0 : 24.0,
                ),
              ),
              const SizedBox(width: HvacSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.ventilationMode,
                      style: HvacTypography.labelMedium.copyWith(
                        color: HvacColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: HvacSpacing.xxs),
                    Text(
                      mode.isEmpty ? l10n.notSelected : _getModeLabelFromString(mode, l10n),
                      style: HvacTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onModeToggle,
          icon: Icon(
            showModeSelector ? Icons.expand_less : Icons.expand_more,
            color: HvacColors.primary,
          ),
        ),
      ],
    );
  }
}

/// Mode Selector using HvacChip
class ModeSelector extends StatelessWidget {
  final VentilationMode currentMode;
  final ValueChanged<VentilationMode>? onModeChanged;

  const ModeSelector({
    super.key,
    required this.currentMode,
    this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = ResponsiveUtils.isMobile(context);

    return Wrap(
      spacing: isMobile ? HvacSpacing.xs : HvacSpacing.sm,
      runSpacing: isMobile ? HvacSpacing.xs : HvacSpacing.sm,
      children: VentilationMode.values.map((mode) {
        return HvacChip(
          label: _getModeName(mode, l10n),
          selected: mode == currentMode,
          onTap: () => onModeChanged?.call(mode),
          selectedColor: HvacColors.primary,
        );
      }).toList(),
    );
  }

  String _getModeName(VentilationMode mode, AppLocalizations l10n) {
    switch (mode) {
      case VentilationMode.basic:
        return l10n.modeBasic;
      case VentilationMode.intensive:
        return l10n.modeIntensive;
      case VentilationMode.economic:
        return l10n.modeEconomic;
      case VentilationMode.maximum:
        return l10n.modeMaximum;
      case VentilationMode.kitchen:
        return l10n.modeKitchen;
      case VentilationMode.fireplace:
        return l10n.modeFireplace;
      case VentilationMode.vacation:
        return l10n.modeVacation;
      case VentilationMode.custom:
        return l10n.modeCustom;
    }
  }
}

/// Fan Speed Controls using HvacLabeledSlider
class FanSpeedControls extends StatelessWidget {
  final int supplyFanSpeed;
  final int exhaustFanSpeed;
  final ValueChanged<int>? onSupplyFanChanged;
  final ValueChanged<int>? onExhaustFanChanged;

  const FanSpeedControls({
    super.key,
    required this.supplyFanSpeed,
    required this.exhaustFanSpeed,
    this.onSupplyFanChanged,
    this.onExhaustFanChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        HvacLabeledSlider(
          label: l10n.supplyAir,
          icon: Icons.download,
          value: supplyFanSpeed.toDouble(),
          min: 0,
          max: 100,
          suffix: '%',
          divisions: 10,
          activeColor: HvacColors.primary,
          onChanged: onSupplyFanChanged != null
              ? (val) => onSupplyFanChanged!(val.toInt())
              : null,
        ),
        const SizedBox(height: HvacSpacing.md),
        HvacLabeledSlider(
          label: l10n.exhaustAir,
          icon: Icons.upload,
          value: exhaustFanSpeed.toDouble(),
          min: 0,
          max: 100,
          suffix: '%',
          divisions: 10,
          activeColor: HvacColors.primary,
          onChanged: onExhaustFanChanged != null
              ? (val) => onExhaustFanChanged!(val.toInt())
              : null,
        ),
      ],
    );
  }
}

/// Helper function to convert string mode to localized label
String _getModeLabelFromString(String mode, AppLocalizations l10n) {
  switch (mode.toLowerCase()) {
    case 'basic':
      return l10n.modeBasic;
    case 'intensive':
      return l10n.modeIntensive;
    case 'economic':
      return l10n.modeEconomic;
    case 'maximum':
      return l10n.modeMaximum;
    case 'kitchen':
      return l10n.modeKitchen;
    case 'fireplace':
      return l10n.modeFireplace;
    case 'vacation':
      return l10n.modeVacation;
    case 'custom':
      return l10n.modeCustom;
    case 'auto':
      return l10n.modeBasic; // Auto maps to Basic
    default:
      return mode; // Fallback to original if not recognized
  }
}