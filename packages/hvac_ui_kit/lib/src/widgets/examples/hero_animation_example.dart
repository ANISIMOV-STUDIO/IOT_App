/// Example usage of HvacHeroAnimations
library;

import 'package:flutter/material.dart';
import '../../animations/hvac_hero_animations.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

class HeroAnimationExample extends StatelessWidget {
  const HeroAnimationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(title: const Text('Hero Animations')),
      body: ListView(
        padding: const EdgeInsets.all(HvacSpacing.md),
        children: [
          const Text('Tap cards to see Hero animations:',
              style: TextStyle(color: HvacColors.textSecondary)),
          const SizedBox(height: HvacSpacing.lg),
          _buildDeviceCard(
            context,
            'Living Room AC',
            '24°C',
            'device_1',
          ),
          const SizedBox(height: HvacSpacing.md),
          _buildDeviceCard(
            context,
            'Bedroom Heater',
            '22°C',
            'device_2',
          ),
          const SizedBox(height: HvacSpacing.md),
          _buildDeviceCard(
            context,
            'Kitchen Fan',
            '21°C',
            'device_3',
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(
    BuildContext context,
    String name,
    String temperature,
    String tag,
  ) {
    return GestureDetector(
      onTap: () {
        HvacHeroHelper.navigateWithHero(
          context,
          _DetailScreen(name: name, temperature: temperature, tag: tag),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(HvacSpacing.md),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: HvacRadius.mdRadius,
          border: Border.all(color: HvacColors.backgroundCardBorder),
        ),
        child: Row(
          children: [
            HvacHeroHelper.createHero(
              tag: 'icon_$tag',
              child: const Icon(
                Icons.device_thermostat,
                size: 40,
                color: HvacColors.primaryOrange,
              ),
            ),
            const SizedBox(width: HvacSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HvacHeroHelper.createHero(
                    tag: 'name_$tag',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: HvacSpacing.xxs),
                  const Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 14,
                      color: HvacColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            HvacHeroHelper.createHero(
              tag: 'temp_$tag',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  temperature,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: HvacColors.primaryOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailScreen extends StatelessWidget {
  final String name;
  final String temperature;
  final String tag;

  const _DetailScreen({
    required this.name,
    required this.temperature,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(title: const Text('Device Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HvacHeroHelper.createHero(
              tag: 'icon_$tag',
              child: const Icon(
                Icons.device_thermostat,
                size: 120,
                color: HvacColors.primaryOrange,
              ),
            ),
            const SizedBox(height: HvacSpacing.xl),
            HvacHeroHelper.createHero(
              tag: 'name_$tag',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: HvacSpacing.lg),
            HvacHeroHelper.createHero(
              tag: 'temp_$tag',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  temperature,
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: HvacColors.primaryOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
