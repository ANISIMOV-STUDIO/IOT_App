/// Settings Screen
///
/// Application settings and configuration
library;

import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.router),
            title: const Text('MQTT Broker'),
            subtitle: const Text('localhost:1883'),
            trailing: const Icon(Icons.edit),
            onTap: () {
              // TODO: Implement MQTT settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('MQTT settings coming soon'),
                ),
              );
            },
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
      ),
    );
  }
}
