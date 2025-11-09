/// Bottom Sheet System
/// Provides Material 3 bottom sheets with HVAC theming
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';
import '../../theme/typography.dart';

/// HVAC-themed bottom sheet
class HvacBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final bool showDragHandle;
  final double? height;

  const HvacBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.showDragHandle = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = height ?? screenHeight * 0.7;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      decoration: const BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(HvacRadius.lg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            Container(
              margin: const EdgeInsets.only(top: HvacSpacing.sm),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: HvacColors.backgroundCardBorder,
                borderRadius: HvacRadius.fullRadius,
              ),
            ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                HvacSpacing.lg,
                HvacSpacing.md,
                HvacSpacing.lg,
                HvacSpacing.sm,
              ),
              child: Text(
                title!,
                style: HvacTypography.h3.copyWith(
                  color: HvacColors.textPrimary,
                ),
              ),
            ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: HvacSpacing.lg,
                vertical: HvacSpacing.sm,
              ),
              child: child,
            ),
          ),
          if (actions != null && actions!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(HvacSpacing.md),
              decoration: const BoxDecoration(
                color: HvacColors.backgroundCard,
                border: Border(
                  top: BorderSide(
                    color: HvacColors.backgroundCardBorder,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              ),
            ),
        ],
      ),
    );
  }

  /// Show bottom sheet
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    List<Widget>? actions,
    bool showDragHandle = true,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      builder: (context) => HvacBottomSheet(
        title: title,
        actions: actions,
        showDragHandle: showDragHandle,
        height: height,
        child: child,
      ),
    );
  }
}
