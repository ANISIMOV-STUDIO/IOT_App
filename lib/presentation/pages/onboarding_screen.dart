/// Onboarding Screen with Liquid Swipe
///
/// Orchestrates the onboarding experience with extracted components
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generated/l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';
import '../widgets/onboarding/onboarding_welcome_page.dart';
import '../widgets/onboarding/onboarding_control_page.dart';
import '../widgets/onboarding/onboarding_analytics_page.dart';
import '../widgets/onboarding/onboarding_get_started_page.dart';
import '../widgets/onboarding/onboarding_page_indicators.dart';
import '../widgets/onboarding/onboarding_skip_button.dart';
import '../widgets/onboarding/onboarding_swipe_hint.dart';

/// Onboarding screen for first-time users
///
/// Orchestrates the onboarding flow using extracted, reusable components
/// following SOLID principles and clean architecture
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 4;

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
    _completeOnboarding();
  }

  /// Handle page change
  void _onPageChanged(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentPage = index);
  }

  /// Build list of onboarding pages
  List<Widget> _buildPages(bool isCompact) {
    return [
      OnboardingWelcomePage(isCompact: isCompact),
      OnboardingControlPage(isCompact: isCompact),
      OnboardingAnalyticsPage(isCompact: isCompact),
      OnboardingGetStartedPage(
        isCompact: isCompact,
        onGetStarted: _completeOnboarding,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isCompact = size.height < 700 || size.width < 600;

    return Scaffold(
      backgroundColor: HvacColors.backgroundSecondary,
      body: Stack(
        children: [
          // PageView for onboarding pages
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: _buildPages(isCompact),
          ),

          // Skip Button (only on first 3 pages)
          if (_currentPage < _totalPages - 1)
            OnboardingSkipButton(
              onSkip: _skipOnboarding,
              skipText: l10n.skip,
            ),

          // Animated Swipe Hint (only on first page)
          if (_currentPage == 0)
            OnboardingSwipeHint(
              isCompact: isCompact,
              hintText: l10n.swipeToContinue,
            ),

          // Page Indicators (only on first 3 pages)
          if (_currentPage < _totalPages - 1)
            OnboardingPageIndicators(
              currentPage: _currentPage,
              totalPages: _totalPages - 1,
              isCompact: isCompact,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
