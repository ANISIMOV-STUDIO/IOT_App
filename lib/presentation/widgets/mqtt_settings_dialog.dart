/// MQTT Settings Dialog
///
/// Dialog for configuring MQTT broker settings
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/mqtt_settings_service.dart';

class MqttSettingsDialog extends StatefulWidget {
  final MqttSettings initialSettings;

  const MqttSettingsDialog({
    super.key,
    required this.initialSettings,
  });

  @override
  State<MqttSettingsDialog> createState() => _MqttSettingsDialogState();
}

class _MqttSettingsDialogState extends State<MqttSettingsDialog> {
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _clientIdController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late bool _useSsl;
  late bool _showPassword;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController(text: widget.initialSettings.host);
    _portController = TextEditingController(
      text: widget.initialSettings.port.toString(),
    );
    _clientIdController = TextEditingController(
      text: widget.initialSettings.clientId,
    );
    _usernameController = TextEditingController(
      text: widget.initialSettings.username ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.initialSettings.password ?? '',
    );
    _useSsl = widget.initialSettings.useSsl;
    _showPassword = false;
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _clientIdController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('MQTT Broker Settings'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(
                  labelText: 'Broker Host',
                  hintText: 'localhost or IP address',
                  prefixIcon: Icon(Icons.dns),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter broker host';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _portController,
                decoration: const InputDecoration(
                  labelText: 'Port',
                  hintText: '1883',
                  prefixIcon: Icon(Icons.settings_ethernet),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter port';
                  }
                  final port = int.tryParse(value);
                  if (port == null || port < 1 || port > 65535) {
                    return 'Please enter valid port (1-65535)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _clientIdController,
                decoration: const InputDecoration(
                  labelText: 'Client ID',
                  hintText: 'hvac_control_app',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter client ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Use SSL/TLS'),
                subtitle: const Text('Secure connection'),
                value: _useSsl,
                onChanged: (value) {
                  setState(() {
                    _useSsl = value;
                  });
                },
              ),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Authentication (Optional)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Optional',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Optional',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                obscureText: !_showPassword,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveSettings,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      final settings = MqttSettings(
        host: _hostController.text.trim(),
        port: int.parse(_portController.text.trim()),
        clientId: _clientIdController.text.trim(),
        username: _usernameController.text.trim().isEmpty
            ? null
            : _usernameController.text.trim(),
        password: _passwordController.text.trim().isEmpty
            ? null
            : _passwordController.text.trim(),
        useSsl: _useSsl,
      );

      Navigator.of(context).pop(settings);
    }
  }
}
