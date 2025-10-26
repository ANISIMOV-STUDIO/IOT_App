/// Settings Screen
///
/// Application settings and configuration
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/language_service.dart';
import '../../generated/l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final ThemeService _themeService;
  late final LanguageService _languageService;

  @override
  void initState() {
    super.initState();
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
      body: ListView(
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
                      RadioGroup<ThemeMode>(
                        groupValue: _themeService.themeMode,
                        onChanged: (value) {
                          if (value != null) {
                            _themeService.setThemeMode(value);
                          }
                        },
                        child: Column(
                          children: [
                            RadioListTile<ThemeMode>(
                              title: Text(l10n.light),
                              value: ThemeMode.light,
                            ),
                            RadioListTile<ThemeMode>(
                              title: Text(l10n.dark),
                              value: ThemeMode.dark,
                            ),
                            RadioListTile<ThemeMode>(
                              title: Text(l10n.system),
                              value: ThemeMode.system,
                            ),
                          ],
                        ),
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
                      RadioGroup<AppLanguage>(
                        groupValue: _languageService.currentLanguage,
                        onChanged: (value) {
                          if (value != null) {
                            _languageService.setLanguage(value);
                          }
                        },
                        child: Column(
                          children: [
                            RadioListTile<AppLanguage>(
                              title: Text(l10nInner.english),
                              value: AppLanguage.english,
                            ),
                            RadioListTile<AppLanguage>(
                              title: Text(l10nInner.russian),
                              value: AppLanguage.russian,
                            ),
                            RadioListTile<AppLanguage>(
                              title: Text(l10nInner.chinese),
                              value: AppLanguage.chinese,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
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
              const Divider(),

              // Account Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'ACCOUNT',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  l10n.logout,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: Text(l10n.logout),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          child: Text(l10n.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            context.read<AuthBloc>().add(const LogoutEvent());
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.error,
                          ),
                          child: Text(l10n.logout),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
      ),
    );
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
