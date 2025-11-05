/// Device Control Card
///
/// Responsive large card for controlling individual devices
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(HvacSpacing.lgR),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(HvacRadius.xlR),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
          ),
        ),
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
                        color: HvacColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: HvacSpacing.xxsR),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: HvacColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: HvacColors.warning.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.circle,
                      size: 8.0,
                      color: HvacColors.warning,
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
            const SizedBox(height: HvacSpacing.mdR),
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
