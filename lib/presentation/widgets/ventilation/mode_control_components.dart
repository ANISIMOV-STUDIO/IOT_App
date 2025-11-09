/// Ventilation Mode Control Components
///
/// Component widgets for ventilation mode control
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
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
    final isMobile = ResponsiveUtils.isMobile(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [HvacColors.blue400, HvacColors.primaryDark],
                  ),
                  borderRadius: HvacRadius.smRadius,
                ),
                child: Icon(
                  Icons.air,
                  color: Colors.white,
                  size: isMobile ? 20.0 : 24.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Режим вентиляции',
                      style: HvacTypography.bodyMedium.copyWith(
                        color: HvacColors.textSecondary,
                        fontSize: isMobile ? 12.0 : 13.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      mode.isEmpty ? 'Не выбран' : mode,
                      style: HvacTypography.titleLarge.copyWith(
                        fontSize: isMobile ? 16.0 : 18.0,
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
            color: HvacColors.primaryOrange,
          ),
        ),
      ],
    );
  }
}

/// Mode Selector
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
    final isMobile = ResponsiveUtils.isMobile(context);

    return Wrap(
      spacing: isMobile ? 8.0 : 12.0,
      runSpacing: isMobile ? 8.0 : 12.0,
      children: VentilationMode.values.map((mode) => _ModeChip(
        mode: mode,
        isSelected: mode == currentMode,
        onTap: () => onModeChanged?.call(mode),
      )).toList(),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final VentilationMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: HvacRadius.smRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected
              ? HvacColors.primaryOrange.withValues(alpha: 0.1)
              : HvacColors.backgroundDark,
          borderRadius: HvacRadius.smRadius,
          border: Border.all(
            color: isSelected
                ? HvacColors.primaryOrange
                : HvacColors.backgroundCardBorder,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Text(
          _getModeName(mode),
          style: HvacTypography.bodyMedium.copyWith(
            color: isSelected ? HvacColors.primaryOrange : HvacColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _getModeName(VentilationMode mode) {
    switch (mode) {
      case VentilationMode.basic:
        return 'Базовый';
      case VentilationMode.intensive:
        return 'Интенсивный';
      case VentilationMode.economic:
        return 'Экономичный';
      case VentilationMode.maximum:
        return 'Максимальный';
      case VentilationMode.kitchen:
        return 'Кухня';
      case VentilationMode.fireplace:
        return 'Камин';
      case VentilationMode.vacation:
        return 'Отпуск';
      case VentilationMode.custom:
        return 'Пользовательский';
    }
  }
}

/// Fan Speed Controls
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
    return Column(
      children: [
        _FanSpeedSlider(
          label: 'Приток',
          icon: Icons.download,
          value: supplyFanSpeed,
          onChanged: onSupplyFanChanged,
        ),
        const SizedBox(height: 16.0),
        _FanSpeedSlider(
          label: 'Вытяжка',
          icon: Icons.upload,
          value: exhaustFanSpeed,
          onChanged: onExhaustFanChanged,
        ),
      ],
    );
  }
}

class _FanSpeedSlider extends StatelessWidget {
  final String label;
  final IconData icon;
  final int value;
  final ValueChanged<int>? onChanged;

  const _FanSpeedSlider({
    required this.label,
    required this.icon,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 18.0, color: HvacColors.textSecondary),
                const SizedBox(width: 8.0),
                Text(
                  label,
                  style: HvacTypography.bodyMedium.copyWith(
                    color: HvacColors.textSecondary,
                  ),
                ),
              ],
            ),
            Text(
              '$value%',
              style: HvacTypography.titleMedium.copyWith(
                color: HvacColors.primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        HvacSlider(
          value: value.toDouble(),
          min: 0,
          max: 100,
          divisions: 10,
          label: '$value%',
          onChanged: onChanged != null ? (val) => onChanged!(val.toInt()) : null,
        ),
      ],
    );
  }
}
