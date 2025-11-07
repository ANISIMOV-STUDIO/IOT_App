/// Web Tooltip - Advanced tooltip system for web platform (Refactored)
///
/// Provides rich tooltips with positioning and animations optimized for web
/// Now compliant with 300-line limit through component extraction
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'tooltip_types.dart';
import 'tooltip_overlay.dart';
import 'tooltip_controller.dart';

/// Enhanced tooltip for web with rich content support
class WebTooltip extends StatefulWidget {
  final Widget child;
  final String? message;
  final Widget? richContent;
  final TooltipPosition position;
  final Duration showDuration;
  final Duration waitDuration;
  final bool showOnHover;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final TooltipTrigger trigger;

  const WebTooltip({
    super.key,
    required this.child,
    this.message,
    this.richContent,
    this.position = TooltipPosition.top,
    this.showDuration = const Duration(seconds: 3),
    this.waitDuration = const Duration(milliseconds: 500),
    this.showOnHover = true,
    this.backgroundColor,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.borderRadius = 8,
    this.trigger = TooltipTrigger.hover,
  }) : assert(message != null || richContent != null,
            'Either message or richContent must be provided');

  @override
  State<WebTooltip> createState() => _WebTooltipState();
}

class _WebTooltipState extends State<WebTooltip>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TooltipController _tooltipController;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeController();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  void _initializeController() {
    _tooltipController = TooltipController(
      showDuration: widget.showDuration,
      waitDuration: widget.waitDuration,
      onShow: _showTooltip,
      onHide: _hideTooltip,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    _tooltipController.dispose();
    super.dispose();
  }

  void _showTooltip() {
    if (!kIsWeb || (!widget.showOnHover && widget.trigger != TooltipTrigger.manual)) return;

    _removeOverlay();
    _createOverlay();
    _animationController.forward();
  }

  void _hideTooltip() {
    _animationController.reverse().then((_) {
      _removeOverlay();
    });
  }

  void _createOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => WebTooltipOverlay(
        targetOffset: offset,
        targetSize: size,
        message: widget.message,
        richContent: widget.richContent,
        position: widget.position,
        backgroundColor: widget.backgroundColor ?? HvacColors.backgroundElevated,
        textStyle: widget.textStyle ??
            HvacTypography.bodySmall.copyWith(
              color: HvacColors.textPrimary,
              fontSize: 13,
            ),
        padding: widget.padding,
        borderRadius: widget.borderRadius,
        animation: _fadeAnimation,
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleMouseEnter(_) {
    if (widget.trigger != TooltipTrigger.hover) return;
    setState(() => _isHovering = true);
    _tooltipController.startShowTimer();
  }

  void _handleMouseExit(_) {
    if (widget.trigger != TooltipTrigger.hover) return;
    setState(() => _isHovering = false);
    _tooltipController.cancelAllTimers();
    _hideTooltip();
  }

  void _handleTap() {
    if (widget.trigger != TooltipTrigger.tap) return;

    if (_overlayEntry != null) {
      _hideTooltip();
    } else {
      _showTooltip();
      _tooltipController.startHideTimer();
    }
  }

  void _handleLongPress() {
    if (widget.trigger != TooltipTrigger.longPress) return;
    _showTooltip();
    _tooltipController.startHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      // Fallback to native tooltip on non-web platforms
      return Tooltip(
        message: widget.message ?? '',
        child: widget.child,
      );
    }

    Widget result = widget.child;

    // Wrap with gesture detectors based on trigger
    if (widget.trigger == TooltipTrigger.tap) {
      result = GestureDetector(
        onTap: _handleTap,
        child: result,
      );
    } else if (widget.trigger == TooltipTrigger.longPress) {
      result = GestureDetector(
        onLongPress: _handleLongPress,
        child: result,
      );
    }

    // Always wrap with mouse region for hover detection
    return MouseRegion(
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      cursor: _isHovering ? SystemMouseCursors.help : SystemMouseCursors.basic,
      child: result,
    );
  }
}

/// Convenient tooltip with icon button
class TooltipIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double? iconSize;
  final TooltipPosition position;

  const TooltipIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.iconColor,
    this.iconSize,
    this.position = TooltipPosition.top,
  });

  @override
  Widget build(BuildContext context) {
    return WebTooltip(
      message: tooltip,
      position: position,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: iconColor ?? HvacColors.textSecondary,
        iconSize: iconSize ?? 20.0,
      ),
    );
  }
}

/// Rich tooltip with custom content
class RichTooltip extends StatelessWidget {
  final Widget child;
  final Widget content;
  final TooltipPosition position;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  const RichTooltip({
    super.key,
    required this.child,
    required this.content,
    this.position = TooltipPosition.top,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return WebTooltip(
      richContent: content,
      position: position,
      backgroundColor: backgroundColor,
      padding: padding,
      child: child,
    );
  }
}