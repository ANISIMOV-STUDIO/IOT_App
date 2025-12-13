import 'package:flutter/material.dart';

/// Universal touchable wrapper for neumorphic components
/// Provides: cursor change, press state, optional haptic feedback
class NeumorphicTouchable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onPressedChanged;
  final bool enabled;
  final MouseCursor cursor;
  final HitTestBehavior behavior;

  const NeumorphicTouchable({
    super.key,
    required this.child,
    this.onTap,
    this.onPressedChanged,
    this.enabled = true,
    this.cursor = SystemMouseCursors.click,
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  State<NeumorphicTouchable> createState() => _NeumorphicTouchableState();
}

class _NeumorphicTouchableState extends State<NeumorphicTouchable> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed != value) {
      setState(() => _isPressed = value);
      widget.onPressedChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return MouseRegion(
      cursor: widget.cursor,
      child: GestureDetector(
        behavior: widget.behavior,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) {
          _setPressed(false);
          widget.onTap?.call();
        },
        onTapCancel: () => _setPressed(false),
        child: widget.child,
      ),
    );
  }
}

/// Draggable variant for sliders
class NeumorphicDraggable extends StatelessWidget {
  final Widget child;
  final GestureDragStartCallback? onPanStart;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragEndCallback? onPanEnd;
  final GestureTapDownCallback? onTapDown;
  final MouseCursor cursor;

  const NeumorphicDraggable({
    super.key,
    required this.child,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onTapDown,
    this.cursor = SystemMouseCursors.grab,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        onTapDown: onTapDown,
        child: child,
      ),
    );
  }
}
