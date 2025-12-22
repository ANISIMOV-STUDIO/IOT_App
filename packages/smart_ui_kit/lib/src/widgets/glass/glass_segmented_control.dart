import 'package:flutter/material.dart';
import '../../theme/glass_colors.dart';
import '../../theme/glass_theme.dart';

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

/// Glass Segmented Control
class GlassSegmentedControl<T> extends StatelessWidget {
  final List<SegmentItem<T>> segments;
  final T? selectedValue;
  final ValueChanged<T>? onSelected;
  final double height;
  final bool showLabels;

  const GlassSegmentedControl({
    super.key,
    required this.segments,
    this.selectedValue,
    this.onSelected,
    this.height = 48,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);

    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.isDark
            ? const Color(0x1AFFFFFF)
            : const Color(0x0D000000),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: segments.map((segment) {
          final isSelected = segment.value == selectedValue;
          return Expanded(
            child: _GlassSegmentButton<T>(
              segment: segment,
              isSelected: isSelected,
              showLabel: showLabels,
              onTap: () => onSelected?.call(segment.value),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Backwards compatibility alias
typedef NeumorphicSegmentedControl<T> = GlassSegmentedControl<T>;

class _GlassSegmentButton<T> extends StatefulWidget {
  final SegmentItem<T> segment;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback? onTap;

  const _GlassSegmentButton({
    required this.segment,
    required this.isSelected,
    required this.showLabel,
    this.onTap,
  });

  @override
  State<_GlassSegmentButton<T>> createState() => _GlassSegmentButtonState<T>();
}

class _GlassSegmentButtonState<T> extends State<_GlassSegmentButton<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final color = widget.segment.activeColor ?? GlassColors.accentPrimary;
    final textColor = widget.isSelected ? color : theme.colors.textTertiary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(2),
          decoration: widget.isSelected
              ? BoxDecoration(
                  color: theme.isDark
                      ? const Color(0x33FFFFFF)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                )
              : BoxDecoration(
                  color: _isHovered
                      ? theme.colors.glassSurface.withValues(alpha: 0.5)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
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
                          fontWeight: widget.isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                : Icon(widget.segment.icon, size: 22, color: textColor),
          ),
        ),
      ),
    );
  }
}
