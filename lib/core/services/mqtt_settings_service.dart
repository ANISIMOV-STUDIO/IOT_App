/// MQTT Settings Service
///
/// Manages MQTT broker configuration
library;

import 'package:flutter/foundation.dart';

class MqttSettings {
  final String host;
  final int port;
  final String clientId;
  final String? username;
  final String? password;
  final bool useSsl;

  const MqttSettings({
    required this.host,
    required this.port,
    required this.clientId,
    this.username,
    this.password,
    this.useSsl = false,
  });

  MqttSettings copyWith({
    String? host,
    int? port,
    String? clientId,
    String? username,
    String? password,
    bool? useSsl,
  }) {
    return MqttSettings(
      host: host ?? this.host,
      port: port ?? this.port,
      clientId: clientId ?? this.clientId,
      username: username ?? this.username,
      password: password ?? this.password,
      useSsl: useSsl ?? this.useSsl,
    );
  }
}

class MqttSettingsService extends ChangeNotifier {
  MqttSettings _settings = const MqttSettings(
    host: 'localhost',
    port: 1883,
    clientId: 'hvac_control_app',
  );

  MqttSettings get settings => _settings;

  void updateSettings(MqttSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
  }

  void updateHost(String host) {
    _settings = _settings.copyWith(host: host);
    notifyListeners();
  }

  void updatePort(int port) {
    _settings = _settings.copyWith(port: port);
    notifyListeners();
  }

  void updateClientId(String clientId) {
    _settings = _settings.copyWith(clientId: clientId);
    notifyListeners();
  }

  void updateUsername(String? username) {
    _settings = _settings.copyWith(username: username);
    notifyListeners();
  }

  void updatePassword(String? password) {
    _settings = _settings.copyWith(password: password);
    notifyListeners();
  }

  void updateUseSsl(bool useSsl) {
    _settings = _settings.copyWith(useSsl: useSsl);
    notifyListeners();
  }
}
