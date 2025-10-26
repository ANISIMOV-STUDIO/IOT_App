/// Environment Configuration
///
/// Handles environment variables and configuration
library;

import 'package:flutter/foundation.dart';

class EnvConfig {
  // MQTT Configuration from environment variables
  static String get mqttBrokerHost {
    return const String.fromEnvironment(
      'MQTT_BROKER_HOST',
      defaultValue: 'localhost',
    );
  }

  static int get mqttBrokerPort {
    const portStr = String.fromEnvironment(
      'MQTT_BROKER_PORT',
      defaultValue: '1883',
    );
    return int.tryParse(portStr) ?? 1883;
  }

  static String get mqttClientId {
    return const String.fromEnvironment(
      'MQTT_CLIENT_ID',
      defaultValue: 'hvac_control_app',
    );
  }

  static String? get mqttUsername {
    const username = String.fromEnvironment('MQTT_USERNAME');
    return username.isEmpty ? null : username;
  }

  static String? get mqttPassword {
    const password = String.fromEnvironment('MQTT_PASSWORD');
    return password.isEmpty ? null : password;
  }

  static bool get mqttUseSsl {
    const useSsl = String.fromEnvironment('MQTT_USE_SSL', defaultValue: 'false');
    return useSsl.toLowerCase() == 'true';
  }

  static bool get useMqtt {
    const mode = String.fromEnvironment('USE_MQTT', defaultValue: 'false');
    return mode.toLowerCase() == 'true';
  }

  /// Print configuration (for debugging)
  static void printConfig() {
    if (kDebugMode) {
      print('=== Environment Configuration ===');
      print('MQTT Mode: ${useMqtt ? 'Enabled' : 'Mock Mode'}');
      print('Broker: $mqttBrokerHost:$mqttBrokerPort');
      print('Client ID: $mqttClientId');
      print('Username: ${mqttUsername ?? 'Not set'}');
      print('SSL: ${mqttUseSsl ? 'Enabled' : 'Disabled'}');
      print('=================================');
    }
  }
}
