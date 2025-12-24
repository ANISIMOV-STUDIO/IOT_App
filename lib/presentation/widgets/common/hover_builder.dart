/// Hover Builder - Reusable hover state widget
library;

import 'package:flutter/material.dart';

/// Builder widget that provides hover state
class HoverBuilder extends StatefulWidget {
  /// Builder function that receives hover state
  final Widget Function(BuildContext context, bool isHovered) builder;

  /// Optional tap callback
  final VoidCallback? onTap;

  /// Mouse cursor when hovering
  final MouseCursor cursor;

  const HoverBuilder({
    super.key,
    required this.builder,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
  });

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: widget.builder(context, _isHovered),
      ),
    );
  }
}

/// Animated hover container with common styling
class HoverContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color? selectedColor;
  final Color? hoverColor;
  final Color? defaultColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final BoxBorder? border;
  final Duration duration;

  const HoverContainer({
    super.key,
    required this.child,
    this.onTap,
    this.isSelected = false,
    this.selectedColor,
    this.hoverColor,
    this.defaultColor,
    this.borderRadius,
    this.padding,
    this.border,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      onTap: onTap,
      builder: (context, isHovered) {
        return AnimatedContainer(
          duration: duration,
          padding: padding,
          decoration: BoxDecoration(
            color: isSelected
                ? selectedColor
                : isHovered
                    ? hoverColor
                    : defaultColor ?? Colors.transparent,
            borderRadius: borderRadius,
            border: border,
          ),
          child: child,
        );
      },
    );
  }
}
