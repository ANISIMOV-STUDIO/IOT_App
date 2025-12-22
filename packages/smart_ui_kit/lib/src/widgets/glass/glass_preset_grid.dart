import 'package:flutter/material.dart';
import '../../theme/glass_colors.dart';
import '../../theme/glass_theme.dart';

/// Preset item data
class PresetItem {
  final String id;
  final String label;
  final IconData icon;
  final Color? activeColor;

  const PresetItem({
    required this.id,
    required this.label,
    required this.icon,
    this.activeColor,
  });
}

/// Glass Preset Grid - clean mode buttons
class GlassPresetGrid extends StatelessWidget {
  final List<PresetItem> presets;
  final String? selectedId;
  final ValueChanged<String>? onSelected;
  final double itemSize;

  const GlassPresetGrid({
    super.key,
    required this.presets,
    this.selectedId,
    this.onSelected,
    this.itemSize = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: presets.map((preset) {
        final isSelected = preset.id == selectedId;
        return _PresetButton(
          preset: preset,
          isSelected: isSelected,
          size: itemSize,
          onTap: () => onSelected?.call(preset.id),
        );
      }).toList(),
    );
  }
}

typedef NeumorphicPresetGrid = GlassPresetGrid;

class _PresetButton extends StatefulWidget {
  final PresetItem preset;
  final bool isSelected;
  final double size;
  final VoidCallback? onTap;

  const _PresetButton({
    required this.preset,
    required this.isSelected,
    required this.size,
    this.onTap,
  });

  @override
  State<_PresetButton> createState() => _PresetButtonState();
}

class _PresetButtonState extends State<_PresetButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final color = widget.preset.activeColor ?? GlassColors.accentPrimary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? color.withValues(alpha: 0.15)
                : _isHovered
                    ? theme.colors.textTertiary.withValues(alpha: 0.08)
                    : theme.colors.cardSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isSelected
                  ? color.withValues(alpha: 0.4)
                  : theme.isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
              width: widget.isSelected ? 1.5 : 0.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.preset.icon,
                size: 24,
                color: widget.isSelected ? color : theme.colors.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                widget.preset.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: widget.isSelected ? color : theme.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
