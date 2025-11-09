/// Settings Screen - Refactored with Responsive Design
///
/// App settings with responsive layout and extracted sections
/// Compliant with 300-line limit and SOLID principles
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart' as ui_kit;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../core/services/language_service.dart';
import '../../widgets/settings/appearance_section.dart';
import '../../widgets/settings/units_section.dart';
import '../../widgets/settings/notifications_section.dart';
import '../../widgets/settings/language_section.dart';
import '../../widgets/settings/about_section.dart';
import '../../widgets/settings/settings_sidebar.dart';
import 'settings_controller.dart';

/// Settings Screen - UI Only (Following SOLID principles)
class SettingsScreenRefactored extends StatefulWidget {
  const SettingsScreenRefactored({super.key});

  @override
  State<SettingsScreenRefactored> createState() =>
      _SettingsScreenRefactoredState();
}

class _SettingsScreenRefactoredState extends State<SettingsScreenRefactored>
    with SingleTickerProviderStateMixin {
  late final SettingsController _controller;
  late AnimationController _themeAnimationController;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _themeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  Future<void> _initializeController() async {
    final prefs = await SharedPreferences.getInstance();
    _controller = SettingsController(
      onSettingChanged: _handleSettingChanged,
      prefs: prefs,
      languageService: di.sl<LanguageService>(),
    );
  }

  @override
  void dispose() {
    _themeAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize responsive system
    ui_kit.responsive.init(context);
    final l10n = AppLocalizations.of(context)!;

    return ui_kit.ResponsiveInit(
      child: Scaffold(
        backgroundColor: ui_kit.HvacColors.backgroundSecondary,
        appBar: _buildAppBar(l10n),
        body: SafeArea(
          child: _buildResponsiveLayout(l10n),
        ),
      ),
    );
  }

  /// App Bar with responsive sizing
  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return ui_kit.HvacAppBar(
      backgroundColor: ui_kit.HvacColors.backgroundCard,
      leading: ui_kit.HvacIconButton(
        icon: Icons.arrow_back,
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        l10n.settingsTitle,
        style: ui_kit.HvacTypography.headlineMedium.copyWith(
          fontSize: 20,
          color: ui_kit.HvacColors.textPrimary,
        ),
      ),
      actions: [
        // Save button for tablet/desktop
        if (ui_kit.responsive.isTablet || ui_kit.responsive.isDesktop)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ui_kit.HvacTextButton(
              onPressed: _saveSettings,
              label: l10n.save,
            ),
          ),
      ],
    );
  }

  /// Build responsive layout based on device size
  Widget _buildResponsiveLayout(AppLocalizations l10n) {
    if (ui_kit.responsive.isDesktop) {
      return _buildDesktopLayout(l10n);
    } else if (ui_kit.responsive.isTablet) {
      return _buildTabletLayout(l10n);
    } else {
      return _buildMobileLayout(l10n);
    }
  }

  /// Mobile Layout - Single Column
  Widget _buildMobileLayout(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: _buildSections(l10n),
      ),
    );
  }

  /// Tablet Layout - Two Column Grid
  Widget _buildTabletLayout(AppLocalizations l10n) {
    final sections = _buildSections(l10n);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    sections[0], // Appearance
                    const SizedBox(height: 20),
                    sections[2], // Notifications
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    sections[1], // Units
                    const SizedBox(height: 20),
                    sections[3], // Language
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          sections[4], // About section full width
        ],
      ),
    );
  }

  /// Desktop Layout - Three Column with Sidebar
  Widget _buildDesktopLayout(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar Navigation
        Container(
          width: 240,
          color: ui_kit.HvacColors.backgroundCard,
          child: _buildDesktopSidebar(l10n),
        ),
        // Main Content
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                children: _buildSections(l10n),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Desktop Sidebar Navigation
  Widget _buildDesktopSidebar(AppLocalizations l10n) {
    return SettingsSidebar(
      selectedSection: _controller.selectedSection,
      onSectionSelected: _controller.selectSection,
    );
  }

  /// Build all settings sections
  List<Widget> _buildSections(AppLocalizations l10n) {
    return [
      AppearanceSection(
        darkMode: _controller.darkMode,
        onDarkModeChanged: (value) {
          _controller.setDarkMode(value);
          _animateThemeChange();
          _showSnackBar(l10n.themeChangeNextVersion);
        },
      ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1, end: 0),
      const SizedBox(height: 20),
      UnitsSection(
        celsius: _controller.celsius,
        onCelsiusChanged: (value) {
          _controller.setCelsius(value);
          _showSnackBar(
            l10n.unitsChangedTo(value ? l10n.celsius : l10n.fahrenheit),
          );
        },
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 100.ms)
          .slideX(begin: -0.1, end: 0),
      const SizedBox(height: 20),
      NotificationsSection(
        pushNotifications: _controller.pushNotifications,
        emailNotifications: _controller.emailNotifications,
        onPushChanged: (value) {
          _controller.setPushNotifications(value);
          _showSnackBar(
            l10n.notificationsState(
                'Push', value ? l10n.enabled : l10n.disabled),
          );
        },
        onEmailChanged: (value) {
          _controller.setEmailNotifications(value);
          _showSnackBar(
            l10n.notificationsState(
                'Email', value ? l10n.enabled : l10n.disabled),
          );
        },
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 200.ms)
          .slideX(begin: -0.1, end: 0),
      const SizedBox(height: 20),
      LanguageSection(
        selectedLanguage: _controller.currentLanguage,
        onLanguageChanged: (language) {
          _controller.setLanguage(language);
          _showSnackBar(l10n.languageChangedTo(language.nativeName));
        },
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 300.ms)
          .slideX(begin: -0.1, end: 0),
      const SizedBox(height: 20),
      AboutSection(
        onCheckUpdates: () {
          _showSnackBar(l10n.checkingUpdates);
        },
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 400.ms)
          .slideX(begin: -0.1, end: 0),
    ];
  }

  /// Handle setting changes
  void _handleSettingChanged() {
    if (mounted) setState(() {});
  }

  /// Animate theme change
  void _animateThemeChange() {
    _themeAnimationController.reset();
    _themeAnimationController.forward();
  }

  /// Save settings (for tablet/desktop)
  void _saveSettings() {
    _controller.saveSettings();
    _showSnackBar(AppLocalizations.of(context)!.settingsSaved);
  }

  /// Show snackbar using UI Kit component
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ui_kit.HvacColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
