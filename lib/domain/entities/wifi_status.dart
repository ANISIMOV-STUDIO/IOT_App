/// WiFi Status Entity
///
/// WiFi connection status and configuration
library;

import 'package:equatable/equatable.dart';

class WiFiStatus extends Equatable {
  final bool isConnected; // Подключено к WiFi сети
  final String? connectedSSID; // SSID подключенной сети
  final String? stationPassword; // Пароль для подключения (STA mode)
  final String apSSID; // SSID точки доступа устройства (AP mode)
  final String apPassword; // Пароль точки доступа
  final int signalStrength; // Уровень сигнала (RSSI), -100 до 0 dBm
  final String? ipAddress; // IP адрес устройства
  final String? macAddress; // MAC адрес устройства

  const WiFiStatus({
    required this.isConnected,
    this.connectedSSID,
    this.stationPassword,
    required this.apSSID,
    required this.apPassword,
    this.signalStrength = -100,
    this.ipAddress,
    this.macAddress,
  });

  /// Create a copy with updated fields
  WiFiStatus copyWith({
    bool? isConnected,
    String? connectedSSID,
    String? stationPassword,
    String? apSSID,
    String? apPassword,
    int? signalStrength,
    String? ipAddress,
    String? macAddress,
  }) {
    return WiFiStatus(
      isConnected: isConnected ?? this.isConnected,
      connectedSSID: connectedSSID ?? this.connectedSSID,
      stationPassword: stationPassword ?? this.stationPassword,
      apSSID: apSSID ?? this.apSSID,
      apPassword: apPassword ?? this.apPassword,
      signalStrength: signalStrength ?? this.signalStrength,
      ipAddress: ipAddress ?? this.ipAddress,
      macAddress: macAddress ?? this.macAddress,
    );
  }

  /// Get signal quality percentage (0-100%)
  int get signalQuality {
    // RSSI to percentage conversion
    // -30 dBm = 100%, -90 dBm = 0%
    if (signalStrength >= -30) return 100;
    if (signalStrength <= -90) return 0;
    return ((signalStrength + 90) * 100 / 60).round();
  }

  /// Get signal quality description
  String get signalQualityDescription {
    if (signalQuality >= 80) return 'Отличный';
    if (signalQuality >= 60) return 'Хороший';
    if (signalQuality >= 40) return 'Средний';
    if (signalQuality >= 20) return 'Слабый';
    return 'Очень слабый';
  }

  @override
  List<Object?> get props => [
        isConnected,
        connectedSSID,
        stationPassword,
        apSSID,
        apPassword,
        signalStrength,
        ipAddress,
        macAddress,
      ];

  @override
  String toString() {
    return 'WiFiStatus(connected: $isConnected, SSID: $connectedSSID, signal: $signalStrength dBm, quality: $signalQuality%)';
  }
}

/// WiFi Network Scan Result
class WiFiNetwork extends Equatable {
  final String ssid; // Имя сети
  final int rssi; // Уровень сигнала (RSSI)
  final int channel; // Канал WiFi (1-14)
  final String encryption; // Тип шифрования (OPEN, WPA2, WPA3, etc.)
  final bool isSecured; // Защищена паролем

  const WiFiNetwork({
    required this.ssid,
    required this.rssi,
    required this.channel,
    required this.encryption,
    required this.isSecured,
  });

  /// Get signal quality percentage (0-100%)
  int get signalQuality {
    if (rssi >= -30) return 100;
    if (rssi <= -90) return 0;
    return ((rssi + 90) * 100 / 60).round();
  }

  @override
  List<Object?> get props => [ssid, rssi, channel, encryption, isSecured];

  @override
  String toString() {
    return 'WiFiNetwork(ssid: $ssid, rssi: $rssi dBm, ch: $channel, encryption: $encryption)';
  }
}
