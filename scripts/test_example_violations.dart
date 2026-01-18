/// Example file with intentional design system violations
///
/// This file demonstrates what the CI checks will catch.
/// DO NOT use these patterns in production code!
library;

import 'package:flutter/material.dart';

/// BAD EXAMPLE - This file intentionally violates design system rules
/// to demonstrate what the CI checks will catch
class BadExampleWidget extends StatelessWidget {
  const BadExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ❌ VIOLATION: Hardcoded color
          Container(
            color: Colors.white,
            child: const Text('Violation 1: Colors.white'),
          ),

          // ❌ VIOLATION: Hardcoded EdgeInsets
          Padding(
            padding: const EdgeInsets.all(16),
            child: const Text('Violation 2: Hardcoded padding'),
          ),

          // ❌ VIOLATION: Hardcoded SizedBox
          const SizedBox(height: 12),

          // ❌ VIOLATION: Hardcoded BorderRadius
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black,
            ),
            child: const Text('Violation 3: Hardcoded radius'),
          ),

          // ❌ VIOLATION: Hardcoded Duration
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: const Text('Violation 4: Hardcoded duration'),
          ),

          // ❌ VIOLATION: Material button
          ElevatedButton(
            onPressed: () {},
            child: const Text('Violation 5: Material button'),
          ),

          // ❌ VIOLATION: Hardcoded font size
          const Text(
            'Violation 6: Hardcoded font size',
            style: TextStyle(fontSize: 14),
          ),

          // ❌ VIOLATION: Color literal
          Container(
            color: const Color(0xFF00D9C4),
            child: const Text('Violation 7: Color literal'),
          ),

          // ❌ VIOLATION: Theme.of(context).primaryColor
          Container(
            color: Theme.of(context).primaryColor,
            child: const Text('Violation 8: Theme.of(context).primaryColor'),
          ),

          // ❌ VIOLATION: TextButton
          TextButton(
            onPressed: () {},
            child: const Text('Violation 9: TextButton'),
          ),
        ],
      ),
    );
  }
}

/// GOOD EXAMPLE - Correct usage of design system
///
/// This is how the code should look!
class GoodExampleWidget extends StatelessWidget {
  const GoodExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Uncomment these imports in actual code:
    // import 'package:hvac_control/core/theme/spacing.dart';
    // import 'package:hvac_control/core/theme/app_radius.dart';
    // import 'package:hvac_control/core/theme/app_animations.dart';
    // import 'package:hvac_control/core/theme/app_font_sizes.dart';
    // import 'package:hvac_control/core/theme/app_colors.dart';
    // import 'package:hvac_control/presentation/widgets/breez/breez_button.dart';

    /* CORRECT IMPLEMENTATION:

    final colors = BreezColors.of(context);

    return Scaffold(
      body: Column(
        children: [
          // ✅ CORRECT: Use AppColors
          Container(
            color: AppColors.white,
            child: const Text('Correct: AppColors.white'),
          ),

          // ✅ CORRECT: Use AppSpacing
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: const Text('Correct: AppSpacing.md'),
          ),

          // ✅ CORRECT: Use AppSpacing for SizedBox
          SizedBox(height: AppSpacing.sm),

          // ✅ CORRECT: Use AppRadius
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.chip),
              color: colors.card,
            ),
            child: const Text('Correct: AppRadius.chip'),
          ),

          // ✅ CORRECT: Use AppDurations
          AnimatedContainer(
            duration: AppDurations.normal,
            child: const Text('Correct: AppDurations.normal'),
          ),

          // ✅ CORRECT: Use BreezButton
          BreezButton(
            onPressed: () {},
            label: 'Correct: BreezButton',
          ),

          // ✅ CORRECT: Use AppFontSizes
          Text(
            'Correct: AppFontSizes.body',
            style: TextStyle(fontSize: AppFontSizes.body),
          ),

          // ✅ CORRECT: Use AppColors for static colors
          Container(
            color: AppColors.accent,
            child: const Text('Correct: AppColors.accent'),
          ),

          // ✅ CORRECT: Use BreezColors for theme-aware colors
          Container(
            color: colors.card,
            child: const Text('Correct: BreezColors.of(context).card'),
          ),
        ],
      ),
    );
    */

    return const Placeholder(); // Temporary
  }
}
