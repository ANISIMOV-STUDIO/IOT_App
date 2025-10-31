/// Device Card Widget
///
/// Display device information in a card format
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppTheme.deviceCard(isSelected: isSelected),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Device Image or Icon
            Container(
              width: 80,
              height: 80,
              decoration: AppTheme.deviceImagePlaceholder(),
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            icon,
                            size: 40,
                            color: AppTheme.textSecondary,
                          );
                        },
                      ),
                    )
                  : Icon(
                      icon,
                      size: 40,
                      color: AppTheme.textSecondary,
                    ),
            ),
            const SizedBox(height: 12),

            // Device Name
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

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
    final modeColor = AppTheme.getModeColor(mode);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppTheme.deviceCard(),
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
                      color: AppTheme.backgroundCard,
                      child: const Icon(
                        Icons.thermostat,
                        size: 48,
                        color: AppTheme.textTertiary,
                      ),
                    );
                  },
                ),
              ),

            // Device Info
            Padding(
              padding: const EdgeInsets.all(16),
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
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

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
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: modeColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: modeColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          mode.toUpperCase(),
                          style: TextStyle(
                            color: modeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
