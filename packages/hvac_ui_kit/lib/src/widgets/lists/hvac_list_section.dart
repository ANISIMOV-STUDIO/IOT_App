/// HVAC List Section - Grouped list with header
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

/// Grouped list section with header
///
/// Features:
/// - Optional header with title
/// - Optional footer
/// - Divider control
/// - Material 3 styling
///
/// Usage:
/// ```dart
/// HvacListSection(
///   title: 'Devices',
///   children: [
///     HvacListTile(title: Text('Living Room')),
///     HvacListTile(title: Text('Bedroom')),
///   ],
/// )
/// ```
class HvacListSection extends StatelessWidget {
  /// Section title
  final String? title;

  /// Section header widget (overrides title)
  final Widget? header;

  /// Section footer widget
  final Widget? footer;

  /// List items
  final List<Widget> children;

  /// Show dividers between items
  final bool showDividers;

  /// Section background color
  final Color? backgroundColor;

  /// Section border radius
  final BorderRadius? borderRadius;

  /// Section padding
  final EdgeInsets? padding;

  /// Header padding
  final EdgeInsets? headerPadding;

  /// Footer padding
  final EdgeInsets? footerPadding;

  /// Space between items
  final double? itemSpacing;

  const HvacListSection({
    super.key,
    this.title,
    this.header,
    this.footer,
    required this.children,
    this.showDividers = false,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.headerPadding,
    this.footerPadding,
    this.itemSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? HvacRadius.lgRadius,
        border: backgroundColor != null
            ? Border.all(
                color: HvacColors.backgroundCardBorder,
                width: 1,
              )
            : null,
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          if (header != null || title != null)
            Padding(
              padding: headerPadding ??
                  const EdgeInsets.only(
                    left: HvacSpacing.md,
                    right: HvacSpacing.md,
                    top: HvacSpacing.sm,
                    bottom: HvacSpacing.xs,
                  ),
              child: header ??
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: HvacColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
            ),

          // Items
          if (showDividers)
            ...children
                .expand(
                  (child) => [
                    child,
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: HvacColors.backgroundCardBorder,
                    ),
                  ],
                )
                .take(children.length * 2 - 1)
          else
            ...children
                .expand(
                  (child) => [
                    child,
                    if (itemSpacing != null) SizedBox(height: itemSpacing),
                  ],
                )
                .take(
                    children.length * 2 - (itemSpacing != null ? 1 : 0)),

          // Footer
          if (footer != null)
            Padding(
              padding: footerPadding ??
                  const EdgeInsets.only(
                    left: HvacSpacing.md,
                    right: HvacSpacing.md,
                    top: HvacSpacing.xs,
                    bottom: HvacSpacing.sm,
                  ),
              child: footer,
            ),
        ],
      ),
    );
  }
}

/// Compact list section (card-style)
///
/// Usage:
/// ```dart
/// HvacCompactListSection(
///   title: 'Quick Actions',
///   children: [
///     ListTile(title: Text('Action 1')),
///     ListTile(title: Text('Action 2')),
///   ],
/// )
/// ```
class HvacCompactListSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final bool showDividers;

  const HvacCompactListSection({
    super.key,
    this.title,
    required this.children,
    this.showDividers = true,
  });

  @override
  Widget build(BuildContext context) {
    return HvacListSection(
      title: title,
      showDividers: showDividers,
      backgroundColor: HvacColors.backgroundCard,
      borderRadius: HvacRadius.lgRadius,
      padding: const EdgeInsets.all(HvacSpacing.xs),
      headerPadding: const EdgeInsets.fromLTRB(
        HvacSpacing.md,
        HvacSpacing.md,
        HvacSpacing.md,
        HvacSpacing.sm,
      ),
      children: children,
    );
  }
}

/// Inset grouped list (iOS-style)
///
/// Usage:
/// ```dart
/// HvacInsetListSection(
///   title: 'SETTINGS',
///   children: [
///     HvacListTile(title: Text('Account')),
///     HvacListTile(title: Text('Privacy')),
///   ],
/// )
/// ```
class HvacInsetListSection extends StatelessWidget {
  final String? title;
  final String? footer;
  final List<Widget> children;

  const HvacInsetListSection({
    super.key,
    this.title,
    this.footer,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              HvacSpacing.lg,
              HvacSpacing.md,
              HvacSpacing.lg,
              HvacSpacing.xs,
            ),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: HvacColors.textTertiary,
                letterSpacing: 0.5,
              ),
            ),
          ),

        // Card with items
        Container(
          margin: const EdgeInsets.symmetric(horizontal: HvacSpacing.md),
          decoration: BoxDecoration(
            color: HvacColors.backgroundCard,
            borderRadius: HvacRadius.lgRadius,
            border: Border.all(
              color: HvacColors.backgroundCardBorder,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children
                .expand(
                  (child) => [
                    child,
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: HvacColors.backgroundCardBorder,
                      indent: HvacSpacing.md,
                    ),
                  ],
                )
                .take(children.length * 2 - 1)
                .toList(),
          ),
        ),

        // Footer
        if (footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              HvacSpacing.lg,
              HvacSpacing.xs,
              HvacSpacing.lg,
              HvacSpacing.md,
            ),
            child: Text(
              footer!,
              style: const TextStyle(
                fontSize: 13,
                color: HvacColors.textTertiary,
              ),
            ),
          ),
      ],
    );
  }
}
