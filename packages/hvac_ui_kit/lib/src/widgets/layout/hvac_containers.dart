/// HVAC Containers - Layout container variants
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

/// Section container with optional title
///
/// Features:
/// - Optional section title
/// - Customizable padding
/// - Background color
/// - Border radius
///
/// Usage:
/// ```dart
/// HvacSection(
///   title: 'Overview',
///   child: Text('Content'),
/// )
/// ```
class HvacSection extends StatelessWidget {
  /// Section title
  final String? title;

  /// Section content
  final Widget child;

  /// Padding around content
  final EdgeInsets? padding;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Title style
  final TextStyle? titleStyle;

  /// Spacing between title and content
  final double titleSpacing;

  /// Show border
  final bool showBorder;

  /// Border color
  final Color? borderColor;

  const HvacSection({
    super.key,
    this.title,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.titleStyle,
    this.titleSpacing = HvacSpacing.md,
    this.showBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: HvacSpacing.md,
              bottom: HvacSpacing.sm,
            ),
            child: Text(
              title!,
              style: titleStyle ??
                  const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: HvacColors.textPrimary,
                  ),
            ),
          ),
          SizedBox(height: titleSpacing),
        ],

        // Content
        Container(
          padding: padding ?? const EdgeInsets.all(HvacSpacing.lg),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ?? HvacRadius.lgRadius,
            border: showBorder
                ? Border.all(
                    color: borderColor ?? HvacColors.backgroundCardBorder,
                    width: 1,
                  )
                : null,
          ),
          child: child,
        ),
      ],
    );
  }
}

/// Basic panel container
///
/// Usage:
/// ```dart
/// HvacPanel(
///   child: Text('Panel content'),
/// )
/// ```
class HvacPanel extends StatelessWidget {
  /// Panel content
  final Widget child;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Padding
  final EdgeInsets? padding;

  /// Show border
  final bool showBorder;

  /// Border color
  final Color? borderColor;

  /// Show shadow
  final bool showShadow;

  const HvacPanel({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.showBorder = true,
    this.borderColor,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(HvacSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? HvacColors.backgroundCard,
        borderRadius: borderRadius ?? HvacRadius.lgRadius,
        border: showBorder
            ? Border.all(
                color: borderColor ?? HvacColors.backgroundCardBorder,
                width: 1,
              )
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

/// Inset container (iOS-style)
///
/// Usage:
/// ```dart
/// HvacInsetContainer(
///   child: Text('Inset content'),
/// )
/// ```
class HvacInsetContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const HvacInsetContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          const EdgeInsets.symmetric(
            horizontal: HvacSpacing.md,
            vertical: HvacSpacing.sm,
          ),
      padding: padding ?? const EdgeInsets.all(HvacSpacing.md),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.lgRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

/// Elevated container with shadow
///
/// Usage:
/// ```dart
/// HvacElevatedContainer(
///   elevation: 4,
///   child: Text('Elevated content'),
/// )
/// ```
class HvacElevatedContainer extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const HvacElevatedContainer({
    super.key,
    required this.child,
    this.elevation = 4.0,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: borderRadius ?? HvacRadius.lgRadius,
      color: backgroundColor ?? HvacColors.backgroundCard,
      child: Container(
        padding: padding ?? const EdgeInsets.all(HvacSpacing.md),
        child: child,
      ),
    );
  }
}

/// Scrollable container with optional header and footer
///
/// Usage:
/// ```dart
/// HvacScrollableContainer(
///   header: Text('Header'),
///   child: LongContent(),
///   footer: Text('Footer'),
/// )
/// ```
class HvacScrollableContainer extends StatelessWidget {
  final Widget? header;
  final Widget child;
  final Widget? footer;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;

  const HvacScrollableContainer({
    super.key,
    this.header,
    required this.child,
    this.footer,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) header!,
          child,
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

/// Constraint container with max width
///
/// Usage:
/// ```dart
/// HvacConstrainedContainer(
///   maxWidth: 800,
///   child: WideContent(),
/// )
/// ```
class HvacConstrainedContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final bool center;

  const HvacConstrainedContainer({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget constrained = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );

    if (center) {
      return Center(child: constrained);
    }

    return constrained;
  }
}
