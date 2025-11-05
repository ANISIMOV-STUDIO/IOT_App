/// Floating tooltip with smooth animations and web optimization
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Tooltip position options
enum TooltipPosition { top, bottom, left, right }

/// Premium tooltip with fade and slide animations
class FloatingTooltip extends StatefulWidget {
  final String message;
  final Widget child;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final TooltipPosition position;
  final double verticalOffset;

  const FloatingTooltip({
    super.key,
    required this.message,
    required this.child,
    this.backgroundColor,
    this.textStyle,
    this.position = TooltipPosition.top,
    this.verticalOffset = 8.0,
  });

  @override
  State<FloatingTooltip> createState() => _FloatingTooltipState();
}

class _FloatingTooltipState extends State<FloatingTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isHovered = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hideTooltip();
    _controller.dispose();
    super.dispose();
  }

  void _showTooltip() {
    if (_isHovered) return;
    setState(() => _isHovered = true);
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  void _hideTooltip() {
    if (!_isHovered) return;
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) setState(() => _isHovered = false);
    });
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final tooltipTop = widget.position == TooltipPosition.top
        ? offset.dy - 40.0 - widget.verticalOffset
        : offset.dy + size.height + widget.verticalOffset;

    return OverlayEntry(
      builder: (_) => Positioned(
        left: offset.dx + (size.width / 2) - 100,
        top: tooltipTop,
        child: Material(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 200.0,
                  minWidth: 50.0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: HvacSpacing.sm,
                  vertical: HvacSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? HvacColors.backgroundCard,
                  borderRadius: BorderRadius.circular(HvacRadius.sm),
                  border: Border.all(
                    color:
                        HvacColors.backgroundCardBorder.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.message,
                  style: widget.textStyle ??
                      HvacTypography.caption
                          .copyWith(color: HvacColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _showTooltip(),
      onExit: (_) => _hideTooltip(),
      child: widget.child,
    );
  }
}