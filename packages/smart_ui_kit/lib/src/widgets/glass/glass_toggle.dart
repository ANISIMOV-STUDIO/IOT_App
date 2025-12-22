import 'package:flutter/material.dart';
import '../../theme/glass_colors.dart';

/// Glass Toggle Switch
class GlassToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final bool isDisabled;

  const GlassToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.isDisabled = false,
  });

  @override
  State<GlassToggle> createState() => _GlassToggleState();
}

class _GlassToggleState extends State<GlassToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _position;
  late Animation<Color?> _trackColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: widget.value ? 1.0 : 0.0,
      vsync: this,
    );
    _setupAnimations();
  }

  void _setupAnimations() {
    final activeColor = widget.activeColor ?? GlassColors.accentPrimary;
    _position = Tween<double>(begin: 2, end: 22).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _trackColor = ColorTween(
      begin: const Color(0xFFCBD5E1),
      end: activeColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(GlassToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      widget.value ? _controller.forward() : _controller.reverse();
    }
    if (widget.activeColor != oldWidget.activeColor) {
      _setupAnimations();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isDisabled && widget.onChanged != null) {
      widget.onChanged!(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.isDisabled ? 0.5 : 1.0,
      child: MouseRegion(
        cursor: widget.isDisabled
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _handleTap,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Container(
                width: 48,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: _trackColor.value,
                  boxShadow: [
                    BoxShadow(
                      color: (_trackColor.value ?? Colors.grey)
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: _position.value,
                      top: 2,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
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
              );
            },
          ),
        ),
      ),
    );
  }
}

// Backwards compatibility alias
typedef NeumorphicToggle = GlassToggle;
