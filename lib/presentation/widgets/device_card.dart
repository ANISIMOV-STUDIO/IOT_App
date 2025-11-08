/// Device Card Widget
///
/// Display device information in a card format
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class DeviceCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final IconData icon;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isSelected;

  const DeviceCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.icon,
    this.imageUrl,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return HvacCard(
      onTap: onTap,
      size: HvacCardSize.large,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Device Image or Icon
          Container(
            width: 80,
            height: 80,
            decoration: HvacTheme.deviceImagePlaceholder(),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: HvacRadius.mdRadius,
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          icon,
                          size: 40,
                          color: HvacColors.textSecondary,
                        );
                      },
                    ),
                  )
                : Icon(
                    icon,
                    size: 40,
                    color: HvacColors.textSecondary,
                  ),
          ),
          const SizedBox(height: HvacSpacing.sm),

          // Device Name
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: HvacSpacing.xxs),

          // Device Subtitle
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Device Card with Status (for home screen)
class DeviceStatusCard extends StatelessWidget {
  final String name;
  final String location;
  final String mode;
  final double temperature;
  final String? imageUrl;
  final VoidCallback? onTap;

  const DeviceStatusCard({
    super.key,
    required this.name,
    required this.location,
    required this.mode,
    required this.temperature,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final modeColor = HvacColors.getModeColor(mode);

    return HvacCard(
      onTap: onTap,
      size: HvacCardSize.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Image (if available)
          if (imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl!,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: HvacColors.backgroundCard,
                    child: const Icon(
                      Icons.thermostat,
                      size: 48,
                      color: HvacColors.textTertiary,
                    ),
                  );
                },
              ),
            ),

          // Device Info
          Padding(
            padding: const EdgeInsets.all(HvacSpacing.lgR),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Location
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: HvacSpacing.xxs),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: HvacSpacing.md),

                // Temperature and Mode
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Temperature
                    Text(
                      '${temperature.toInt()}°',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),

                    // Mode Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: HvacSpacing.mdR,
                        vertical: HvacSpacing.xsR,
                      ),
                      decoration: HvacDecorations.modeBadge(
                        modeColor: modeColor,
                      ),
                      child: Text(
                        mode.toUpperCase(),
                        style: HvacTypography.caption.copyWith(
                          color: modeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
