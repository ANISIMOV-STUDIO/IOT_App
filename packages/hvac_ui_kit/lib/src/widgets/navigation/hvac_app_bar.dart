/// HVAC App Bar - Material Design 3 app bar
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';


/// Material Design 3 app bar for HVAC UI
///
/// Features:
/// - Material 3 styling
/// - Custom background colors
/// - Leading/actions widgets
/// - Centered or start-aligned title
/// - Elevation control
/// - System UI overlay customization
///
/// Usage:
/// ```dart
/// HvacAppBar(
///   title: 'Dashboard',
///   actions: [
///     IconButton(icon: Icon(Icons.settings), onPressed: () {}),
///   ],
/// )
/// ```
class HvacAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title (String or Widget)
  final dynamic title;

  /// Leading widget (typically back button or menu)
  final Widget? leading;

  /// Actions widgets (typically icon buttons)
  final List<Widget>? actions;

  /// Whether to center the title
  final bool centerTitle;

  /// Background color
  final Color? backgroundColor;

  /// Foreground color (icons, text)
  final Color? foregroundColor;

  /// Elevation
  final double elevation;

  /// Whether to show shadow
  final bool showShadow;

  /// Automatic leading (back button)
  final bool automaticallyImplyLeading;

  /// System overlay style
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Title spacing
  final double? titleSpacing;

  /// Bottom widget (typically TabBar)
  final PreferredSizeWidget? bottom;

  /// Flexible space (for scroll effects)
  final Widget? flexibleSpace;

  const HvacAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.showShadow = false,
    this.automaticallyImplyLeading = true,
    this.systemOverlayStyle,
    this.titleSpacing,
    this.bottom,
    this.flexibleSpace,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    Widget? titleWidget;
    if (title != null) {
      titleWidget = title is String
          ? Text(
              title as String,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: foregroundColor ?? HvacColors.textPrimary,
              ),
            )
          : title as Widget;
    }

    return AppBar(
      title: titleWidget,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? HvacColors.backgroundDark,
      foregroundColor: foregroundColor ?? HvacColors.textPrimary,
      elevation: elevation,
      shadowColor: showShadow ? HvacColors.textPrimary.withValues(alpha: 0.1) : Colors.transparent,
      automaticallyImplyLeading: automaticallyImplyLeading,
      systemOverlayStyle: systemOverlayStyle ??
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
      titleSpacing: titleSpacing,
      bottom: bottom,
      flexibleSpace: flexibleSpace,
    );
  }
}

/// Transparent app bar (for overlays)
///
/// Usage:
/// ```dart
/// HvacTransparentAppBar(
///   title: 'Details',
/// )
/// ```
class HvacTransparentAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const HvacTransparentAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return HvacAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}

/// Gradient app bar
///
/// Usage:
/// ```dart
/// HvacGradientAppBar(
///   title: 'Dashboard',
///   gradient: LinearGradient(
///     colors: [Colors.blue, Colors.purple],
///   ),
/// )
/// ```
class HvacGradientAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Gradient gradient;
  final bool centerTitle;

  const HvacGradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    required this.gradient,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return HvacAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: gradient),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}
