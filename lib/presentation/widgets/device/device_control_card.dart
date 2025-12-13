/// Device Control Card
///
/// Responsive large card for controlling individual devices
library;

import 'package:flutter/material.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';

enum DeviceType { lamp, airConditioner, vacuum, other }

class DeviceControlCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final DeviceType type;
  final Widget? deviceImage;
  final List<Widget> controls;
  final List<Widget> stats;
  final VoidCallback? onTap;

  const DeviceControlCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.type,
    this.deviceImage,
    this.controls = const [],
    this.stats = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(NeumorphicSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: NeumorphicColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: NeumorphicSpacing.xxs),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: NeumorphicColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: NeumorphicColors.accentWarning.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.circle,
                      size: 8.0,
                      color: NeumorphicColors.accentWarning,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (deviceImage != null)
              Center(
                child: SizedBox(
                  height: 120.0,
                  child: deviceImage,
                ),
              ),
            const Spacer(),
            if (controls.isNotEmpty) ...controls,
            const SizedBox(height: NeumorphicSpacing.md),
            if (stats.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: stats,
              ),
          ],
        ),
      ),
    );
  }
}
