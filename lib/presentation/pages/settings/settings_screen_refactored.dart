/// Settings Screen - Refactored with Responsive Design
///
/// App settings with responsive layout and extracted sections
/// Compliant with 300-line limit and SOLID principles
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart' as ui_kit;
import '../../../generated/l10n/app_localizations.dart';
import '../../widgets/settings/appearance_section.dart';
import '../../widgets/settings/units_section.dart';
import '../../widgets/settings/notifications_section.dart';
import '../../widgets/settings/language_section.dart';
import '../../widgets/settings/about_section.dart';
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
    _controller = SettingsController(
      onSettingChanged: _handleSettingChanged,
    );
    _themeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
        backgroundColor: ui_kit.HvacColors.backgroundDark,
        appBar: _buildAppBar(l10n),
        body: SafeArea(
          child: ui_kit.AdaptiveLayout(
            mobile: _buildMobileLayout(l10n),
            tablet: _buildTabletLayout(l10n),
            desktop: _buildDesktopLayout(l10n),
          ),
        ),
      ),
    );
  }

  /// App Bar with responsive sizing
  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: ui_kit.HvacColors.backgroundCard,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: ui_kit.HvacColors.textPrimary,
          size: 24.w,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        l10n.settingsTitle,
        style: ui_kit.HvacTypography.headlineMedium.copyWith(
          fontSize: 20.sp,
          color: ui_kit.HvacColors.textPrimary,
        ),
      ),
      actions: [
        // Save button for tablet/desktop
        if (ui_kit.responsive.isTablet || ui_kit.responsive.isDesktop)
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: ui_kit.HvacTextButton(
              onPressed: _saveSettings,
              label: l10n.save,
            ),
          ),
      ],
    );
  }

  /// Mobile Layout - Single Column
  Widget _buildMobileLayout(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: _buildSections(l10n),
      ),
    );
  }

  /// Tablet Layout - Two Column Grid
  Widget _buildTabletLayout(AppLocalizations l10n) {
    final sections = _buildSections(l10n);

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    sections[0], // Appearance
                    SizedBox(height: 20.h),
                    sections[2], // Notifications
                  ],
                ),
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Column(
                  children: [
                    sections[1], // Units
                    SizedBox(height: 20.h),
                    sections[3], // Language
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
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
          width: 240.w,
          color: ui_kit.HvacColors.backgroundCard,
          child: _buildDesktopSidebar(l10n),
        ),
        // Main Content
        Expanded(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800.w),
            padding: EdgeInsets.all(32.w),
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
    final menuItems = [
      (Icons.palette_outlined, l10n.appearance, 0),
      (Icons.straighten_outlined, l10n.units, 1),
      (Icons.notifications_outlined, l10n.notifications, 2),
      (Icons.language_outlined, l10n.language, 3),
      (Icons.info_outline, l10n.about, 4),
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildSidebarItem(
          icon: item.$1,
          label: item.$2,
          index: item.$3,
        );
      },
    );
  }

  /// Sidebar Menu Item
  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _controller.selectedSection == index;

    return InkWell(
      onTap: () => _controller.selectSection(index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? ui_kit.HvacColors.primaryOrange.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? ui_kit.HvacColors.primaryOrange
                  : Colors.transparent,
              width: 3.w,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.w,
              color: isSelected
                  ? ui_kit.HvacColors.primaryOrange
                  : ui_kit.HvacColors.textSecondary,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: ui_kit.HvacTypography.bodyMedium.copyWith(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? ui_kit.HvacColors.primaryOrange
                      : ui_kit.HvacColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
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
      SizedBox(height: 20.h),
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
      SizedBox(height: 20.h),
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
      SizedBox(height: 20.h),
      LanguageSection(
        selectedLanguage: _controller.language,
        onLanguageChanged: (language) {
          _controller.setLanguage(language);
          _showSnackBar(l10n.languageChangedTo(language));
        },
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 300.ms)
          .slideX(begin: -0.1, end: 0),
      SizedBox(height: 20.h),
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

  /// Show snackbar with responsive sizing
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 14.sp),
        ),
        backgroundColor: ui_kit.HvacColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
