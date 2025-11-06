/// Analytics Chart Container Widget
///
/// Reusable container for chart widgets with consistent styling
/// Follows DRY principle - single source of truth for chart container styling
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class AnalyticsChartContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;
  final bool isLoading;

  const AnalyticsChartContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    return Container(
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
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 20.0,
              ),
              const SizedBox(width: HvacSpacing.xsR),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: HvacSpacing.lgR),
          child,
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300.0,
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