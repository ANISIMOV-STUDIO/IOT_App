import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart' as np;
import 'neumorphic_theme_wrapper.dart';
import '../../theme/tokens/neumorphic_colors.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Neumorphic Slider with proper inset track and convex thumb
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
  final double height;

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
    this.height = 20,
  });

  @override
  State<NeumorphicSlider> createState() => _NeumorphicSliderState();
}

class _NeumorphicSliderState extends State<NeumorphicSlider> {
  late double _localValue;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _localValue = widget.value;
  }

  @override
  void didUpdateWidget(NeumorphicSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging && widget.value != oldWidget.value) {
      _localValue = widget.value;
    }
  }

  double get _progress => ((_localValue - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

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
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  Text(widget.label!, style: theme.typography.bodyMedium),
                if (widget.showValue)
                  Text(
                    '${_localValue.round()}${widget.suffix ?? ''}',
                    style: theme.typography.numericMedium.copyWith(color: color),
                  ),
              ],
            ),
          ),

        // Neumorphic slider track
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            final thumbSize = widget.height + 8;
            final thumbPosition = _progress * (trackWidth - thumbSize);

            return MouseRegion(
              cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
              child: GestureDetector(
              onHorizontalDragStart: (_) {
                setState(() => _isDragging = true);
              },
              onHorizontalDragUpdate: (details) {
                _updateValue(details.localPosition.dx, trackWidth, thumbSize);
              },
              onHorizontalDragEnd: (_) {
                setState(() => _isDragging = false);
                widget.onChangeEnd?.call(_localValue);
              },
              onTapDown: (details) {
                _updateValue(details.localPosition.dx, trackWidth, thumbSize);
                widget.onChangeEnd?.call(_localValue);
              },
              child: SizedBox(
                height: thumbSize,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Track background (concave/inset)
                    Positioned.fill(
                      top: (thumbSize - widget.height) / 2,
                      bottom: (thumbSize - widget.height) / 2,
                      child: np.Neumorphic(
                        style: np.NeumorphicStyle(
                          depth: -3,
                          intensity: 0.7,
                          boxShape: np.NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(widget.height / 2),
                          ),
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),

                    // Progress fill
                    Positioned(
                      left: 3,
                      top: (thumbSize - widget.height) / 2 + 3,
                      bottom: (thumbSize - widget.height) / 2 + 3,
                      child: AnimatedContainer(
                        duration: _isDragging
                            ? Duration.zero
                            : const Duration(milliseconds: 150),
                        width: (_progress * (trackWidth - 6)).clamp(0.0, trackWidth - 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular((widget.height - 6) / 2),
                          gradient: LinearGradient(
                            colors: [
                              color.withValues(alpha: 0.8),
                              color,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Thumb (convex/raised)
                    Positioned(
                      left: thumbPosition,
                      top: 0,
                      child: _NeumorphicThumb(
                        size: thumbSize,
                        color: color,
                        isPressed: _isDragging,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            );
          },
        ),
      ],
    );
  }

  void _updateValue(double dx, double trackWidth, double thumbSize) {
    final newProgress = ((dx - thumbSize / 2) / (trackWidth - thumbSize)).clamp(0.0, 1.0);
    final newValue = widget.min + newProgress * (widget.max - widget.min);

    setState(() => _localValue = newValue);
    widget.onChanged?.call(newValue);
  }
}

/// Convex neumorphic thumb
class _NeumorphicThumb extends StatelessWidget {
  final double size;
  final Color color;
  final bool isPressed;

  const _NeumorphicThumb({
    required this.size,
    required this.color,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    return np.Neumorphic(
      style: np.NeumorphicStyle(
        depth: isPressed ? 2 : 4,
        intensity: 0.6,
        surfaceIntensity: 0.15,
        color: Colors.white,
        boxShape: const np.NeumorphicBoxShape.circle(),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Center(
          child: Container(
            width: size * 0.35,
            height: size * 0.35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

/// Preset buttons for slider (neumorphic style)
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
    return Row(
      children: presets.map((preset) {
        final isSelected = (currentValue - preset.value).abs() < 1;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onPresetSelected?.call(preset.value),
                child: np.Neumorphic(
                  duration: Duration.zero, // No animation jank
                  style: np.NeumorphicStyle(
                    depth: isSelected ? -2 : 3,
                    intensity: 0.5,
                    boxShape: np.NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(NeumorphicSpacing.radiusSm),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: Text(
                      preset.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? NeumorphicColors.accentPrimary
                            : Colors.grey.shade600,
                      ),
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
