import 'package:flutter/material.dart';
import '../../theme/glass_colors.dart';
import '../../theme/glass_theme.dart';

/// Glass Slider with modern styling
class GlassSlider extends StatefulWidget {
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

  const GlassSlider({
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
    this.height = 8,
  });

  @override
  State<GlassSlider> createState() => _GlassSliderState();
}

class _GlassSliderState extends State<GlassSlider> {
  late double _localValue;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _localValue = widget.value;
  }

  @override
  void didUpdateWidget(GlassSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging && widget.value != oldWidget.value) {
      _localValue = widget.value;
    }
  }

  double get _progress =>
      ((_localValue - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final color = widget.activeColor ?? GlassColors.accentPrimary;

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

        // Slider track
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            final thumbSize = 24.0;
            final thumbPosition = _progress * (trackWidth - thumbSize);

            return MouseRegion(
              cursor:
                  _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
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
                      // Track background
                      Positioned(
                        left: 0,
                        right: 0,
                        top: (thumbSize - widget.height) / 2,
                        child: Container(
                          height: widget.height,
                          decoration: BoxDecoration(
                            color: theme.colors.textTertiary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(widget.height / 2),
                          ),
                        ),
                      ),

                      // Progress fill
                      Positioned(
                        left: 0,
                        top: (thumbSize - widget.height) / 2,
                        child: AnimatedContainer(
                          duration: _isDragging
                              ? Duration.zero
                              : const Duration(milliseconds: 150),
                          width: (thumbPosition + thumbSize / 2)
                              .clamp(0.0, trackWidth),
                          height: widget.height,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(widget.height / 2),
                            gradient: LinearGradient(
                              colors: [
                                color,
                                color.withValues(alpha: 0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Thumb
                      AnimatedPositioned(
                        duration: _isDragging
                            ? Duration.zero
                            : const Duration(milliseconds: 150),
                        left: thumbPosition,
                        top: 0,
                        child: _GlassThumb(
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
    final newProgress =
        ((dx - thumbSize / 2) / (trackWidth - thumbSize)).clamp(0.0, 1.0);
    final newValue = widget.min + newProgress * (widget.max - widget.min);

    setState(() => _localValue = newValue);
    widget.onChanged?.call(newValue);
  }
}

/// Glass thumb for slider
class _GlassThumb extends StatelessWidget {
  final double size;
  final Color color;
  final bool isPressed;

  const _GlassThumb({
    required this.size,
    required this.color,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: color,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: isPressed ? 12 : 8,
            offset: const Offset(0, 2),
            spreadRadius: isPressed ? 2 : 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

// Backwards compatibility alias
typedef NeumorphicSlider = GlassSlider;

/// Preset buttons for slider
class GlassSliderPresets extends StatelessWidget {
  final List<SliderPreset> presets;
  final double currentValue;
  final ValueChanged<double>? onPresetSelected;

  const GlassSliderPresets({
    super.key,
    required this.presets,
    required this.currentValue,
    this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);

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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? GlassColors.accentPrimary.withValues(alpha: 0.15)
                        : theme.colors.glassSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? GlassColors.accentPrimary.withValues(alpha: 0.5)
                          : theme.colors.glassBorder,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      preset.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? GlassColors.accentPrimary
                            : theme.colors.textSecondary,
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

// Backwards compatibility alias
typedef NeumorphicSliderPresets = GlassSliderPresets;

class SliderPreset {
  final String label;
  final double value;
  const SliderPreset({required this.label, required this.value});
}
