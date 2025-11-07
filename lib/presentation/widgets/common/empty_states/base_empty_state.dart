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
            padding: padding ?? const EdgeInsets.all(HvacSpacing.xl),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  const SizedBox(height: HvacSpacing.lg),
                  Text(title,
                      style: HvacTypography.h4.copyWith(fontSize: 24.0),
                      textAlign: TextAlign.center),
                  if (subtitle != null) ...[
                    const SizedBox(height: HvacSpacing.sm),
                    Text(subtitle!,
                        style: HvacTypography.bodySmall.copyWith(
                            color: HvacColors.textSecondary, fontSize: 14.0),
                        textAlign: TextAlign.center),
                  ],
                  if (action != null) ...[
                    const SizedBox(height: HvacSpacing.xl),
                    action!,
                  ],
                ])));

    if (enableAnimation) {
      content = content
          .animate()
          .fadeIn(duration: 600.ms, curve: Curves.easeOut)
          .slideY(begin: 0.1, end: 0, duration: 500.ms, curve: Curves.easeOut);
    }

    return content;
  }
}
