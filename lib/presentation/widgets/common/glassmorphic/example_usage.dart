/// Example Usage of Glassmorphic Components
/// Demonstrates all card variants with responsive design
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'glassmorphic.dart';

/// Example screen showing all glassmorphic card variants
class GlassmorphicExampleScreen extends StatelessWidget {
  const GlassmorphicExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(HvacSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Standard Glassmorphic Card'),
            GlassmorphicCard(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: HvacSpacing.md),
              onTap: () => debugPrint('Glassmorphic card tapped'),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temperature Control',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: HvacColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: HvacSpacing.sm),
                  Text(
                    'Set your preferred temperature',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: HvacColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Elevated Glassmorphic Card'),
            const ElevatedGlassmorphicCard(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: HvacSpacing.md),
              child: Row(
                children: [
                  Icon(
                    Icons.ac_unit,
                    size: 32.0,
                    color: HvacColors.primaryBlue,
                  ),
                  SizedBox(width: HvacSpacing.md),
                  Expanded(
                    child: Text(
                      'Cooling Mode Active',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: HvacColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Gradient Card'),
            GradientCard(
              width: double.infinity,
              colors: const [HvacColors.primaryBlue, HvacColors.primaryOrange],
              margin: const EdgeInsets.only(bottom: HvacSpacing.md),
              onTap: () => debugPrint('Gradient card tapped'),
              child: const Text(
                'Premium Feature',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            _buildSectionTitle('Neumorphic Cards'),
            const Row(
              children: [
                Expanded(
                  child: NeumorphicCard(
                    margin: EdgeInsets.only(right: HvacSpacing.sm),
                    child: Center(
                      child: Text(
                        'Standard',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SoftNeumorphicCard(
                    margin: EdgeInsets.symmetric(horizontal: HvacSpacing.xs),
                    child: Center(
                      child: Text(
                        'Soft',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ConcaveNeumorphicCard(
                    margin: EdgeInsets.only(left: HvacSpacing.sm),
                    child: Center(
                      child: Text(
                        'Concave',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: HvacSpacing.md),

            _buildSectionTitle('Glow Cards'),
            GlowCard(
              width: double.infinity,
              glowColor: HvacColors.primaryOrange,
              margin: const EdgeInsets.only(bottom: HvacSpacing.md),
              onTap: () => debugPrint('Glow card tapped'),
              child: const Text(
                'Animated Glow Effect',
                style: TextStyle(
                  fontSize: 16.0,
                  color: HvacColors.textPrimary,
                ),
              ),
            ),

            const StaticGlowCard(
              width: double.infinity,
              glowColor: HvacColors.primaryBlue,
              margin: EdgeInsets.only(bottom: HvacSpacing.md),
              child: Text(
                'Static Glow (Better Performance)',
                style: TextStyle(
                  fontSize: 16.0,
                  color: HvacColors.textPrimary,
                ),
              ),
            ),

            const NeonGlowCard(
              width: double.infinity,
              neonColor: HvacColors.primaryBlue,
              margin: EdgeInsets.only(bottom: HvacSpacing.md),
              child: Text(
                'Neon Glow Effect',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: HvacColors.textPrimary,
                ),
              ),
            ),

            _buildSectionTitle('Animated Gradient Background'),
            AnimatedGradientBackground(
              colors: const [
                HvacColors.primaryBlue,
                HvacColors.primaryOrange,
                HvacColors.info,
              ],
              child: Container(
                height: 200.0,
                padding: const EdgeInsets.all(HvacSpacing.lg),
                child: const Center(
                  child: Text(
                    'Animated Background',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: HvacSpacing.md),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: HvacColors.textPrimary,
        ),
      ),
    );
  }
}