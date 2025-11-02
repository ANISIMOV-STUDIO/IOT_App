/// Quick Presets Panel Widget
///
/// Quick access buttons for common ventilation presets
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Быстрые режимы',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Применить настройки одной кнопкой',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

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
                AppTheme.info,
              ),
              _buildPresetButton(
                context,
                'Макс. вентиляция',
                Icons.air,
                ModePreset.defaults[VentilationMode.maximum]!,
                AppTheme.error,
              ),
              _buildPresetButton(
                context,
                'Эко-режим',
                Icons.eco,
                ModePreset.defaults[VentilationMode.economic]!,
                AppTheme.success,
              ),
              _buildPresetButton(
                context,
                'Стандартный',
                Icons.home,
                ModePreset.defaults[VentilationMode.basic]!,
                AppTheme.primaryOrange,
              ),
              _buildPresetButton(
                context,
                'Кухня',
                Icons.restaurant,
                ModePreset.defaults[VentilationMode.kitchen]!,
                const Color(0xFFFFA726),
              ),
              _buildPresetButton(
                context,
                'Камин',
                Icons.fireplace,
                ModePreset.defaults[VentilationMode.fireplace]!,
                const Color(0xFFFF7043),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.color.withValues(alpha: 0.15)
                : AppTheme.backgroundDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered
                  ? widget.color.withValues(alpha: 0.5)
                  : AppTheme.backgroundCardBorder,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: widget.color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _isHovered ? widget.color : AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '${widget.preset.supplyFanSpeed}% / ${widget.preset.exhaustFanSpeed}%',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textSecondary,
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
