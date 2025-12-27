/// Presets Widget - Quick access to HVAC presets
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_radius.dart';
import '../../../domain/entities/preset_data.dart';
import 'breez_card.dart';

export '../../../domain/entities/preset_data.dart';

/// Presets widget - icon-only horizontal layout
class PresetsWidget extends StatelessWidget {
  final List<PresetData> presets;
  final String? activePresetId;
  final ValueChanged<String>? onPresetSelected;

  const PresetsWidget({
    super.key,
    required this.presets,
    this.activePresetId,
    this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return BreezCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Пресеты',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colors.text,
                ),
              ),
              if (activePresetId != null)
                Text(
                  presets.firstWhere((p) => p.id == activePresetId, orElse: () => presets.first).name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentGreen,
                  ),
                ),
            ],
          ),

          const Spacer(),

          // Presets as icon row (flexible to fit any width)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: presets.map((preset) {
              final isActive = preset.id == activePresetId;
              return Flexible(
                child: _IconPreset(
                  preset: preset,
                  isActive: isActive,
                  onTap: () => onPresetSelected?.call(preset.id),
                ),
              );
            }).toList(),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}

/// Icon-only preset button
class _IconPreset extends StatefulWidget {
  final PresetData preset;
  final bool isActive;
  final VoidCallback? onTap;

  const _IconPreset({
    required this.preset,
    this.isActive = false,
    this.onTap,
  });

  @override
  State<_IconPreset> createState() => _IconPresetState();
}

class _IconPresetState extends State<_IconPreset> {
  bool _isHovered = false;

  Color get _color => widget.preset.color ?? AppColors.accent;

  @override
  Widget build(BuildContext context) {
    final colors = BreezColors.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Tooltip(
          message: widget.preset.name,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: widget.isActive
                  ? _color.withValues(alpha: 0.2)
                  : _isHovered
                      ? colors.buttonBg
                      : colors.buttonBg.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(
                color: widget.isActive
                    ? _color.withValues(alpha: 0.6)
                    : _isHovered
                        ? colors.border
                        : Colors.transparent,
                width: widget.isActive ? 2 : 1,
              ),
              boxShadow: widget.isActive
                  ? [
                      BoxShadow(
                        color: _color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              widget.preset.icon,
              size: 20,
              color: widget.isActive
                  ? _color
                  : _isHovered
                      ? colors.text
                      : colors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
