/// HVAC Expansion Tile - Expandable list item
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

/// Expandable list tile with Material 3 styling
///
/// Features:
/// - Smooth expand/collapse animation
/// - Custom leading/trailing widgets
/// - Nested children support
/// - Initial expanded state
/// - Callback on expansion change
///
/// Usage:
/// ```dart
/// HvacExpansionTile(
///   title: Text('Advanced Settings'),
///   children: [
///     HvacListTile(title: Text('Option 1')),
///     HvacListTile(title: Text('Option 2')),
///   ],
/// )
/// ```
class HvacExpansionTile extends StatefulWidget {
  /// Title widget
  final Widget title;

  /// Subtitle widget
  final Widget? subtitle;

  /// Leading widget
  final Widget? leading;

  /// Trailing widget (overrides expand icon)
  final Widget? trailing;

  /// Child widgets shown when expanded
  final List<Widget> children;

  /// Initial expanded state
  final bool initiallyExpanded;

  /// Callback when expansion changes
  final ValueChanged<bool>? onExpansionChanged;

  /// Background color
  final Color? backgroundColor;

  /// Collapsed background color
  final Color? collapsedBackgroundColor;

  /// Text color
  final Color? textColor;

  /// Icon color
  final Color? iconColor;

  /// Content padding
  final EdgeInsets? tilePadding;

  /// Children padding
  final EdgeInsets? childrenPadding;

  /// Maintain state when collapsed
  final bool maintainState;

  /// Expand icon
  final IconData? expandIcon;

  /// Show border
  final bool showBorder;

  const HvacExpansionTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.children,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.iconColor,
    this.tilePadding,
    this.childrenPadding,
    this.maintainState = false,
    this.expandIcon,
    this.showBorder = false,
  });

  @override
  State<HvacExpansionTile> createState() => _HvacExpansionTileState();
}

class _HvacExpansionTileState extends State<HvacExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return Container(
      decoration: BoxDecoration(
        color: _isExpanded
            ? (widget.backgroundColor ?? Colors.transparent)
            : (widget.collapsedBackgroundColor ?? Colors.transparent),
        borderRadius: HvacRadius.mdRadius,
        border: widget.showBorder
            ? Border.all(
                color: HvacColors.backgroundCardBorder,
                width: 1,
              )
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          InkWell(
            onTap: _handleTap,
            borderRadius: HvacRadius.mdRadius,
            child: Padding(
              padding: widget.tilePadding ??
                  const EdgeInsets.symmetric(
                    horizontal: HvacSpacing.md,
                    vertical: HvacSpacing.sm,
                  ),
              child: Row(
                children: [
                  // Leading
                  if (widget.leading != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: widget.iconColor ?? HvacColors.textSecondary,
                        size: 24,
                      ),
                      child: widget.leading!,
                    ),
                    const SizedBox(width: HvacSpacing.md),
                  ],

                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: widget.textColor ?? HvacColors.textPrimary,
                          ),
                          child: widget.title,
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: HvacSpacing.xxs),
                          DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 14,
                              color: HvacColors.textSecondary,
                            ),
                            child: widget.subtitle!,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Trailing
                  if (widget.trailing != null)
                    widget.trailing!
                  else
                    RotationTransition(
                      turns: _iconTurns,
                      child: Icon(
                        widget.expandIcon ?? Icons.expand_more,
                        color: widget.iconColor ?? HvacColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Expanded content
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: widget.childrenPadding ??
              const EdgeInsets.only(
                left: HvacSpacing.md,
                right: HvacSpacing.md,
                bottom: HvacSpacing.sm,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}

/// Compact expansion tile for cards
///
/// Usage:
/// ```dart
/// HvacCompactExpansionTile(
///   title: 'Details',
///   children: [
///     Text('Detail 1'),
///     Text('Detail 2'),
///   ],
/// )
/// ```
class HvacCompactExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? leading;

  const HvacCompactExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return HvacExpansionTile(
      title: Text(title),
      leading: leading,
      backgroundColor: HvacColors.backgroundCard.withValues(alpha: 0.5),
      tilePadding: const EdgeInsets.all(HvacSpacing.sm),
      childrenPadding: const EdgeInsets.all(HvacSpacing.sm),
      showBorder: true,
      children: children,
    );
  }
}
