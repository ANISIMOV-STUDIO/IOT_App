/// Web Responsive Layout - Adaptive layout system for web platform
///
/// Provides responsive breakpoints and layout utilities optimized for web
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Responsive breakpoints for web
class HvacBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
  static const double widescreen = 1920;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }

  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tablet && width < desktop;
  }

  static bool isWidescreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= widescreen;

  static T getValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? widescreen,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= HvacBreakpoints.widescreen && widescreen != null) {
      return widescreen;
    }
    if (width >= HvacBreakpoints.desktop && desktop != null) {
      return desktop;
    }
    if (width >= HvacBreakpoints.tablet && tablet != null) {
      return tablet;
    }
    return mobile;
  }
}

/// Web responsive scaffold with adaptive navigation
class HvacResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final Widget? drawer;
  final Widget? navigationRail;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool showNavigationRail;
  final int? navigationRailIndex;
  final ValueChanged<int>? onNavigationRailChanged;
  final Color? backgroundColor;

  const HvacResponsiveScaffold({
    super.key,
    required this.body,
    this.drawer,
    this.navigationRail,
    this.appBar,
    this.floatingActionButton,
    this.showNavigationRail = true,
    this.navigationRailIndex,
    this.onNavigationRailChanged,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = HvacBreakpoints.isDesktop(context) ||
        HvacBreakpoints.isWidescreen(context);

    if (isDesktop && showNavigationRail && navigationRail != null) {
      // Desktop layout with navigation rail
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar,
        body: Row(
          children: [
            navigationRail!,
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: body),
          ],
        ),
        floatingActionButton: floatingActionButton,
      );
    }

    // Mobile/tablet layout
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      drawer: drawer,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

/// Responsive grid layout
class HvacResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry? padding;

  const HvacResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final columns = HvacBreakpoints.getValue<int>(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
      widescreen: 4,
    );

    return Padding(
      padding: padding ?? const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth =
              (constraints.maxWidth - (spacing * (columns - 1))) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: children.map((child) {
              return SizedBox(
                width: itemWidth,
                child: child,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

/// Responsive container with max width constraints
class HvacResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry alignment;

  const HvacResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.margin,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final defaultMaxWidth = HvacBreakpoints.getValue<double>(
      context,
      mobile: double.infinity,
      tablet: 768,
      desktop: 1200,
      widescreen: 1440,
    );

    return Container(
      alignment: alignment,
      margin: margin,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? defaultMaxWidth,
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Responsive text that scales based on screen size
class HvacResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;

  const HvacResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = HvacBreakpoints.getValue<double>(
      context,
      mobile: mobileFontSize ?? 14,
      tablet: tabletFontSize ?? 16,
      desktop: desktopFontSize ?? 18,
    );

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Focus management for keyboard navigation
class HvacKeyboardNavigator extends StatelessWidget {
  final Widget child;
  final Map<ShortcutActivator, Intent>? shortcuts;

  const HvacKeyboardNavigator({
    super.key,
    required this.child,
    this.shortcuts,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return Focus(
      autofocus: true,
      child: shortcuts != null
          ? Shortcuts(
              shortcuts: shortcuts!,
              child: Actions(
                actions: <Type, Action<Intent>>{
                  ActivateIntent: CallbackAction<ActivateIntent>(
                    onInvoke: (ActivateIntent intent) => null,
                  ),
                },
                child: child,
              ),
            )
          : child,
    );
  }
}
