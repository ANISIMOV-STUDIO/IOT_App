/// Example usage of visual polish components
/// This file demonstrates how to use each component
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'visual_polish_components.dart' hide StatusIndicator, PremiumProgressIndicator;

class VisualPolishExample extends StatelessWidget {
  const VisualPolishExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Indicator Examples
            const Text('Status Indicators:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Row(
              children: [
                StatusIndicator(
                  isActive: true,
                  activeLabel: 'Online',
                ),
                SizedBox(width: 24),
                StatusIndicator(
                  isActive: false,
                  inactiveLabel: 'Offline',
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Animated Badge Examples
            const Text('Animated Badges:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Row(
              children: [
                AnimatedBadge(
                  label: 'Premium',
                  icon: Icons.star,
                  onTap: () {
                    // Handle premium badge tap
                  },
                ),
                const SizedBox(width: 16),
                const AnimatedBadge(
                  label: 'New',
                  isNew: true,
                  icon: Icons.new_releases,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Premium Progress Indicator
            const Text('Progress Indicators:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const PremiumProgressIndicator(
              value: 0.65,
              showPercentage: true,
            ),
            const SizedBox(height: 32),

            // Animated Dividers
            const Text('Dividers:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const AnimatedDivider(),
            const AnimatedDivider(
              style: DividerStyle.primary,
              height: 2,
            ),
            const SizedBox(height: 32),

            // Floating Tooltip
            const Text('Floating Tooltip:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const FloatingTooltip(
              message: 'This is a helpful tooltip message',
              child: Icon(Icons.info_outline, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}
