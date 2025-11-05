/// Settings Screen
///
/// App settings including theme, language, units, and preferences
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../generated/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  bool _darkMode = true;
  bool _celsius = true;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _language = '';  // Will be set to localized value in initState
  late AnimationController _themeAnimationController;

  @override
  void initState() {
    super.initState();
    _themeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set initial language value using localized string
    if (_language.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      _language = l10n.russian;
    }
  }

  @override
  void dispose() {
    _themeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: HvacColors.backgroundCard,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: HvacColors.textPrimary, size: 24.0),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.settingsTitle,
          style: HvacTypography.headlineMedium.copyWith(
            fontSize: 20.0,
            color: HvacColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: _buildLayout(),
        ),
      ),
    );
  }

  Widget _buildLayout() {
    return Column(
      children: [
        _buildAppearanceSection(),
        const SizedBox(height: 20.0),
        _buildUnitsSection(),
        const SizedBox(height: 20.0),
        _buildNotificationsSection(),
        const SizedBox(height: 20.0),
        _buildLanguageSection(),
        const SizedBox(height: 20.0),
        _buildAboutSection(),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    final l10n = AppLocalizations.of(context)!;
    return _buildSection(
      title: l10n.appearance,
      icon: Icons.palette_outlined,
      children: [
        HvacInteractiveRipple(
          child: _buildSwitchTile(
            title: l10n.darkTheme,
            subtitle: l10n.useDarkColorScheme,
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
              // Animate theme change
              _themeAnimationController.reset();
              _themeAnimationController.forward();
              _showSnackBar(l10n.themeChangeNextVersion);
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildUnitsSection() {
    final l10n = AppLocalizations.of(context)!;
    return _buildSection(
      title: l10n.units,
      icon: Icons.straighten_outlined,
      children: [
        HvacInteractiveRipple(
          child: _buildSwitchTile(
            title: l10n.temperatureUnits,
            subtitle: _celsius ? l10n.celsius : l10n.fahrenheit,
            value: _celsius,
            onChanged: (value) {
              setState(() => _celsius = value);
              _showSnackBar(
                  l10n.unitsChangedTo(value ? l10n.celsius : l10n.fahrenheit));
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildNotificationsSection() {
    final l10n = AppLocalizations.of(context)!;
    return _buildSection(
      title: l10n.notifications,
      icon: Icons.notifications_outlined,
      children: [
        HvacInteractiveRipple(
          child: _buildSwitchTile(
            title: l10n.pushNotifications,
            subtitle: l10n.receiveInstantNotifications,
            value: _pushNotifications,
            onChanged: (value) {
              setState(() => _pushNotifications = value);
              _showSnackBar(
                  l10n.notificationsState('Push', value ? l10n.enabled : l10n.disabled));
            },
          ),
        ),
        const SizedBox(height: 12.0),
        HvacInteractiveRipple(
          child: _buildSwitchTile(
            title: l10n.emailNotifications,
            subtitle: l10n.receiveEmailReports,
            value: _emailNotifications,
            onChanged: (value) {
              setState(() => _emailNotifications = value);
              _showSnackBar(
                  l10n.notificationsState('Email', value ? l10n.enabled : l10n.disabled));
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildLanguageSection() {
    final l10n = AppLocalizations.of(context)!;
    return _buildSection(
      title: l10n.language,
      icon: Icons.language_outlined,
      children: [
        _buildLanguageTile(l10n.russian),
        const SizedBox(height: 8.0),
        _buildLanguageTile(l10n.english),
        const SizedBox(height: 8.0),
        _buildLanguageTile(l10n.german),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildAboutSection() {
    final l10n = AppLocalizations.of(context)!;
    return _buildSection(
      title: l10n.about,
      icon: Icons.info_outline,
      children: [
        HvacInteractiveRipple(
          child: _buildInfoRow(l10n.version, '1.0.0'),
        ),
        const SizedBox(height: 12.0),
        HvacInteractiveRipple(
          child: _buildInfoRow(l10n.developer, 'BREEZ'),
        ),
        const SizedBox(height: 12.0),
        HvacInteractiveRipple(
          child: _buildInfoRow(l10n.license, 'MIT License'),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          child: HvacNeumorphicButton(
            onPressed: () {
              _showSnackBar(l10n.checkingUpdates);
            },
            child: Text(
              l10n.checkUpdates,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: HvacColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return HvacGradientBorder(
      borderWidth: 2.0,
      gradientColors: [
        HvacColors.primaryOrange.withValues(alpha:0.3),
        HvacColors.primaryBlue.withValues(alpha:0.3),
      ],
      borderRadius: HvacRadius.lgRadius,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: HvacRadius.lgRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: HvacColors.primaryOrange, size: 24.0),
                const SizedBox(width: 12.0),
                Text(
                  title,
                  style: HvacTypography.headlineSmall.copyWith(
                    fontSize: 18.0,
                    color: HvacColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: HvacTypography.titleMedium.copyWith(
                  fontSize: 14.0,
                  color: HvacColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                subtitle,
                style: HvacTypography.labelLarge.copyWith(
                  fontSize: 12.0,
                  color: HvacColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return HvacColors.primaryOrange;
            }
            return null;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (!states.contains(WidgetState.selected)) {
              return HvacColors.textSecondary.withValues(alpha:0.3);
            }
            return null;
          }),
        ),
      ],
    );
  }

  Widget _buildLanguageTile(String language) {
    final l10n = AppLocalizations.of(context)!;
    final isSelected = _language == language;

    return HvacInteractiveScale(
      onTap: () {
        setState(() => _language = language);
        _showSnackBar(l10n.languageChangedTo(language));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? HvacColors.primaryOrange.withValues(alpha: 0.1)
              : HvacColors.backgroundDark,
          borderRadius: HvacRadius.mdRadius,
          border: Border.all(
            color: isSelected
                ? HvacColors.primaryOrange
                : HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? HvacColors.primaryOrange : HvacColors.textSecondary,
              size: 20.0,
            ),
            const SizedBox(width: 12.0),
            Text(
              language,
              style: HvacTypography.bodyMedium.copyWith(
                fontSize: 14.0,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? HvacColors.primaryOrange : HvacColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0));
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: HvacTypography.bodyMedium.copyWith(
            fontSize: 14.0,
            color: HvacColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: HvacTypography.titleMedium.copyWith(
            fontSize: 14.0,
            color: HvacColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: HvacColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: HvacRadius.mdRadius,
        ),
      ),
    );
  }
}
