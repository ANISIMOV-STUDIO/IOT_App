/// Base Empty State Widget
/// Core component for all empty state variations
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Base empty state widget with customizable content
class BaseEmptyState extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final EdgeInsets? padding;
  final bool enableAnimation;

  const BaseEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.padding,
    this.enableAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Padding(
        padding: padding ?? EdgeInsets.all(HvacSpacing.xl.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(height: HvacSpacing.lg.h),
            Text(
              title,
              style: HvacTypography.h4.copyWith(
                fontSize: 24.sp,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: HvacSpacing.sm.h),
              Text(
                subtitle!,
                style: HvacTypography.bodySmall.copyWith(
                  color: HvacColors.textSecondary,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: HvacSpacing.xl.h),
              action!,
            ],
          ],
        ),
      ),
    );

    if (enableAnimation) {
      content = content
          .animate()
          .fadeIn(duration: 600.ms, curve: Curves.easeOut)
          .slideY(
            begin: 0.1,
            end: 0,
            duration: 500.ms,
            curve: Curves.easeOut,
          );
    }

    return content;
  }
}