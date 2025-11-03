/// Adaptive Layout Widgets
///
/// Core responsive layout components
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
/// Container that constrains max width on larger screens
class AdaptiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;

  const AdaptiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.margin,
    this.decoration,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine max width based on device
    double effectiveMaxWidth;
    if (maxWidth != null) {
      effectiveMaxWidth = maxWidth!;
    } else if (ResponsiveUtils.isMobile(context)) {
      effectiveMaxWidth = double.infinity;
    } else if (ResponsiveUtils.isTablet(context)) {
      effectiveMaxWidth = screenWidth < 900 ? 600.w : 800.w;
    } else {
      effectiveMaxWidth = 1200.w;
    }

    // Determine padding based on device
    EdgeInsets effectivePadding;
    if (padding != null) {
      effectivePadding = padding!;
    } else if (ResponsiveUtils.isMobile(context)) {
      effectivePadding = const EdgeInsets.all(HvacSpacing.mdR);
    } else if (ResponsiveUtils.isTablet(context)) {
      effectivePadding = const EdgeInsets.all(HvacSpacing.lgR);
    } else {
      effectivePadding = const EdgeInsets.all(HvacSpacing.xlR);
    }

    return Container(
      alignment: alignment ?? Alignment.center,
      margin: margin,
      child: Container(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        padding: effectivePadding,
        decoration: decoration,
        child: child,
      ),
    );
  }
}

/// Two-pane layout that stacks on mobile, side-by-side on tablet+
class AdaptiveTwoPane extends StatelessWidget {
  final Widget leftPane;
  final Widget rightPane;
  final double breakpoint;
  final int leftFlex;
  final int rightFlex;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  const AdaptiveTwoPane({
    super.key,
    required this.leftPane,
    required this.rightPane,
    this.breakpoint = 600,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.spacing = 24,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSingleColumn = constraints.maxWidth < breakpoint;

        if (isSingleColumn) {
          return Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              leftPane,
              SizedBox(height: spacing.h),
              rightPane,
            ],
          );
        }

        return Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Expanded(
              flex: leftFlex,
              child: leftPane,
            ),
            SizedBox(width: spacing.w),
            Expanded(
              flex: rightFlex,
              child: rightPane,
            ),
          ],
        );
      },
    );
  }
}

/// Adaptive card that adjusts internal layout based on screen size
class AdaptiveCard extends StatelessWidget {
  final Widget? title;
  final Widget content;
  final List<Widget>? actions;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final Border? border;

  const AdaptiveCard({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    // Adaptive padding
    EdgeInsets effectivePadding;
    if (padding != null) {
      effectivePadding = padding!;
    } else if (isMobile) {
      effectivePadding = const EdgeInsets.all(HvacSpacing.mdR);
    } else if (isTablet) {
      effectivePadding = const EdgeInsets.all(HvacSpacing.lgR);
    } else {
      effectivePadding = const EdgeInsets.all(HvacSpacing.xlR);
    }

    // Adaptive border radius
    final radius = borderRadius ?? (isMobile ? 12.r : 16.r);

    return Container(
      margin: margin ?? EdgeInsets.symmetric(
        horizontal: isMobile ? HvacSpacing.mdR : HvacSpacing.lgR,
        vertical: HvacSpacing.smV,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radius),
        border: border,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: effectivePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) ...[
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: isMobile ? 16.sp : 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    child: title!,
                  ),
                  const SizedBox(height: HvacSpacing.mdV),
                ],
                content,
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: HvacSpacing.mdV),
                  _buildActions(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    if (isMobile && actions!.length > 2) {
      // Stack actions vertically on mobile if more than 2
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: actions!.map((action) => Padding(
          padding: const EdgeInsets.only(bottom: HvacSpacing.smV),
          child: action,
        )).toList(),
      );
    }

    // Horizontal layout for desktop/tablet or few actions
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions!.map((action) => Padding(
        padding: const EdgeInsets.only(left: HvacSpacing.smR),
        child: action,
      )).toList(),
    );
  }
}