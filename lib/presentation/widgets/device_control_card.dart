/// Device Control Card
///
/// Large card for controlling individual devices
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
        padding: const EdgeInsets.all(HvacSpacing.xlR),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: HvacColors.backgroundCardBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: HvacTypography.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: HvacTypography.labelLarge.copyWith(
                        color: HvacColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: HvacColors.warning.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: HvacColors.warning,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Device Image/Visual
            if (deviceImage != null)
              Center(
                child: SizedBox(
                  height: 120,
                  child: deviceImage,
                ),
              ),

            const Spacer(),

            // Controls
            if (controls.isNotEmpty) ...controls,

            const SizedBox(height: 16),

            // Stats
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

/// Stat item for device cards
class DeviceStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DeviceStatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: HvacColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: HvacTypography.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: HvacTypography.labelMedium.copyWith(
            color: HvacColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

/// Temperature control widget (for AC)
class TemperatureControl extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;

  const TemperatureControl({
    super.key,
    required this.value,
    this.min = 15,
    this.max = 29,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            min.toInt().toString(),
            style: HvacTypography.bodyMedium.copyWith(
              color: HvacColors.textTertiary,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    '${value.toInt()}°',
                    style: HvacTypography.displayLarge.copyWith(
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16,
                      ),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: HvacColors.backgroundCardBorder,
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      value: value,
                      min: min,
                      max: max,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            max.toInt().toString(),
            style: HvacTypography.bodyMedium.copyWith(
              color: HvacColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Brightness control (for lamps)
class BrightnessControl extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const BrightnessControl({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: HvacColors.backgroundDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.lightbulb_outline,
            size: 20,
            color: HvacColors.textSecondary,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 6,
                ),
                activeTrackColor: HvacColors.warning,
                inactiveTrackColor: HvacColors.backgroundCardBorder,
                thumbColor: Colors.white,
              ),
              child: Slider(
                value: value,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        Text(
          '${(value * 100).toInt()}%',
          style: HvacTypography.titleLarge,
        ),
      ],
    );
  }
}
