import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart' as np;
import '../../theme/tokens/neumorphic_colors.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Segment item data
class SegmentItem<T> {
  final T value;
  final String label;
  final IconData icon;
  final Color? activeColor;

  const SegmentItem({
    required this.value,
    required this.label,
    required this.icon,
    this.activeColor,
  });
}

/// Neumorphic Segmented Control - iOS-style segmented control with neumorphic styling
class NeumorphicSegmentedControl<T> extends StatelessWidget {
  final List<SegmentItem<T>> segments;
  final T? selectedValue;
  final ValueChanged<T>? onSelected;
  final double height;
  final bool showLabels;

  const NeumorphicSegmentedControl({
    super.key,
    required this.segments,
    this.selectedValue,
    this.onSelected,
    this.height = 48,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    return np.Neumorphic(
      style: np.NeumorphicStyle(
        depth: -2,
        intensity: 0.5,
        boxShape: np.NeumorphicBoxShape.roundRect(
          BorderRadius.circular(NeumorphicSpacing.radiusMd),
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        height: height,
        child: Row(
          children: segments.map((segment) {
            final isSelected = segment.value == selectedValue;
            return Expanded(
              child: _SegmentButton<T>(
                segment: segment,
                isSelected: isSelected,
                showLabel: showLabels,
                onTap: () => onSelected?.call(segment.value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SegmentButton<T> extends StatefulWidget {
  final SegmentItem<T> segment;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback? onTap;

  const _SegmentButton({
    required this.segment,
    required this.isSelected,
    required this.showLabel,
    this.onTap,
  });

  @override
  State<_SegmentButton<T>> createState() => _SegmentButtonState<T>();
}

class _SegmentButtonState<T> extends State<_SegmentButton<T>> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.segment.activeColor ?? NeumorphicColors.accentPrimary;
    final textColor = widget.isSelected ? color : Colors.grey.shade500;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: widget.isSelected
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(NeumorphicSpacing.radiusSm),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.8),
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              )
            : BoxDecoration(
                color: _isPressed ? Colors.grey.shade100 : Colors.transparent,
                borderRadius: BorderRadius.circular(NeumorphicSpacing.radiusSm),
              ),
        child: Center(
          child: widget.showLabel
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.segment.icon, size: 18, color: textColor),
                    const SizedBox(height: 2),
                    Text(
                      widget.segment.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              : Icon(widget.segment.icon, size: 22, color: textColor),
        ),
      ),
    );
  }
}
