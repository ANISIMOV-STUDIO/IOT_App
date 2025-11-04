/// Onboarding Screen with Liquid Swipe
///
/// First-time user experience with smooth liquid swipe navigation
library;

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'responsive_shell.dart';

/// Onboarding screen for first-time users
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final LiquidController _liquidController = LiquidController();
  int _currentPage = 0;
  static const int _totalPages = 4;

  @override
  void dispose() {
    // LiquidController doesn't need manual disposal
    super.dispose();
  }

  /// Mark onboarding as completed and navigate to home
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;

    // Navigate to home screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ResponsiveShell(),
      ),
    );
  }

  /// Skip onboarding
  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      body: Stack(
        children: [
          // Liquid Swipe Pages
          HvacLiquidSwipe(
            pages: [
              _buildWelcomePage(),
              _buildControlPage(),
              _buildAnalyticsPage(),
              _buildGetStartedPage(),
            ],
            controller: _liquidController,
            enableLoop: false,
            waveType: WaveType.liquidReveal,
            onPageChangeCallback: (index) {
              setState(() => _currentPage = index);
            },
          ),

          // Skip Button (only on first 3 pages)
          if (_currentPage < _totalPages - 1)
            Positioned(
              top: 50,
              right: 20,
              child: SafeArea(
                child: TextButton(
                  onPressed: _skipOnboarding,
                  style: TextButton.styleFrom(
                    foregroundColor: HvacColors.textSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

          // Page Indicators (only on first 3 pages)
          if (_currentPage < _totalPages - 1)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _totalPages - 1,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? HvacColors.primaryOrange
                          : HvacColors.textSecondary.withValues(alpha:0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Page 1: Welcome
  Widget _buildWelcomePage() {
    return Container(
      color: HvacColors.backgroundDark,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: HvacColors.primaryOrange.withValues(alpha:0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.air,
                  size: 100,
                  color: HvacColors.primaryOrange,
                ),
              ),
              const SizedBox(height: 60),

              // Title
              const Text(
                'Welcome to\nHVAC Control',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: HvacColors.textPrimary,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Subtitle
              const Text(
                'Your smart home climate control\nat your fingertips',
                style: TextStyle(
                  fontSize: 18,
                  color: HvacColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),

              // Swipe hint
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Swipe to continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: HvacColors.textSecondary.withValues(alpha:0.6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: HvacColors.textSecondary.withValues(alpha:0.6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Page 2: Control Devices
  Widget _buildControlPage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1D2E),
            HvacColors.backgroundDark,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: HvacColors.primaryBlue.withValues(alpha:0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.devices,
                  size: 100,
                  color: HvacColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 60),

              // Title
              const Text(
                'Control Your\nDevices',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: HvacColors.textPrimary,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Subtitle
              const Text(
                'Manage all your HVAC systems\nfrom anywhere, anytime',
                style: TextStyle(
                  fontSize: 18,
                  color: HvacColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              // Features
              _buildFeatureRow(
                Icons.power_settings_new,
                'Turn on/off remotely',
              ),
              const SizedBox(height: 20),
              _buildFeatureRow(
                Icons.thermostat,
                'Adjust temperature',
              ),
              const SizedBox(height: 20),
              _buildFeatureRow(
                Icons.schedule,
                'Set schedules',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Page 3: Analytics & Monitoring
  Widget _buildAnalyticsPage() {
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
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withValues(alpha:0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.analytics,
                  size: 100,
                  color: Color(0xFF9C27B0),
                ),
              ),
              const SizedBox(height: 60),

              // Title
              const Text(
                'Monitor Energy\nConsumption',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: HvacColors.textPrimary,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Subtitle
              const Text(
                'Track your energy usage and\nsave on electricity bills',
                style: TextStyle(
                  fontSize: 18,
                  color: HvacColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              // Statistics Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard('24°C', 'Temperature', Icons.thermostat),
                  _buildStatCard('65%', 'Humidity', Icons.water_drop),
                  _buildStatCard('45', 'Air Quality', Icons.air),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Page 4: Get Started
  Widget _buildGetStartedPage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HvacColors.primaryOrange.withValues(alpha:0.1),
            HvacColors.backgroundDark,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: HvacColors.success.withValues(alpha:0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 100,
                  color: HvacColors.success,
                ),
              ),
              const SizedBox(height: 60),

              // Title
              const Text(
                'Ready to\nGet Started?',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: HvacColors.textPrimary,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Subtitle
              const Text(
                'Start controlling your home climate\nwith ease and efficiency',
                style: TextStyle(
                  fontSize: 18,
                  color: HvacColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),

              // Get Started Button
              HvacNeumorphicButton(
                onPressed: _completeOnboarding,
                width: double.infinity,
                height: 60,
                borderRadius: 30,
                color: HvacColors.primaryOrange,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: HvacColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.arrow_forward,
                      color: HvacColors.textPrimary,
                      size: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Terms & Privacy
              Text(
                'By continuing, you agree to our\nTerms of Service and Privacy Policy',
                style: TextStyle(
                  fontSize: 12,
                  color: HvacColors.textSecondary.withValues(alpha:0.6),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Feature row widget
  Widget _buildFeatureRow(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: HvacColors.primaryOrange.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: HvacColors.primaryOrange,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: HvacColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Statistic card widget
  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF9C27B0),
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: HvacColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
