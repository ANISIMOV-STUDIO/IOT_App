/// Adaptive Dialog Widget
///
/// Dialog that adapts size based on screen width
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
/// Responsive dialog that adapts size based on screen
class AdaptiveDialog extends StatelessWidget {
  final Widget? title;
  final Widget content;
  final List<Widget>? actions;

  const AdaptiveDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    // Determine dialog width
    double dialogWidth;
    if (isMobile) {
      dialogWidth = screenWidth * 0.9;
    } else if (isTablet) {
      dialogWidth = screenWidth * 0.7;
    } else {
      dialogWidth = 600.w;
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 16.r : 20.r),
      ),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.all(HvacSpacing.lgR),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: isMobile ? 18.sp : 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  child: title!,
                ),
              ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: HvacSpacing.lgR,
                  vertical: HvacSpacing.mdV,
                ),
                child: content,
              ),
            ),
            if (actions != null && actions!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(HvacSpacing.mdR),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}