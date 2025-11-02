/// Adaptive Layout Widgets
///
/// Core responsive layout components
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/responsive_utils.dart';
import '../theme/spacing.dart';

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
      effectivePadding = EdgeInsets.all(AppSpacing.mdR);
    } else if (ResponsiveUtils.isTablet(context)) {
      effectivePadding = EdgeInsets.all(AppSpacing.lgR);
    } else {
      effectivePadding = EdgeInsets.all(AppSpacing.xlR);
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
      effectivePadding = EdgeInsets.all(AppSpacing.mdR);
    } else if (isTablet) {
      effectivePadding = EdgeInsets.all(AppSpacing.lgR);
    } else {
      effectivePadding = EdgeInsets.all(AppSpacing.xlR);
    }

    // Adaptive border radius
    final radius = borderRadius ?? (isMobile ? 12.r : 16.r);

    return Container(
      margin: margin ?? EdgeInsets.symmetric(
        horizontal: isMobile ? AppSpacing.mdR : AppSpacing.lgR,
        vertical: AppSpacing.smV,
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
                  SizedBox(height: AppSpacing.mdV),
                ],
                content,
                if (actions != null && actions!.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.mdV),
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
          padding: EdgeInsets.only(bottom: AppSpacing.smV),
          child: action,
        )).toList(),
      );
    }

    // Horizontal layout for desktop/tablet or few actions
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions!.map((action) => Padding(
        padding: EdgeInsets.only(left: AppSpacing.smR),
        child: action,
      )).toList(),
    );
  }
}