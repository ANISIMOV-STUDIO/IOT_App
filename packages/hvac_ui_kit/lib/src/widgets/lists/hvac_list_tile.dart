/// HVAC List Tile - Material Design 3 list item
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

/// Material Design 3 list tile for HVAC UI
///
/// Features:
/// - Support for leading/trailing widgets
/// - Material 3 styling
/// - Hover and tap states
/// - Optional divider
/// - Customizable padding
///
/// Usage:
/// ```dart
/// HvacListTile(
///   leading: Icon(Icons.thermostat),
///   title: Text('Living Room'),
///   subtitle: Text('24°C'),
///   trailing: Icon(Icons.chevron_right),
///   onTap: () => navigateToRoom(),
/// )
/// ```
class HvacListTile extends StatefulWidget {
  /// Leading widget (typically an icon or avatar)
  final Widget? leading;

  /// Title text or widget
  final Widget title;

  /// Subtitle text or widget
  final Widget? subtitle;

  /// Trailing widget (typically an icon or action)
  final Widget? trailing;

  /// Tap callback
  final VoidCallback? onTap;

  /// Long press callback
  final VoidCallback? onLongPress;

  /// Whether the tile is enabled
  final bool enabled;

  /// Whether the tile is selected
  final bool selected;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected color
  final Color? selectedColor;

  /// Content padding
  final EdgeInsets? contentPadding;

  /// Minimum height
  final double? minHeight;

  /// Whether to show divider
  final bool showDivider;

  const HvacListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.backgroundColor,
    this.selectedColor,
    this.contentPadding,
    this.minHeight,
    this.showDivider = false,
  });

  @override
  State<HvacListTile> createState() => _HvacListTileState();
}

class _HvacListTileState extends State<HvacListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = widget.selected
        ? (widget.selectedColor ?? HvacColors.primary.withValues(alpha: 0.1))
        : widget.backgroundColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          onEnter: widget.enabled ? (_) => setState(() => _isHovered = true) : null,
          onExit: widget.enabled ? (_) => setState(() => _isHovered = false) : null,
          cursor: widget.enabled && widget.onTap != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: InkWell(
            onTap: widget.enabled ? widget.onTap : null,
            onLongPress: widget.enabled ? widget.onLongPress : null,
            borderRadius: HvacRadius.mdRadius,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              constraints: widget.minHeight != null
                  ? BoxConstraints(minHeight: widget.minHeight!)
                  : null,
              decoration: BoxDecoration(
                color: _isHovered && widget.enabled
                    ? HvacColors.primary.withValues(alpha: 0.05)
                    : effectiveBackgroundColor,
                borderRadius: HvacRadius.mdRadius,
              ),
              padding: widget.contentPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: HvacSpacing.md,
                    vertical: HvacSpacing.sm,
                  ),
              child: Row(
                children: [
                  // Leading widget
                  if (widget.leading != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: widget.selected
                            ? HvacColors.primary
                            : HvacColors.textSecondary,
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
                            color: widget.enabled
                                ? HvacColors.textPrimary
                                : HvacColors.textTertiary,
                          ),
                          child: widget.title,
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: HvacSpacing.xxs),
                          DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 14,
                              color: widget.enabled
                                  ? HvacColors.textSecondary
                                  : HvacColors.textTertiary,
                            ),
                            child: widget.subtitle!,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Trailing widget
                  if (widget.trailing != null) ...[
                    const SizedBox(width: HvacSpacing.md),
                    IconTheme(
                      data: IconThemeData(
                        color: widget.enabled
                            ? HvacColors.textSecondary
                            : HvacColors.textTertiary,
                        size: 24,
                      ),
                      child: widget.trailing!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (widget.showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: HvacColors.backgroundCardBorder,
            indent: widget.leading != null ? 56 : HvacSpacing.md,
          ),
      ],
    );
  }
}

/// List tile with switch
///
/// Usage:
/// ```dart
/// HvacSwitchListTile(
///   title: Text('Auto Mode'),
///   value: isAutoMode,
///   onChanged: (value) => setState(() => isAutoMode = value),
/// )
/// ```
class HvacSwitchListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final EdgeInsets? contentPadding;

  const HvacSwitchListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return HvacListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      contentPadding: contentPadding,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: activeColor ?? HvacColors.primary,
      ),
      onTap: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}

/// List tile with checkbox
///
/// Usage:
/// ```dart
/// HvacCheckboxListTile(
///   title: Text('Enable notifications'),
///   value: notificationsEnabled,
///   onChanged: (value) => setState(() => notificationsEnabled = value ?? false),
/// )
/// ```
class HvacCheckboxListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final EdgeInsets? contentPadding;

  const HvacCheckboxListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return HvacListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      contentPadding: contentPadding,
      trailing: Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor ?? HvacColors.primary,
      ),
      onTap: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}
