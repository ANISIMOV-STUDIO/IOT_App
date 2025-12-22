import 'package:flutter/material.dart';
import '../../theme/glass_colors.dart';
import '../../theme/glass_theme.dart';

enum GlassButtonSize { small, medium, large }

typedef NeumorphicButtonSize = GlassButtonSize;

/// Premium Glass Button - clean, minimal
class GlassButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final GlassButtonSize size;
  final double? width;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const GlassButton({
    super.key,
    required this.child,
    this.onPressed,
    this.size = GlassButtonSize.medium,
    this.width,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isPressed = false;

  double get _height => switch (widget.size) {
        GlassButtonSize.small => 36.0,
        GlassButtonSize.medium => 44.0,
        GlassButtonSize.large => 52.0,
      };

  double get _fontSize => switch (widget.size) {
        GlassButtonSize.small => 14.0,
        GlassButtonSize.medium => 16.0,
        GlassButtonSize.large => 18.0,
      };

  @override
  Widget build(BuildContext context) {
    final isEnabled = !widget.isDisabled && !widget.isLoading;
    final bgColor = widget.backgroundColor ?? GlassColors.accentPrimary;
    final fgColor = widget.foregroundColor ?? Colors.white;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: widget.isDisabled ? 0.5 : (_isPressed ? 0.8 : 1.0),
        child: Container(
          width: widget.width,
          height: _height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18, color: fgColor),
                const SizedBox(width: 8),
              ],
              if (widget.isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(fgColor),
                  ),
                )
              else
                DefaultTextStyle(
                  style: TextStyle(
                    color: fgColor,
                    fontSize: _fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                  child: widget.child,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef NeumorphicButton = GlassButton;

/// Glass Icon Button - minimal circle button
class GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double size;
  final String? tooltip;

  const GlassIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.size = 40,
    this.tooltip,
  });

  @override
  State<GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<GlassIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);

    Widget button = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _isHovered
                ? theme.colors.textTertiary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: widget.iconColor ?? theme.colors.textSecondary,
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}

typedef NeumorphicIconButton = GlassIconButton;
