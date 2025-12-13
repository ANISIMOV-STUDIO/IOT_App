import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart' as np;
import '../../theme/tokens/neumorphic_colors.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

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

/// Neumorphic Preset Grid - 2×3 grid of icon buttons
class NeumorphicPresetGrid extends StatelessWidget {
  final List<PresetItem> presets;
  final String? selectedId;
  final ValueChanged<String>? onSelected;
  final int crossAxisCount;
  final double spacing;
  final double buttonSize;

  const NeumorphicPresetGrid({
    super.key,
    required this.presets,
    this.selectedId,
    this.onSelected,
    this.crossAxisCount = 3,
    this.spacing = 12,
    this.buttonSize = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: presets.map((preset) {
        final isSelected = preset.id == selectedId;
        return _PresetButton(
          preset: preset,
          isSelected: isSelected,
          size: buttonSize,
          onTap: () => onSelected?.call(preset.id),
        );
      }).toList(),
    );
  }
}

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
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.preset.activeColor ?? NeumorphicColors.accentPrimary;

    // Depth: selected = concave (-3), pressed = slight concave (-1), default = convex (3)
    final depth = widget.isSelected ? -3.0 : (_isPressed ? -1.0 : 3.0);

    return Tooltip(
      message: widget.preset.label,
      preferBelow: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap?.call();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: np.Neumorphic(
              duration: Duration.zero, // No animation - instant state change
              style: np.NeumorphicStyle(
                depth: depth,
                intensity: 0.6,
                surfaceIntensity: widget.isSelected ? 0.15 : 0.1,
                boxShape: np.NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(NeumorphicSpacing.radiusMd),
                ),
              ),
              child: Center(
                child: Icon(
                  widget.preset.icon,
                  size: 24,
                  color: widget.isSelected ? color : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
