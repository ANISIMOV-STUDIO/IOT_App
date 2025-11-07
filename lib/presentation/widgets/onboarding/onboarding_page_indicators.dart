/// Onboarding Page Indicators Widget
///
/// Page indicator dots for onboarding navigation
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Page indicator dots widget
class OnboardingPageIndicators extends StatelessWidget {
  /// Current page index
  final int currentPage;

  /// Total number of pages (excluding last page)
  final int totalPages;

  /// Whether to use compact sizing
  final bool isCompact;

  const OnboardingPageIndicators({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: isCompact ? 50 : 80,
      left: 0,
      right: 0,
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalPages,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentPage == index ? 32 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentPage == index
                    ? HvacColors.primaryOrange
                    : HvacColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
