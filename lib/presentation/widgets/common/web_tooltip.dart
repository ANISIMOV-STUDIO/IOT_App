/// Web Tooltip - Advanced tooltip system for web platform
///
/// Provides rich tooltips with positioning and animations optimized for web
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

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
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _showTooltip() {
    if (!kIsWeb || !widget.showOnHover) return;

    _removeOverlay();

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => _WebTooltipOverlay(
        targetOffset: offset,
        targetSize: size,
        message: widget.message,
        richContent: widget.richContent,
        position: widget.position,
        backgroundColor:
            widget.backgroundColor ?? HvacColors.backgroundElevated,
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
    _animationController.forward();

    Future.delayed(widget.showDuration, () {
      if (!_isHovering) {
        _removeOverlay();
      }
    });
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Tooltip(
        message: widget.message ?? '',
        child: widget.child,
      );
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        Future.delayed(widget.waitDuration, () {
          if (_isHovering) _showTooltip();
        });
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        _removeOverlay();
      },
      child: widget.child,
    );
  }
}

class _WebTooltipOverlay extends StatelessWidget {
  final Offset targetOffset;
  final Size targetSize;
  final String? message;
  final Widget? richContent;
  final TooltipPosition position;
  final Color backgroundColor;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Animation<double> animation;

  const _WebTooltipOverlay({
    required this.targetOffset,
    required this.targetSize,
    this.message,
    this.richContent,
    required this.position,
    required this.backgroundColor,
    required this.textStyle,
    required this.padding,
    required this.borderRadius,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final tooltipOffset = _calculateTooltipOffset(screenSize);

    return Positioned(
      left: tooltipOffset.dx,
      top: tooltipOffset.dy,
      child: FadeTransition(
        opacity: animation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 300,
              minWidth: 100,
            ),
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: HvacColors.glassBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: richContent ??
                Text(
                  message!,
                  style: textStyle,
                ),
          ),
        ),
      ),
    );
  }

  Offset _calculateTooltipOffset(Size screenSize) {
    const spacing = 8.0;
    double left = 0;
    double top = 0;

    switch (position) {
      case TooltipPosition.top:
        left = targetOffset.dx + (targetSize.width / 2);
        top = targetOffset.dy - spacing;
        break;
      case TooltipPosition.bottom:
        left = targetOffset.dx + (targetSize.width / 2);
        top = targetOffset.dy + targetSize.height + spacing;
        break;
      case TooltipPosition.left:
        left = targetOffset.dx - spacing;
        top = targetOffset.dy + (targetSize.height / 2);
        break;
      case TooltipPosition.right:
        left = targetOffset.dx + targetSize.width + spacing;
        top = targetOffset.dy + (targetSize.height / 2);
        break;
    }

    // Ensure tooltip stays within screen bounds
    left = left.clamp(spacing, screenSize.width - 300 - spacing);
    top = top.clamp(spacing, screenSize.height - 100 - spacing);

    return Offset(left, top);
  }
}

enum TooltipPosition {
  top,
  bottom,
  left,
  right,
}

/// Web Context Menu - Right-click context menu for web
class WebContextMenu extends StatefulWidget {
  final Widget child;
  final List<WebContextMenuItem> items;

  const WebContextMenu({
    super.key,
    required this.child,
    required this.items,
  });

  @override
  State<WebContextMenu> createState() => _WebContextMenuState();
}

class _WebContextMenuState extends State<WebContextMenu> {
  OverlayEntry? _overlayEntry;

  void _showContextMenu(TapDownDetails details) {
    if (!kIsWeb) return;

    _removeOverlay();

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned(
              left: details.globalPosition.dx,
              top: details.globalPosition.dy,
              child: _WebContextMenuOverlay(
                items: widget.items,
                onItemTap: (item) {
                  _removeOverlay();
                  item.onTap();
                },
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return widget.child;

    return GestureDetector(
      onSecondaryTapDown: _showContextMenu,
      child: widget.child,
    );
  }
}

class _WebContextMenuOverlay extends StatelessWidget {
  final List<WebContextMenuItem> items;
  final Function(WebContextMenuItem) onItemTap;

  const _WebContextMenuOverlay({
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      color: HvacColors.backgroundCard,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 180,
          maxWidth: 250,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) {
            if (item.isDivider) {
              return Divider(
                height: 1,
                color: HvacColors.backgroundCardBorder,
              );
            }

            return _WebContextMenuItemWidget(
              item: item,
              onTap: () => onItemTap(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _WebContextMenuItemWidget extends StatefulWidget {
  final WebContextMenuItem item;
  final VoidCallback onTap;

  const _WebContextMenuItemWidget({
    required this.item,
    required this.onTap,
  });

  @override
  State<_WebContextMenuItemWidget> createState() =>
      _WebContextMenuItemWidgetState();
}

class _WebContextMenuItemWidgetState extends State<_WebContextMenuItemWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.item.enabled ? widget.onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: _isHovering && widget.item.enabled
              ? HvacColors.backgroundElevated
              : Colors.transparent,
          child: Row(
            children: [
              if (widget.item.icon != null) ...[
                Icon(
                  widget.item.icon,
                  size: 18,
                  color: widget.item.enabled
                      ? HvacColors.textPrimary
                      : HvacColors.textDisabled,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: HvacTypography.bodySmall.copyWith(
                    fontSize: 14,
                    color: widget.item.enabled
                        ? HvacColors.textPrimary
                        : HvacColors.textDisabled,
                  ),
                ),
              ),
              if (widget.item.shortcut != null)
                Text(
                  widget.item.shortcut!,
                  style: HvacTypography.bodySmall.copyWith(
                    fontSize: 12,
                    color: HvacColors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebContextMenuItem {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final String? shortcut;
  final bool enabled;
  final bool isDivider;

  const WebContextMenuItem({
    required this.label,
    this.icon,
    required this.onTap,
    this.shortcut,
    this.enabled = true,
    this.isDivider = false,
  });

  const WebContextMenuItem.divider()
      : label = '',
        icon = null,
        onTap = _emptyCallback,
        shortcut = null,
        enabled = false,
        isDivider = true;

  static void _emptyCallback() {}
}
