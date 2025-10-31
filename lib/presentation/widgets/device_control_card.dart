/// Device Control Card
///
/// Large card for controlling individual devices
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.backgroundCardBorder,
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: AppTheme.warning,
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
              color: AppTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textTertiary,
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
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textTertiary,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    '${value.toInt()}°',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
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
                      inactiveTrackColor: AppTheme.backgroundCardBorder,
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
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textTertiary,
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
            color: AppTheme.backgroundDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.lightbulb_outline,
            size: 20,
            color: AppTheme.textSecondary,
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
                activeTrackColor: AppTheme.warning,
                inactiveTrackColor: AppTheme.backgroundCardBorder,
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
