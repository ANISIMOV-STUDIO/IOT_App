/// Settings Screen
///
/// App settings including theme, language, units, and preferences
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../generated/l10n/app_localizations.dart';
import '../widgets/settings/settings_section_widget.dart';
import '../widgets/settings/settings_switch_tile.dart';
import '../widgets/settings/settings_language_tile.dart';
import '../widgets/settings/settings_info_row.dart';

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
  String _language = '';
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
          child: Column(
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
          ),
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    final l10n = AppLocalizations.of(context)!;
    return SettingsSectionWidget(
      title: l10n.appearance,
      icon: Icons.palette_outlined,
      children: [
        HvacInteractiveRipple(
          child: SettingsSwitchTile(
            title: l10n.darkTheme,
            subtitle: l10n.useDarkColorScheme,
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
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
    return SettingsSectionWidget(
      title: l10n.units,
      icon: Icons.straighten_outlined,
      children: [
        HvacInteractiveRipple(
          child: SettingsSwitchTile(
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
    return SettingsSectionWidget(
      title: l10n.notifications,
      icon: Icons.notifications_outlined,
      children: [
        HvacInteractiveRipple(
          child: SettingsSwitchTile(
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
          child: SettingsSwitchTile(
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
    return SettingsSectionWidget(
      title: l10n.language,
      icon: Icons.language_outlined,
      children: [
        SettingsLanguageTile(
          language: l10n.russian,
          isSelected: _language == l10n.russian,
          onTap: () {
            setState(() => _language = l10n.russian);
            _showSnackBar(l10n.languageChangedTo(l10n.russian));
          },
        ),
        const SizedBox(height: 8.0),
        SettingsLanguageTile(
          language: l10n.english,
          isSelected: _language == l10n.english,
          onTap: () {
            setState(() => _language = l10n.english);
            _showSnackBar(l10n.languageChangedTo(l10n.english));
          },
        ),
        const SizedBox(height: 8.0),
        SettingsLanguageTile(
          language: l10n.german,
          isSelected: _language == l10n.german,
          onTap: () {
            setState(() => _language = l10n.german);
            _showSnackBar(l10n.languageChangedTo(l10n.german));
          },
        ),
      ],
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildAboutSection() {
    final l10n = AppLocalizations.of(context)!;
    return SettingsSectionWidget(
      title: l10n.about,
      icon: Icons.info_outline,
      children: [
        HvacInteractiveRipple(
          child: SettingsInfoRow(label: l10n.version, value: '1.0.0'),
        ),
        const SizedBox(height: 12.0),
        HvacInteractiveRipple(
          child: SettingsInfoRow(label: l10n.developer, value: 'BREEZ'),
        ),
        const SizedBox(height: 12.0),
        HvacInteractiveRipple(
          child: SettingsInfoRow(label: l10n.license, value: 'MIT License'),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          child: HvacNeumorphicButton(
            onPressed: () => _showSnackBar(l10n.checkingUpdates),
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
