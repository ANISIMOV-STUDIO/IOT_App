/// Quick Presets Panel Widget
///
/// Quick access buttons for common ventilation presets
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../domain/entities/mode_preset.dart';
import '../../domain/entities/ventilation_mode.dart';

class QuickPresetsPanel extends StatelessWidget {
  final ValueChanged<ModePreset>? onPresetSelected;

  const QuickPresetsPanel({
    super.key,
    this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      // GLASSMORPHISM: Frosted glass with blur
      padding: const EdgeInsets.all(HvacSpacing.lgR),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(HvacSpacing.smR),
                decoration: BoxDecoration(
                  color: HvacColors.primaryOrange.withValues(alpha: 0.2),
                  borderRadius: HvacRadius.smRadius,
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: HvacColors.primaryOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Быстрые режимы',
                      style: HvacTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'Применить настройки одной кнопкой',
                      style: HvacTypography.bodySmall.copyWith(
                        color: HvacColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // Quick preset buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPresetButton(
                context,
                'Спящий режим',
                Icons.nightlight_round,
                ModePreset.defaults[VentilationMode.economic]!,
                HvacColors.neutral200, // Gray instead of blue
              ),
              _buildPresetButton(
                context,
                'Макс. вентиляция',
                Icons.air,
                ModePreset.defaults[VentilationMode.maximum]!,
                HvacColors.error,
              ),
              _buildPresetButton(
                context,
                'Эко-режим',
                Icons.eco,
                ModePreset.defaults[VentilationMode.economic]!,
                HvacColors.success,
              ),
              _buildPresetButton(
                context,
                'Стандартный',
                Icons.home,
                ModePreset.defaults[VentilationMode.basic]!,
                HvacColors.primaryOrange,
              ),
              _buildPresetButton(
                context,
                'Кухня',
                Icons.restaurant,
                ModePreset.defaults[VentilationMode.kitchen]!,
                HvacColors.warning,
              ),
              _buildPresetButton(
                context,
                'Камин',
                Icons.fireplace,
                ModePreset.defaults[VentilationMode.fireplace]!,
                HvacColors.primaryOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(
    BuildContext context,
    String label,
    IconData icon,
    ModePreset preset,
    Color color,
  ) {
    return _PresetButton(
      label: label,
      icon: icon,
      preset: preset,
      color: color,
      onTap: () {
        if (onPresetSelected != null) {
          onPresetSelected!(preset);
        }
      },
    );
  }
}

/// Preset Button with Hover Effect
class _PresetButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final ModePreset preset;
  final Color color;
  final VoidCallback onTap;

  const _PresetButton({
    required this.label,
    required this.icon,
    required this.preset,
    required this.color,
    required this.onTap,
  });

  @override
  State<_PresetButton> createState() => _PresetButtonState();
}

class _PresetButtonState extends State<_PresetButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // MONOCHROMATIC: Only icons are colored, buttons and text stay neutral
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
              horizontal: HvacSpacing.sm, vertical: HvacSpacing.sm),
          decoration: BoxDecoration(
            // Background: subtle lift on hover, but stay monochrome
            color: _isHovered
                ? HvacColors.backgroundElevated // Subtle gray lift
                : HvacColors.backgroundCard,
            borderRadius: HvacRadius.smRadius,
            border: Border.all(
              // Border: always gray, never colored
              color: _isHovered
                  ? HvacColors.accent
                      .withValues(alpha: 0.3) // Subtle gold hint on hover
                  : HvacColors.backgroundCardBorder,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ONLY icons are colored
              Icon(
                widget.icon,
                color: widget.color, // Keep icon colored
                size: 18,
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text: ALWAYS white, never colored
                  Text(
                    widget.label,
                    style: HvacTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: HvacColors.textPrimary, // Always white
                    ),
                  ),
                  Text(
                    '${widget.preset.supplyFanSpeed}% / ${widget.preset.exhaustFanSpeed}%',
                    style: HvacTypography.caption.copyWith(
                      color: HvacColors.textSecondary, // Always gray
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
