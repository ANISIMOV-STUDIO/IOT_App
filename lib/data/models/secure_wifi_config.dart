/// Secure WiFi Configuration Model
///
/// Model for securely storing WiFi credentials and configuration
library;

import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../../core/constants/security_constants.dart';

class SecureWiFiConfig {
  final String ssid;
  final String encryptedPassword;
  final WiFiSecurityType securityType;
  final bool isHidden;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final String? deviceId;
  final Map<String, dynamic>? additionalConfig;

  SecureWiFiConfig({
    required this.ssid,
    required this.encryptedPassword,
    required this.securityType,
    this.isHidden = false,
    DateTime? createdAt,
    this.lastUsedAt,
    this.deviceId,
    this.additionalConfig,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create from plain password (encrypts automatically)
  factory SecureWiFiConfig.fromPlainPassword({
    required String ssid,
    required String password,
    required WiFiSecurityType securityType,
    bool isHidden = false,
    String? deviceId,
    Map<String, dynamic>? additionalConfig,
  }) {
    return SecureWiFiConfig(
      ssid: ssid,
      encryptedPassword: _encryptPassword(password),
      securityType: securityType,
      isHidden: isHidden,
      deviceId: deviceId,
      additionalConfig: additionalConfig,
    );
  }

  /// Encrypt password
  static String _encryptPassword(String password) {
    // Create a hash of the password with salt
    const salt = SecurityConstants.passwordSalt;
    final bytes = utf8.encode('$password$salt');
    final digest = sha256.convert(bytes);

    // Additional encryption layer
    final encrypted = base64.encode(digest.bytes);
    return encrypted;
  }

  /// Decrypt password (simplified - in production use proper AES)
  String getDecryptedPassword() {
    // This is a simplified example
    // In production, implement proper AES decryption
    return encryptedPassword; // Placeholder
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'ssid': ssid,
      'encrypted_password': encryptedPassword,
      'security_type': securityType.toString(),
      'is_hidden': isHidden,
      'created_at': createdAt.toIso8601String(),
      'last_used_at': lastUsedAt?.toIso8601String(),
      'device_id': deviceId,
      'additional_config': additionalConfig,
    };
  }

  /// Create from JSON
  factory SecureWiFiConfig.fromJson(Map<String, dynamic> json) {
    return SecureWiFiConfig(
      ssid: json['ssid'],
      encryptedPassword: json['encrypted_password'],
      securityType: WiFiSecurityType.fromString(json['security_type']),
      isHidden: json['is_hidden'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      lastUsedAt: json['last_used_at'] != null
          ? DateTime.parse(json['last_used_at'])
          : null,
      deviceId: json['device_id'],
      additionalConfig: json['additional_config'],
    );
  }

  /// Create a copy with updated values
  SecureWiFiConfig copyWith({
    String? ssid,
    String? encryptedPassword,
    WiFiSecurityType? securityType,
    bool? isHidden,
    DateTime? lastUsedAt,
    String? deviceId,
    Map<String, dynamic>? additionalConfig,
  }) {
    return SecureWiFiConfig(
      ssid: ssid ?? this.ssid,
      encryptedPassword: encryptedPassword ?? this.encryptedPassword,
      securityType: securityType ?? this.securityType,
      isHidden: isHidden ?? this.isHidden,
      createdAt: createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      deviceId: deviceId ?? this.deviceId,
      additionalConfig: additionalConfig ?? this.additionalConfig,
    );
  }

  /// Mark as used (updates lastUsedAt)
  SecureWiFiConfig markAsUsed() {
    return copyWith(lastUsedAt: DateTime.now());
  }

  /// Check if configuration is valid
  bool isValid() {
    // Validate SSID
    if (ssid.isEmpty || ssid.length > 32) return false;

    // Validate password based on security type
    if (securityType != WiFiSecurityType.open && encryptedPassword.isEmpty) {
      return false;
    }

    return true;
  }

  /// Get security level (for UI display)
  WiFiSecurityLevel get securityLevel {
    switch (securityType) {
      case WiFiSecurityType.open:
        return WiFiSecurityLevel.none;
      case WiFiSecurityType.wep:
        return WiFiSecurityLevel.weak;
      case WiFiSecurityType.wpa:
        return WiFiSecurityLevel.medium;
      case WiFiSecurityType.wpa2:
      case WiFiSecurityType.wpa3:
        return WiFiSecurityLevel.strong;
      case WiFiSecurityType.enterprise:
        return WiFiSecurityLevel.veryStrong;
    }
  }

  @override
  String toString() {
    return 'SecureWiFiConfig(ssid: $ssid, security: $securityType, hidden: $isHidden)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SecureWiFiConfig &&
        other.ssid == ssid &&
        other.encryptedPassword == encryptedPassword &&
        other.securityType == securityType;
  }

  @override
  int get hashCode {
    return ssid.hashCode ^ encryptedPassword.hashCode ^ securityType.hashCode;
  }
}

/// WiFi Security Types
enum WiFiSecurityType {
  open,
  wep,
  wpa,
  wpa2,
  wpa3,
  enterprise;

  @override
  String toString() {
    switch (this) {
      case WiFiSecurityType.open:
        return 'Open';
      case WiFiSecurityType.wep:
        return 'WEP';
      case WiFiSecurityType.wpa:
        return 'WPA';
      case WiFiSecurityType.wpa2:
        return 'WPA2';
      case WiFiSecurityType.wpa3:
        return 'WPA3';
      case WiFiSecurityType.enterprise:
        return 'Enterprise';
    }
  }

  static WiFiSecurityType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'open':
        return WiFiSecurityType.open;
      case 'wep':
        return WiFiSecurityType.wep;
      case 'wpa':
        return WiFiSecurityType.wpa;
      case 'wpa2':
        return WiFiSecurityType.wpa2;
      case 'wpa3':
        return WiFiSecurityType.wpa3;
      case 'enterprise':
        return WiFiSecurityType.enterprise;
      default:
        return WiFiSecurityType.wpa2; // Default to WPA2
    }
  }

  bool get requiresPassword => this != WiFiSecurityType.open;
}

/// WiFi Security Levels
enum WiFiSecurityLevel {
  none,
  weak,
  medium,
  strong,
  veryStrong;

  Color get color {
    switch (this) {
      case WiFiSecurityLevel.none:
        return const Color(0xFFEF5350); // Red
      case WiFiSecurityLevel.weak:
        return const Color(0xFFFFA726); // Orange
      case WiFiSecurityLevel.medium:
        return const Color(0xFFFFCA28); // Yellow
      case WiFiSecurityLevel.strong:
        return const Color(0xFF66BB6A); // Light Green
      case WiFiSecurityLevel.veryStrong:
        return const Color(0xFF43A047); // Green
    }
  }

  String get label {
    switch (this) {
      case WiFiSecurityLevel.none:
        return 'No Security';
      case WiFiSecurityLevel.weak:
        return 'Weak';
      case WiFiSecurityLevel.medium:
        return 'Medium';
      case WiFiSecurityLevel.strong:
        return 'Strong';
      case WiFiSecurityLevel.veryStrong:
        return 'Very Strong';
    }
  }
}

// Color class stub for non-Flutter contexts
class Color {
  final int value;
  const Color(this.value);
}
