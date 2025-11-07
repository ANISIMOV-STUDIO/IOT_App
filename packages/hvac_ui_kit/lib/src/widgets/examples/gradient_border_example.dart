/// Example usage of HvacGradientBorder
library;

import 'package:flutter/material.dart';
import '../hvac_gradient_border.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class GradientBorderExample extends StatelessWidget {
  const GradientBorderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(title: const Text('Gradient Borders')),
      body: ListView(
        padding: const EdgeInsets.all(HvacSpacing.md),
        children: [
          const Text('Static Gradient Borders:',
              style: TextStyle(color: HvacColors.textSecondary)),
          const SizedBox(height: HvacSpacing.md),

          // Branded border
          HvacBrandedBorder(
            child: _buildCard('Branded Border\n(Orange → Blue)'),
          ),
          const SizedBox(height: HvacSpacing.lg),

          // Success border
          HvacSuccessBorder(
            child: _buildCard('Success Border\n(Device Active)'),
          ),
          const SizedBox(height: HvacSpacing.lg),

          // Warning border
          HvacWarningBorder(
            child: _buildCard('Warning Border\n(Attention Needed)'),
          ),
          const SizedBox(height: HvacSpacing.lg),

          // Error border
          HvacErrorBorder(
            child: _buildCard('Error Border\n(Device Offline)'),
          ),
          const SizedBox(height: HvacSpacing.xl),

          const Text('Animated Gradient Border:',
              style: TextStyle(color: HvacColors.textSecondary)),
          const SizedBox(height: HvacSpacing.md),

          // Animated border
          HvacAnimatedGradientBorder(
            gradientColors: const [
              HvacColors.primaryOrange,
              HvacColors.primaryBlue,
              HvacColors.primaryOrange,
            ],
            borderWidth: 3,
            child: _buildCard('Animated Rotating\nGradient Border'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String text) {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.xl),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
