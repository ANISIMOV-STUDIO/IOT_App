/// HVAC Sliver App Bar - Scrollable app bar with collapse effects
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';


/// Collapsible sliver app bar for scrollable content
///
/// Features:
/// - Collapse/expand on scroll
/// - Background image/widget support
/// - Flexible space customization
/// - Pinned/floating options
/// - Material 3 styling
///
/// Usage:
/// ```dart
/// CustomScrollView(
///   slivers: [
///     HvacSliverAppBar(
///       title: 'Device Details',
///       expandedHeight: 200,
///       flexibleSpace: FlexibleSpaceBar(
///         background: Image.network('url'),
///       ),
///     ),
///     SliverList(...),
///   ],
/// )
/// ```
class HvacSliverAppBar extends StatelessWidget {
  /// App bar title
  final dynamic title;

  /// Expanded height
  final double expandedHeight;

  /// Leading widget
  final Widget? leading;

  /// Actions widgets
  final List<Widget>? actions;

  /// Flexible space widget
  final Widget? flexibleSpace;

  /// Background widget
  final Widget? background;

  /// Whether to pin the app bar
  final bool pinned;

  /// Whether to float the app bar
  final bool floating;

  /// Whether to snap when floating
  final bool snap;

  /// Background color
  final Color? backgroundColor;

  /// Foreground color
  final Color? foregroundColor;

  /// Elevation
  final double elevation;

  /// Whether to center title
  final bool centerTitle;

  /// Whether to stretch
  final bool stretch;

  /// System overlay style
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Bottom widget (typically TabBar)
  final PreferredSizeWidget? bottom;

  const HvacSliverAppBar({
    super.key,
    this.title,
    this.expandedHeight = 200.0,
    this.leading,
    this.actions,
    this.flexibleSpace,
    this.background,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.stretch = false,
    this.systemOverlayStyle,
    this.bottom,
  });

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

    Widget? effectiveFlexibleSpace = flexibleSpace;
    if (background != null && flexibleSpace == null) {
      effectiveFlexibleSpace = FlexibleSpaceBar(
        background: background,
        centerTitle: centerTitle,
      );
    }

    return SliverAppBar(
      title: titleWidget,
      expandedHeight: expandedHeight,
      leading: leading,
      actions: actions,
      flexibleSpace: effectiveFlexibleSpace,
      pinned: pinned,
      floating: floating,
      snap: snap,
      backgroundColor: backgroundColor ?? HvacColors.backgroundDark,
      foregroundColor: foregroundColor ?? HvacColors.textPrimary,
      elevation: elevation,
      centerTitle: centerTitle,
      stretch: stretch,
      systemOverlayStyle: systemOverlayStyle ??
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
      bottom: bottom,
    );
  }
}

/// Sliver app bar with image background
///
/// Usage:
/// ```dart
/// HvacImageSliverAppBar(
///   title: 'Room Details',
///   imageUrl: 'assets/room.jpg',
/// )
/// ```
class HvacImageSliverAppBar extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double expandedHeight;
  final List<Widget>? actions;
  final bool pinned;

  const HvacImageSliverAppBar({
    super.key,
    required this.title,
    required this.imageUrl,
    this.expandedHeight = 250.0,
    this.actions,
    this.pinned = true,
  });

  @override
  Widget build(BuildContext context) {
    return HvacSliverAppBar(
      title: title,
      expandedHeight: expandedHeight,
      actions: actions,
      pinned: pinned,
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}

/// Sliver app bar with gradient background
///
/// Usage:
/// ```dart
/// HvacGradientSliverAppBar(
///   title: 'Analytics',
///   gradient: LinearGradient(
///     colors: [Colors.blue, Colors.purple],
///   ),
/// )
/// ```
class HvacGradientSliverAppBar extends StatelessWidget {
  final String title;
  final Gradient gradient;
  final double expandedHeight;
  final List<Widget>? actions;
  final bool pinned;

  const HvacGradientSliverAppBar({
    super.key,
    required this.title,
    required this.gradient,
    this.expandedHeight = 200.0,
    this.actions,
    this.pinned = true,
  });

  @override
  Widget build(BuildContext context) {
    return HvacSliverAppBar(
      title: title,
      expandedHeight: expandedHeight,
      actions: actions,
      pinned: pinned,
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(gradient: gradient),
        ),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}
