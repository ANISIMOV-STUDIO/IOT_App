/// Device Control Card
///
/// Responsive large card for controlling individual devices
library;

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../core/theme/app_theme.dart';

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
    final theme = ShadTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: ShadCard(
        padding: const EdgeInsets.all(24),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.foreground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (deviceImage != null)
              Center(
                child: SizedBox(
                  height: 120,
                  child: deviceImage,
                ),
              ),
            const Spacer(),
            if (controls.isNotEmpty) ...controls,
            const SizedBox(height: 16),
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
