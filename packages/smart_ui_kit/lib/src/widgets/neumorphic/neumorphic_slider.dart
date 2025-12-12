import 'package:flutter/material.dart';
import 'neumorphic_theme_wrapper.dart';
import '../../theme/tokens/neumorphic_colors.dart';

/// Neumorphic Slider - optimized with local state for smooth dragging
class NeumorphicSlider extends StatefulWidget {
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
  State<NeumorphicSlider> createState() => _NeumorphicSliderState();
}

class _NeumorphicSliderState extends State<NeumorphicSlider> {
  late double _localValue;

  @override
  void initState() {
    super.initState();
    _localValue = widget.value;
  }

  @override
  void didUpdateWidget(NeumorphicSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync with external value only when not dragging
    if (widget.value != oldWidget.value) {
      _localValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final color = widget.activeColor ?? NeumorphicColors.accentPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label and value row
        if (widget.label != null || widget.showValue)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  Text(widget.label!, style: theme.typography.bodyMedium),
                if (widget.showValue)
                  Text(
                    '${_localValue.round()}${widget.suffix ?? ''}',
                    style: theme.typography.numericMedium,
                  ),
              ],
            ),
          ),

        // Slider with neumorphic track
        Container(
          height: 28,
          decoration: BoxDecoration(
            color: theme.colors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: theme.shadows.concaveSmall,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 20,
              activeTrackColor: color.withValues(alpha: 0.3),
              inactiveTrackColor: Colors.transparent,
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.1),
              thumbShape: _NeumorphicThumbShape(color: color),
              trackShape: const RoundedRectSliderTrackShape(),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: _localValue.clamp(widget.min, widget.max),
              min: widget.min,
              max: widget.max,
              onChanged: (v) {
                setState(() => _localValue = v);
                widget.onChanged?.call(v);
              },
              onChangeEnd: widget.onChangeEnd,
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
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(20, 20);

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
      ..color = Colors.black.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(center + const Offset(0, 1), 9, shadowPaint);
    
    // Thumb
    final paint = Paint()..color = color;
    canvas.drawCircle(center, 10, paint);
    
    // Highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, 8, highlightPaint);
  }
}

/// Preset buttons for slider
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
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GestureDetector(
              onTap: () => onPresetSelected?.call(preset.value),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colors.cardSurface : theme.colors.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected ? theme.shadows.convexSmall : null,
                  border: isSelected
                      ? Border.all(color: NeumorphicColors.accentPrimary.withValues(alpha: 0.3))
                      : null,
                ),
                child: Center(
                  child: Text(
                    preset.label,
                    style: theme.typography.labelSmall.copyWith(
                      color: isSelected ? theme.colors.textPrimary : theme.colors.textSecondary,
                      fontSize: 11,
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
