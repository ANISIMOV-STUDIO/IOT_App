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
        padding: EdgeInsets.all(HvacSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Standard Glassmorphic Card'),
            GlassmorphicCard(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: HvacSpacing.md.h),
              onTap: () => debugPrint('Glassmorphic card tapped'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temperature Control',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: HvacColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: HvacSpacing.sm.h),
                  Text(
                    'Set your preferred temperature',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: HvacColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Elevated Glassmorphic Card'),
            ElevatedGlassmorphicCard(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: HvacSpacing.md.h),
              child: Row(
                children: [
                  Icon(
                    Icons.ac_unit,
                    size: 32.sp,
                    color: HvacColors.primaryBlue,
                  ),
                  SizedBox(width: HvacSpacing.md.w),
                  Expanded(
                    child: Text(
                      'Cooling Mode Active',
                      style: TextStyle(
                        fontSize: 16.sp,
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
              margin: EdgeInsets.only(bottom: HvacSpacing.md.h),
              onTap: () => debugPrint('Gradient card tapped'),
              child: Text(
                'Premium Feature',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            _buildSectionTitle('Neumorphic Cards'),
            Row(
              children: [
                Expanded(
                  child: NeumorphicCard(
                    margin: EdgeInsets.only(right: HvacSpacing.sm.w),
                    child: Center(
                      child: Text(
                        'Standard',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SoftNeumorphicCard(
                    margin: EdgeInsets.symmetric(horizontal: HvacSpacing.xs.w),
                    child: Center(
                      child: Text(
                        'Soft',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ConcaveNeumorphicCard(
                    margin: EdgeInsets.only(left: HvacSpacing.sm.w),
                    child: Center(
                      child: Text(
                        'Concave',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: HvacSpacing.md.h),

            _buildSectionTitle('Glow Cards'),
            GlowCard(
              width: double.infinity,
              glowColor: HvacColors.primaryOrange,
              margin: EdgeInsets.only(bottom: HvacSpacing.md.h),
              onTap: () => debugPrint('Glow card tapped'),
              child: Text(
                'Animated Glow Effect',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: HvacColors.textPrimary,
                ),
              ),
            ),

            StaticGlowCard(
              width: double.infinity,
              glowColor: HvacColors.primaryBlue,
              margin: EdgeInsets.only(bottom: HvacSpacing.md.h),
              child: Text(
                'Static Glow (Better Performance)',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: HvacColors.textPrimary,
                ),
              ),
            ),

            NeonGlowCard(
              width: double.infinity,
              neonColor: HvacColors.primaryBlue,
              margin: EdgeInsets.only(bottom: HvacSpacing.md.h),
              child: Text(
                'Neon Glow Effect',
                style: TextStyle(
                  fontSize: 16.sp,
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
                height: 200.h,
                padding: EdgeInsets.all(HvacSpacing.lg.w),
                child: Center(
                  child: Text(
                    'Animated Background',
                    style: TextStyle(
                      fontSize: 24.sp,
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
      padding: EdgeInsets.symmetric(vertical: HvacSpacing.md.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: HvacColors.textPrimary,
        ),
      ),
    );
  }
}