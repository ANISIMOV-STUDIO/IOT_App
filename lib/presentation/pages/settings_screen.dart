/// Settings Screen
///
/// Application settings and configuration
library;

import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../core/services/mqtt_settings_service.dart';
import '../../core/services/theme_service.dart';
import '../widgets/mqtt_settings_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final MqttSettingsService _settingsService;
  late final ThemeService _themeService;

  @override
  void initState() {
    super.initState();
    _settingsService = sl<MqttSettingsService>();
    _themeService = sl<ThemeService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                  'APPEARANCE',
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
                        title: const Text('Theme'),
                        subtitle: Text(_getThemeModeText(_themeService.themeMode)),
                        trailing: IconButton(
                          icon: const Icon(Icons.brightness_6_rounded),
                          onPressed: () => _themeService.toggleTheme(),
                          tooltip: 'Toggle Theme',
                        ),
                      ),
                      RadioListTile<ThemeMode>(
                        title: const Text('Light'),
                        value: ThemeMode.light,
                        groupValue: _themeService.themeMode,
                        onChanged: (value) {
                          if (value != null) {
                            _themeService.setThemeMode(value);
                          }
                        },
                      ),
                      RadioListTile<ThemeMode>(
                        title: const Text('Dark'),
                        value: ThemeMode.dark,
                        groupValue: _themeService.themeMode,
                        onChanged: (value) {
                          if (value != null) {
                            _themeService.setThemeMode(value);
                          }
                        },
                      ),
                      RadioListTile<ThemeMode>(
                        title: const Text('System'),
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

              // MQTT Settings Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'CONNECTION',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.router_rounded),
                title: const Text('MQTT Broker'),
                subtitle: Text(
                  '${settings.host}:${settings.port}${settings.useSsl ? ' (SSL)' : ''}',
                ),
                trailing: const Icon(Icons.edit_rounded),
                onTap: () => _showMqttSettings(context),
              ),
              if (settings.username != null)
                ListTile(
                  leading: const Icon(Icons.person_rounded),
                  title: const Text('Username'),
                  subtitle: Text(settings.username!),
                ),
              const Divider(),

              // About Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'ABOUT',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                subtitle: const Text('HVAC Control v1.0.0'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'HVAC Control',
                    applicationVersion: '1.0.0',
                    applicationIcon: const Icon(
                      Icons.air,
                      size: 48,
                    ),
                    children: [
                      const Text(
                        'Cross-platform HVAC management application with MQTT integration.',
                      ),
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
          const SnackBar(
            content: Text('Settings saved. Restart app to apply changes.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light mode';
      case ThemeMode.dark:
        return 'Dark mode';
      case ThemeMode.system:
        return 'System default';
    }
  }
}
