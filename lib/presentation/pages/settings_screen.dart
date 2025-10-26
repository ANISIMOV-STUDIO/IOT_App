/// Settings Screen
///
/// Application settings and configuration
library;

import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../core/services/mqtt_settings_service.dart';
import '../widgets/mqtt_settings_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final MqttSettingsService _settingsService;

  @override
  void initState() {
    super.initState();
    _settingsService = sl<MqttSettingsService>();
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
              ListTile(
                leading: const Icon(Icons.router),
                title: const Text('MQTT Broker'),
                subtitle: Text(
                  '${settings.host}:${settings.port}${settings.useSsl ? ' (SSL)' : ''}',
                ),
                trailing: const Icon(Icons.edit),
                onTap: () => _showMqttSettings(context),
              ),
              if (settings.username != null)
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Username'),
                  subtitle: Text(settings.username!),
                ),
              const Divider(),
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
}
