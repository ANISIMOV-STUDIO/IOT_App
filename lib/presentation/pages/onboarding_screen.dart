/// Onboarding Screen with Liquid Swipe
///
/// Compact and beautiful first-time user experience
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../generated/l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Onboarding screen for first-time users
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final LiquidController _liquidController = LiquidController();
  int _currentPage = 0;
  static const int _totalPages = 4;

  late AnimationController _swipeHintController;
  late Animation<Offset> _swipeHintAnimation;

  @override
  void initState() {
    super.initState();
    _setupSwipeHintAnimation();
  }

  void _setupSwipeHintAnimation() {
    _swipeHintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _swipeHintAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0),
    ).animate(
      CurvedAnimation(
        parent: _swipeHintController,
        curve: Curves.easeInOut,
      ),
    );

    // Loop the animation
    _swipeHintController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _swipeHintController.dispose();
    super.dispose();
  }

  /// Mark onboarding as completed and navigate to home
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;

    // Skip auth and go home
    context.read<AuthBloc>().add(const SkipAuthEvent());
  }

  /// Skip onboarding
  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isCompact = size.height < 700 || size.width < 600;

    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      body: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: Stack(
          children: [
            // Liquid Swipe Pages
            HvacLiquidSwipe(
              pages: [
                _buildWelcomePage(l10n, isCompact),
                _buildControlPage(l10n, isCompact),
                _buildAnalyticsPage(l10n, isCompact),
                _buildGetStartedPage(l10n, isCompact),
              ],
              controller: _liquidController,
              enableLoop: false,
              waveType: WaveType.liquidReveal,
              onPageChangeCallback: (index) {
                HapticFeedback.selectionClick();
                setState(() => _currentPage = index);
              },
            ),

            // Skip Button (only on first 3 pages)
            if (_currentPage < _totalPages - 1)
              Positioned(
                top: 40,
                right: 20,
                child: SafeArea(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: HvacInteractiveScale(
                      scaleDown: 0.95,
                      child: TextButton(
                        onPressed: _skipOnboarding,
                        style: TextButton.styleFrom(
                          foregroundColor: HvacColors.textSecondary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          l10n.skip,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Animated Swipe Hint (only on first page)
            if (_currentPage == 0)
              Positioned(
                bottom: isCompact ? 100 : 140,
                left: 0,
                right: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: SlideTransition(
                    position: _swipeHintAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: HvacColors.primaryOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: HvacColors.primaryOrange.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.swipe,
                                size: 20,
                                color: HvacColors.primaryOrange,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.swipeToContinue,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: HvacColors.primaryOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: HvacColors.primaryOrange,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Page Indicators (only on first 3 pages)
            if (_currentPage < _totalPages - 1)
              Positioned(
                bottom: isCompact ? 50 : 80,
                left: 0,
                right: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.basic,
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
                              : HvacColors.textSecondary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
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

  /// Page 1: Welcome
  Widget _buildWelcomePage(AppLocalizations l10n, bool isCompact) {
    return Container(
      color: HvacColors.backgroundDark,
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
                  // Icon with glow effect
                  Container(
                    width: isCompact ? 80 : 120,
                    height: isCompact ? 80 : 120,
                    decoration: BoxDecoration(
                      color: HvacColors.primaryOrange.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: HvacColors.primaryOrange.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.air,
                      size: isCompact ? 50 : 70,
                      color: HvacColors.primaryOrange,
                    ),
                  ),
                  SizedBox(height: isCompact ? 30 : 50),

                  // Title with BREEZ HOME
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: isCompact ? 28 : 36,
                        fontWeight: FontWeight.bold,
                        color: HvacColors.textPrimary,
                        height: 1.2,
                      ),
                      children: const [
                        TextSpan(text: 'Welcome to\n'),
                        TextSpan(
                          text: 'BREEZ ',
                          style: TextStyle(
                            color: HvacColors.primaryOrange,
                          ),
                        ),
                        TextSpan(text: 'HOME'),
                      ],
                    ),
                  ),
                  SizedBox(height: isCompact ? 12 : 20),

                  // Subtitle
                  Text(
                    l10n.smartHomeClimateControl,
                    style: TextStyle(
                      fontSize: isCompact ? 14 : 16,
                      color: HvacColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Page 2: Control Devices
  Widget _buildControlPage(AppLocalizations l10n, bool isCompact) {
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
                      color: HvacColors.primaryBlue.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: HvacColors.primaryBlue.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.devices,
                      size: isCompact ? 50 : 70,
                      color: HvacColors.primaryBlue,
                    ),
                  ),
                  SizedBox(height: isCompact ? 30 : 50),

                  // Title
                  Text(
                    l10n.controlYourDevices,
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
                    l10n.manageHvacSystems,
                    style: TextStyle(
                      fontSize: isCompact ? 14 : 16,
                      color: HvacColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isCompact ? 24 : 40),

                  // Features (compact)
                  _buildFeatureRow(Icons.power_settings_new, l10n.turnOnOffRemotely, isCompact),
                  SizedBox(height: isCompact ? 10 : 12),
                  _buildFeatureRow(Icons.thermostat, 'Adjust temperature', isCompact),
                  SizedBox(height: isCompact ? 10 : 12),
                  _buildFeatureRow(Icons.schedule, 'Set schedules', isCompact),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Page 3: Analytics & Monitoring
  Widget _buildAnalyticsPage(AppLocalizations l10n, bool isCompact) {
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
                      _buildStatCard('24°C', 'Temp', Icons.thermostat, isCompact),
                      _buildStatCard('65%', 'Humidity', Icons.water_drop, isCompact),
                      _buildStatCard('45', 'Quality', Icons.air, isCompact),
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

  /// Page 4: Get Started
  Widget _buildGetStartedPage(AppLocalizations l10n, bool isCompact) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HvacColors.primaryOrange.withValues(alpha: 0.1),
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
                      color: HvacColors.success.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: HvacColors.success.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: isCompact ? 50 : 70,
                      color: HvacColors.success,
                    ),
                  ),
                  SizedBox(height: isCompact ? 30 : 50),

                  // Title
                  Text(
                    l10n.readyToGetStarted,
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
                    l10n.startControllingClimate,
                    style: TextStyle(
                      fontSize: isCompact ? 14 : 16,
                      color: HvacColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isCompact ? 40 : 60),

                  // Get Started Button
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: HvacInteractiveScale(
                      scaleDown: 0.98,
                      child: HvacNeumorphicButton(
                        onPressed: _completeOnboarding,
                        width: double.infinity,
                        height: isCompact ? 52 : 56,
                        borderRadius: 30,
                        color: HvacColors.primaryOrange,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.getStarted,
                              style: TextStyle(
                                fontSize: isCompact ? 15 : 17,
                                fontWeight: FontWeight.bold,
                                color: HvacColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.arrow_forward,
                              color: HvacColors.textPrimary,
                              size: isCompact ? 18 : 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isCompact ? 20 : 30),

                  // Terms & Privacy
                  Text(
                    l10n.termsPrivacyAgreement,
                    style: TextStyle(
                      fontSize: isCompact ? 10 : 11,
                      color: HvacColors.textSecondary.withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Feature row widget (compact)
  Widget _buildFeatureRow(IconData icon, String text, bool isCompact) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isCompact ? 40 : 48,
            height: isCompact ? 40 : 48,
            decoration: BoxDecoration(
              color: HvacColors.primaryOrange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: HvacColors.primaryOrange,
              size: isCompact ? 20 : 24,
            ),
          ),
          SizedBox(width: isCompact ? 12 : 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isCompact ? 14 : 16,
                color: HvacColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Statistic card widget (compact)
  Widget _buildStatCard(String value, String label, IconData icon, bool isCompact) {
    return Container(
      width: isCompact ? 90 : 100,
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF9C27B0),
            size: isCompact ? 24 : 32,
          ),
          SizedBox(height: isCompact ? 8 : 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isCompact ? 18 : 24,
              fontWeight: FontWeight.bold,
              color: HvacColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isCompact ? 10 : 11,
              color: HvacColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
