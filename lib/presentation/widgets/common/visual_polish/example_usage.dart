/// Example usage of visual polish components
/// This file demonstrates how to use each component
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'visual_polish_components.dart';

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
            SizedBox(height: 16.h),
            Row(
              children: [
                const StatusIndicator(
                  isActive: true,
                  activeLabel: 'Online',
                ),
                SizedBox(width: 24.w),
                const StatusIndicator(
                  isActive: false,
                  inactiveLabel: 'Offline',
                ),
              ],
            ),
            SizedBox(height: 32.h),

            // Animated Badge Examples
            const Text('Animated Badges:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16.h),
            Row(
              children: [
                AnimatedBadge(
                  label: 'Premium',
                  icon: Icons.star,
                  onTap: () => print('Premium badge tapped'),
                ),
                SizedBox(width: 16.w),
                const AnimatedBadge(
                  label: 'New',
                  isNew: true,
                  icon: Icons.new_releases,
                ),
              ],
            ),
            SizedBox(height: 32.h),

            // Premium Progress Indicator
            const Text('Progress Indicators:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16.h),
            const PremiumProgressIndicator(
              value: 0.65,
              showPercentage: true,
              label: 'Upload Progress',
            ),
            SizedBox(height: 32.h),

            // Animated Dividers
            const Text('Dividers:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16.h),
            const AnimatedDivider(),
            const AnimatedDivider(
              style: DividerStyle.primary,
              height: 2,
            ),
            SizedBox(height: 32.h),

            // Floating Tooltip
            const Text('Floating Tooltip:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16.h),
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