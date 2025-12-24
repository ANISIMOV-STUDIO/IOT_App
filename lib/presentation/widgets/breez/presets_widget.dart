/// Presets Widget - Quick access to HVAC presets
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';

/// Preset data
class PresetData {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int temperature;
  final int airflow;
  final Color? color;

  const PresetData({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.temperature,
    required this.airflow,
    this.color,
  });
}

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
    return BreezCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Пресеты',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (activePresetId != null)
                Text(
                  presets.firstWhere((p) => p.id == activePresetId, orElse: () => presets.first).name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentGreen,
                  ),
                ),
            ],
          ),

          const Spacer(),

          // Presets as icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: presets.map((preset) {
              final isActive = preset.id == activePresetId;
              return _IconPreset(
                preset: preset,
                isActive: isActive,
                onTap: () => onPresetSelected?.call(preset.id),
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
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isActive
                    ? _color.withValues(alpha: 0.6)
                    : _isHovered
                        ? AppColors.darkBorder
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
                      ? Colors.white
                      : AppColors.darkTextMuted,
            ),
          ),
        ),
      ),
    );
  }
}

/// Default presets list
class DefaultPresets {
  static const List<PresetData> all = [
    PresetData(
      id: 'comfort',
      name: 'Комфорт',
      description: 'Оптимальный режим',
      icon: Icons.spa_outlined,
      temperature: 22,
      airflow: 60,
      color: Color(0xFF2D7DFF),
    ),
    PresetData(
      id: 'eco',
      name: 'Эко',
      description: 'Энергосбережение',
      icon: Icons.eco_outlined,
      temperature: 20,
      airflow: 40,
      color: Color(0xFF22C55E),
    ),
    PresetData(
      id: 'night',
      name: 'Ночь',
      description: 'Тихий режим',
      icon: Icons.nightlight_outlined,
      temperature: 19,
      airflow: 30,
      color: Color(0xFF8B5CF6),
    ),
    PresetData(
      id: 'turbo',
      name: 'Турбо',
      description: 'Максимальная мощность',
      icon: Icons.bolt_outlined,
      temperature: 18,
      airflow: 100,
      color: Color(0xFFF97316),
    ),
    PresetData(
      id: 'away',
      name: 'Нет дома',
      description: 'Минимальный режим',
      icon: Icons.home_outlined,
      temperature: 16,
      airflow: 20,
      color: Color(0xFF64748B),
    ),
    PresetData(
      id: 'sleep',
      name: 'Сон',
      description: 'Комфортный сон',
      icon: Icons.bedtime_outlined,
      temperature: 20,
      airflow: 25,
      color: Color(0xFF6366F1),
    ),
  ];
}
