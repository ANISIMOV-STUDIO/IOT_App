/// Analytics Loading Chart Widget
///
/// Shimmer loading state for chart containers
/// Single Responsibility: Only handles chart loading visualization
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class AnalyticsLoadingChart extends StatelessWidget {
  final String? title;
  final double height;

  const AnalyticsLoadingChart({
    super.key,
    this.title,
    this.height = 300.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(HvacSpacing.xlR),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: HvacColors.textPrimary,
              ),
            )
          else
            Container(
              width: 150.0,
              height: 16.0,
              decoration: BoxDecoration(
                color: HvacColors.backgroundElevated,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          const SizedBox(height: HvacSpacing.lgR),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: HvacColors.backgroundElevated,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
