import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'snackbar_types.dart';

/// Toast widget implementation with responsive design and hover effects
class ToastWidget extends StatefulWidget {
  final String message;
  final IconData? icon;
  final ToastPosition position;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const ToastWidget({
    super.key,
    required this.message,
    this.icon,
    required this.position,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    required this.onDismiss,
  });

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.position == ToastPosition.top ? -1 : 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isMobile = screenWidth < 600;
    final toastMaxWidth = screenWidth < 600 ? null : (screenWidth < 1024 ? 400.0 : 480.0);

    // Position adjustments for web
    final topPosition = widget.position == ToastPosition.top
      ? (isMobile
          ? mediaQuery.padding.top + 16
          : 32)
      : null;

    final bottomPosition = widget.position == ToastPosition.bottom
      ? (isMobile
          ? mediaQuery.padding.bottom + 16
          : 32)
      : null;

    // Horizontal margins for different devices
    final horizontalMargin = isMobile ? 16.0 : 24.0;

    return Positioned(
      top: topPosition?.toDouble(),
      bottom: bottomPosition?.toDouble(),
      left: horizontalMargin,
      right: horizontalMargin,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: toastMaxWidth ?? double.infinity,
              ),
              child: _buildToastContent(context, theme, isMobile),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToastContent(
    BuildContext context,
    ThemeData theme,
    bool isMobile,
  ) {
    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () {
            widget.onTap?.call();
            widget.onDismiss();
          },
          onHorizontalDragEnd: (details) {
            // Allow dismissing by swiping
            if (details.primaryVelocity != null &&
                details.primaryVelocity!.abs() > 100) {
              widget.onDismiss();
            }
          },
          child: Transform.scale(
            scale: _isHovered ? 1.02 : 1.0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 12 : 14,
              ),
              decoration: BoxDecoration(
                color: widget.backgroundColor ??
                    theme.colorScheme.inverseSurface,
                borderRadius: HvacRadius.smRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: _isHovered ? 12 : 8,
                    offset: Offset(0, _isHovered ? 4 : 2),
                  ),
                ],
              ),
              child: _buildToastBody(context, theme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToastBody(BuildContext context, ThemeData theme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth >= 1024 ? 20.0 : (screenWidth >= 600 ? 19.0 : 18.0);
    final fontSize = screenWidth >= 1024 ? 14.0 : (screenWidth >= 600 ? 13.5 : 13.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            color: widget.textColor ?? theme.colorScheme.onInverseSurface,
            size: iconSize,
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.textColor ?? theme.colorScheme.onInverseSurface,
              fontSize: fontSize,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}