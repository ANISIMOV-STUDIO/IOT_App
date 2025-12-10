import 'package:flutter/material.dart';
import '../../theme/neumorphic_theme.dart';
import '../../theme/tokens/neumorphic_colors.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Neumorphic Slider - Soft UI slider with track shadow
class NeumorphicSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
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
    this.activeColor,
    this.label,
    this.suffix,
    this.showValue = true,
  });

  @override
  State<NeumorphicSlider> createState() => _NeumorphicSliderState();
}

class _NeumorphicSliderState extends State<NeumorphicSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(NeumorphicSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final activeColor = widget.activeColor ?? NeumorphicColors.accentPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label and value row
        if (widget.label != null || widget.showValue)
          Padding(
            padding: const EdgeInsets.only(bottom: NeumorphicSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: theme.typography.titleMedium,
                  ),
                if (widget.showValue)
                  Row(
                    children: [
                      Text(
                        _currentValue.round().toString(),
                        style: theme.typography.numericMedium,
                      ),
                      if (widget.suffix != null)
                        Text(
                          widget.suffix!,
                          style: theme.typography.unit,
                        ),
                    ],
                  ),
              ],
            ),
          ),

        // Slider track
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            final progress = (_currentValue - widget.min) / (widget.max - widget.min);
            final thumbPosition = progress * (trackWidth - 24); // 24 = thumb width

            return GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (widget.onChanged == null) return;
                
                final newProgress = (details.localPosition.dx / trackWidth)
                    .clamp(0.0, 1.0);
                final newValue = widget.min + newProgress * (widget.max - widget.min);
                
                setState(() {
                  _currentValue = newValue;
                });
                widget.onChanged?.call(newValue);
              },
              onTapDown: (details) {
                if (widget.onChanged == null) return;
                
                final newProgress = (details.localPosition.dx / trackWidth)
                    .clamp(0.0, 1.0);
                final newValue = widget.min + newProgress * (widget.max - widget.min);
                
                setState(() {
                  _currentValue = newValue;
                });
                widget.onChanged?.call(newValue);
              },
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: theme.colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: theme.shadows.concaveSmall,
                ),
                child: Stack(
                  children: [
                    // Active track
                    Positioned(
                      left: 4,
                      top: 4,
                      bottom: 4,
                      width: thumbPosition + 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: activeColor.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    
                    // Thumb
                    Positioned(
                      left: thumbPosition,
                      top: 2,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: activeColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: activeColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
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
        final isSelected = (currentValue - preset.value).abs() < 0.5;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onPresetSelected?.call(preset.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  vertical: NeumorphicSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? theme.colors.cardSurface 
                      : theme.colors.surface,
                  borderRadius: BorderRadius.circular(NeumorphicSpacing.radiusSm),
                  boxShadow: isSelected 
                      ? theme.shadows.convexSmall 
                      : theme.shadows.flat,
                  border: isSelected 
                      ? Border.all(
                          color: NeumorphicColors.accentPrimary.withValues(alpha: 0.3),
                          width: 1,
                        )
                      : null,
                ),
                child: Center(
                  child: Text(
                    preset.label,
                    style: theme.typography.labelLarge.copyWith(
                      color: isSelected 
                          ? theme.colors.textPrimary 
                          : theme.colors.textSecondary,
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

  const SliderPreset({
    required this.label,
    required this.value,
  });
}
