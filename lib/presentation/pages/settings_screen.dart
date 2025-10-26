/// Settings Screen
///
/// Application settings and configuration
library;

import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../core/services/mqtt_settings_service.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/language_service.dart';
import '../../generated/l10n/app_localizations.dart';
import '../widgets/mqtt_settings_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final MqttSettingsService _settingsService;
  late final ThemeService _themeService;
  late final LanguageService _languageService;

  @override
  void initState() {
    super.initState();
    _settingsService = sl<MqttSettingsService>();
    _themeService = sl<ThemeService>();
    _languageService = sl<LanguageService>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListenableBuilder(
        listenable: _settingsService,
        builder: (context, child) {
          final settings = _settingsService.settings;
          return ListView(
            children: [
              // Appearance Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  l10n.appearance.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ListenableBuilder(
                listenable: _themeService,
                builder: (context, child) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          _themeService.isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                        ),
                        title: Text(l10n.theme),
                        subtitle: Text(_getThemeModeText(context, _themeService.themeMode)),
                        trailing: IconButton(
                          icon: const Icon(Icons.brightness_6_rounded),
                          onPressed: () => _themeService.toggleTheme(),
                          tooltip: l10n.toggleTheme,
                        ),
                      ),
                      RadioListTile<ThemeMode>(
                        title: Text(l10n.light),
                        value: ThemeMode.light,
                        groupValue: _themeService.themeMode,
                        onChanged: (value) {
                          if (value != null) {
                            _themeService.setThemeMode(value);
                          }
                        },
                      ),
                      RadioListTile<ThemeMode>(
                        title: Text(l10n.dark),
                        value: ThemeMode.dark,
                        groupValue: _themeService.themeMode,
                        onChanged: (value) {
                          if (value != null) {
                            _themeService.setThemeMode(value);
                          }
                        },
                      ),
                      RadioListTile<ThemeMode>(
                        title: Text(l10n.system),
                        value: ThemeMode.system,
                        groupValue: _themeService.themeMode,
                        onChanged: (value) {
                          if (value != null) {
                            _themeService.setThemeMode(value);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              const Divider(),

              // Language Section
              ListenableBuilder(
                listenable: _languageService,
                builder: (context, child) {
                  final l10nInner = AppLocalizations.of(context)!;
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.language_rounded),
                        title: Text(l10nInner.language),
                        subtitle: Text(_languageService.currentLanguage.nativeName),
                      ),
                      RadioListTile<AppLanguage>(
                        title: Text(l10nInner.english),
                        value: AppLanguage.english,
                        groupValue: _languageService.currentLanguage,
                        onChanged: (value) {
                          if (value != null) {
                            _languageService.setLanguage(value);
                          }
                        },
                      ),
                      RadioListTile<AppLanguage>(
                        title: Text(l10nInner.russian),
                        value: AppLanguage.russian,
                        groupValue: _languageService.currentLanguage,
                        onChanged: (value) {
                          if (value != null) {
                            _languageService.setLanguage(value);
                          }
                        },
                      ),
                      RadioListTile<AppLanguage>(
                        title: Text(l10nInner.chinese),
                        value: AppLanguage.chinese,
                        groupValue: _languageService.currentLanguage,
                        onChanged: (value) {
                          if (value != null) {
                            _languageService.setLanguage(value);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              const Divider(),

              // MQTT Settings Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  l10n.connection.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.router_rounded),
                title: Text(l10n.mqttBroker),
                subtitle: Text(
                  '${settings.host}:${settings.port}${settings.useSsl ? ' (SSL)' : ''}',
                ),
                trailing: const Icon(Icons.edit_rounded),
                onTap: () => _showMqttSettings(context),
              ),
              if (settings.username != null)
                ListTile(
                  leading: const Icon(Icons.person_rounded),
                  title: Text(l10n.username),
                  subtitle: Text(settings.username!),
                ),
              const Divider(),

              // About Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  l10n.about.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.aboutApp),
                subtitle: Text('${l10n.appTitle} v1.0.0'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: l10n.appTitle,
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(
                      Icons.air,
                      size: 48,
                    ),
                    children: [
                      Text(l10n.appDescription),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showMqttSettings(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<MqttSettings>(
      context: context,
      builder: (context) => MqttSettingsDialog(
        initialSettings: _settingsService.settings,
      ),
    );

    if (result != null && mounted) {
      _settingsService.updateSettings(result);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settingsSaved),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _getThemeModeText(BuildContext context, ThemeMode mode) {
    final l10n = AppLocalizations.of(context)!;
    switch (mode) {
      case ThemeMode.light:
        return l10n.lightMode;
      case ThemeMode.dark:
        return l10n.darkMode;
      case ThemeMode.system:
        return l10n.systemDefault;
    }
  }
}
