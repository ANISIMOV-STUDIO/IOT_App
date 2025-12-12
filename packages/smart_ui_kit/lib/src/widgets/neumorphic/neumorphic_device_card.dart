import 'package:flutter/material.dart';
import 'neumorphic_theme_wrapper.dart';
import '../../theme/tokens/neumorphic_spacing.dart';
import 'neumorphic_compat.dart';

/// Neumorphic Device Card - Smart home device tile
class NeumorphicDeviceCard extends StatelessWidget {
  final String name;
  final String? subtitle;
  final IconData icon;
  final bool isOn;
  final ValueChanged<bool>? onToggle;
  final String? powerConsumption;
  final VoidCallback? onTap;

  const NeumorphicDeviceCard({
    super.key,
    required this.name,
    this.subtitle,
    required this.icon,
    required this.isOn,
    this.onToggle,
    this.powerConsumption,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);

    return NeumorphicInteractiveCard(
      onTap: onTap,
      padding: const EdgeInsets.all(NeumorphicSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top row: Icon + Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isOn 
                      ? NeumorphicColorsData.accent.withValues(alpha: 0.1)
                      : theme.colors.surface,
                  borderRadius: BorderRadius.circular(NeumorphicSpacing.radiusSm),
                  boxShadow: theme.shadows.flat,
                ),
                child: Icon(
                  icon,
                  color: isOn 
                      ? NeumorphicColorsData.accent 
                      : theme.colors.textTertiary,
                  size: NeumorphicSpacing.deviceIconSize,
                ),
              ),
              
              // Toggle
              NeumorphicToggle(
                value: isOn,
                onChanged: onToggle,
              ),
            ],
          ),
          
          const Spacer(),
          
          // Bottom: Name, subtitle, power
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.typography.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: NeumorphicSpacing.xxs),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Subtitle/status
                  if (subtitle != null)
                    Expanded(
                      child: Text(
                        subtitle!,
                        style: theme.typography.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  
                  // Power consumption
                  if (powerConsumption != null)
                    Row(
                      children: [
                        Text(
                          '—',
                          style: theme.typography.bodySmall.copyWith(
                            color: theme.colors.textTertiary,
                          ),
                        ),
                        const SizedBox(width: NeumorphicSpacing.xs),
                        Text(
                          powerConsumption!,
                          style: theme.typography.numericSmall.copyWith(
                            color: NeumorphicColorsData.accent,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Grid of device cards
class NeumorphicDeviceGrid extends StatelessWidget {
  final List<NeumorphicDeviceCard> devices;
  final int crossAxisCount;
  final double spacing;
  final double childAspectRatio;

  const NeumorphicDeviceGrid({
    super.key,
    required this.devices,
    this.crossAxisCount = 3,
    this.spacing = NeumorphicSpacing.cardGap,
    this.childAspectRatio = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: devices.length,
      itemBuilder: (context, index) => devices[index],
    );
  }
}
