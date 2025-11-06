/// Onboarding Analytics Page Widget
///
/// Third page of the onboarding - monitoring and analytics features
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'onboarding_stat_card.dart';

/// Analytics and monitoring page widget for onboarding
class OnboardingAnalyticsPage extends StatelessWidget {
  /// Whether to use compact sizing
  final bool isCompact;

  const OnboardingAnalyticsPage({
    super.key,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF16213E),
            HvacColors.backgroundDark,
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 24 : 40,
                vertical: isCompact ? 20 : 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    width: isCompact ? 80 : 120,
                    height: isCompact ? 80 : 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.analytics,
                      size: isCompact ? 50 : 70,
                      color: const Color(0xFF9C27B0),
                    ),
                  ),
                  SizedBox(height: isCompact ? 30 : 50),

                  // Title
                  Text(
                    'Monitor & Analyze',
                    style: TextStyle(
                      fontSize: isCompact ? 28 : 36,
                      fontWeight: FontWeight.bold,
                      color: HvacColors.textPrimary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isCompact ? 12 : 20),

                  // Subtitle
                  Text(
                    'Track energy usage and climate stats',
                    style: TextStyle(
                      fontSize: isCompact ? 14 : 16,
                      color: HvacColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isCompact ? 30 : 40),

                  // Statistics Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OnboardingStatCard(
                        value: '24°C',
                        label: 'Temp',
                        icon: Icons.thermostat,
                        isCompact: isCompact,
                      ),
                      OnboardingStatCard(
                        value: '65%',
                        label: 'Humidity',
                        icon: Icons.water_drop,
                        isCompact: isCompact,
                      ),
                      OnboardingStatCard(
                        value: '45',
                        label: 'Quality',
                        icon: Icons.air,
                        isCompact: isCompact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}