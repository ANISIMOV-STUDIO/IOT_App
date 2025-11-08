/// Web Hover Card - Enhanced card with hover effects for web
///
/// Provides smooth hover animations and cursor feedback for web platform
library;

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class HvacHoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool showElevationOnHover;
  final bool scaleOnHover;
  final Duration animationDuration;
  final Curve animationCurve;
  final Color? backgroundColor;
  final bool enableGlassmorphism;

  const WebHoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.borderRadius = 12.0,
    this.showElevationOnHover = true,
    this.scaleOnHover = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
    this.backgroundColor,
    this.enableGlassmorphism = true,
  });

  @override
  State<WebHoverCard> createState() => _HvacHoverCardState();
}

class _HvacHoverCardState extends State<WebHoverCard>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleOnHover ? 1.02 : 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));

    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.showElevationOnHover ? 8.0 : 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleHoverChange(bool hovering) {
    if (!kIsWeb) return; // Only apply hover effects on web

    setState(() {
      _isHovering = hovering;
      if (hovering) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: widget.showElevationOnHover
                  ? [
                      BoxShadow(
                        color: HvacColors.primaryOrange.withValues(alpha: 0.1),
                        blurRadius: _elevationAnimation.value,
                        offset: Offset(0, _elevationAnimation.value / 2),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: InkWell(
                onTap: widget.onTap,
                onLongPress: widget.onLongPress,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                splashColor: HvacColors.primaryOrange.withValues(alpha: 0.1),
                highlightColor:
                    HvacColors.primaryOrange.withValues(alpha: 0.05),
                child: Container(
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ??
                        (_isHovering
                            ? HvacColors.backgroundElevated
                                .withValues(alpha: 0.05)
                            : Colors.transparent),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: _isHovering
                        ? Border.all(
                            color:
                                HvacColors.primaryOrange.withValues(alpha: 0.3),
                            width: 1,
                          )
                        : null,
                  ),
                  child: widget.enableGlassmorphism
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: widget.child,
                          ),
                        )
                      : widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );

    if (kIsWeb) {
      return MouseRegion(
        onEnter: (_) => _handleHoverChange(true),
        onExit: (_) => _handleHoverChange(false),
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: card,
      );
    }

    return card;
  }
}

/// Web Hover Icon Button - Icon button with hover effects for web
class HvacHoverIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;
  final Color? hoverColor;
  final String? tooltip;
  final bool showBackground;

  const WebHoverIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 24.0,
    this.color,
    this.hoverColor,
    this.tooltip,
    this.showBackground = false,
  });

  @override
  State<WebHoverIconButton> createState() => _HvacHoverIconButtonState();
}

class _HvacHoverIconButtonState extends State<WebHoverIconButton>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconButton = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size + 16,
            height: widget.size + 16,
            decoration: widget.showBackground
                ? BoxDecoration(
                    color: _isHovering
                        ? HvacColors.primaryOrange.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  )
                : null,
            child: IconButton(
              icon: Icon(
                widget.icon,
                size: widget.size,
                color: _isHovering
                    ? (widget.hoverColor ?? HvacColors.primaryOrange)
                    : (widget.color ?? HvacColors.textSecondary),
              ),
              onPressed: widget.onPressed,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: widget.size + 16,
                minHeight: widget.size + 16,
              ),
            ),
          ),
        );
      },
    );

    final button = kIsWeb
        ? MouseRegion(
            onEnter: (_) {
              setState(() => _isHovering = true);
              _animationController.forward();
            },
            onExit: (_) {
              setState(() => _isHovering = false);
              _animationController.reverse();
            },
            cursor: widget.onPressed != null
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            child: iconButton,
          )
        : iconButton;

    return widget.tooltip != null
        ? Tooltip(
            message: widget.tooltip!,
            child: button,
          )
        : button;
  }
}
