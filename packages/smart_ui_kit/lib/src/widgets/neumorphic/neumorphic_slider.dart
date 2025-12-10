import 'package:flutter/material.dart';
import '../../theme/neumorphic_theme.dart';
import '../../theme/tokens/neumorphic_colors.dart';

/// Neumorphic Slider - optimized using Flutter's native Slider with custom theme
class NeumorphicSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;
  final Color? activeColor;
  final String? label;
  final String? suffix;
  final bool showValue;

  const NeumorphicSlider({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.onChanged,
    this.onChangeEnd,
    this.activeColor,
    this.label,
    this.suffix,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final color = activeColor ?? NeumorphicColors.accentPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label and value row
        if (label != null || showValue)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(label!, style: theme.typography.titleMedium),
                if (showValue)
                  Text(
                    '${value.round()}${suffix ?? ''}',
                    style: theme.typography.numericMedium,
                  ),
              ],
            ),
          ),

        // Slider with neumorphic track
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: theme.colors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: theme.shadows.concaveSmall,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 24,
              activeTrackColor: color.withValues(alpha: 0.3),
              inactiveTrackColor: Colors.transparent,
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.1),
              thumbShape: _NeumorphicThumbShape(color: color),
              trackShape: const RoundedRectSliderTrackShape(),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
              onChangeEnd: onChangeEnd,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom thumb shape for neumorphic slider
class _NeumorphicThumbShape extends SliderComponentShape {
  final Color color;
  
  const _NeumorphicThumbShape({required this.color});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(24, 24);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    
    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center + const Offset(0, 2), 11, shadowPaint);
    
    // Thumb
    final paint = Paint()..color = color;
    canvas.drawCircle(center, 12, paint);
    
    // Highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, 10, highlightPaint);
  }
}

/// Preset buttons for slider (e.g., Auto, 30%, 60%)
class NeumorphicSliderPresets extends StatelessWidget {
  final List<SliderPreset> presets;
  final double currentValue;
  final ValueChanged<double>? onPresetSelected;

  const NeumorphicSliderPresets({
    super.key,
    required this.presets,
    required this.currentValue,
    this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);

    return Row(
      children: presets.map((preset) {
        final isSelected = (currentValue - preset.value).abs() < 1;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () => onPresetSelected?.call(preset.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colors.cardSurface : theme.colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected ? theme.shadows.convexSmall : theme.shadows.flat,
                  border: isSelected
                      ? Border.all(color: NeumorphicColors.accentPrimary.withValues(alpha: 0.3))
                      : null,
                ),
                child: Center(
                  child: Text(
                    preset.label,
                    style: theme.typography.labelMedium.copyWith(
                      color: isSelected ? theme.colors.textPrimary : theme.colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class SliderPreset {
  final String label;
  final double value;
  const SliderPreset({required this.label, required this.value});
}
