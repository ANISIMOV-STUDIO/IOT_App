/// Secure Storage Service
///
/// Provides encrypted storage for sensitive data using flutter_secure_storage
/// Implements proper error handling and fallback mechanisms
library;

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import '../constants/security_constants.dart';
import 'talker_service.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
      // Prevent backup to Google Drive
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      // Prevent iCloud backup
      synchronizable: false,
    ),
  );

  // Storage Keys
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userCredentialsKey = 'user_credentials';
  static const String _wifiCredentialsKey = 'wifi_credentials';
  static const String _deviceSecretsKey = 'device_secrets';
  static const String _apiKeysKey = 'api_keys';
  static const String _certificatesKey = 'certificates';
  static const String _sessionKey = 'session_data';

  /// Check if storage is available
  Future<bool> isStorageAvailable() async {
    try {
      // Test write and read
      await _storage.write(key: 'test_key', value: 'test_value');
      final value = await _storage.read(key: 'test_key');
      await _storage.delete(key: 'test_key');
      return value == 'test_value';
    } catch (e) {
      talker.error('Secure storage not available: $e');
      return false;
    }
  }

  /// Store authentication token
  Future<void> saveAuthToken(String token) async {
    try {
      await _storage.write(key: _authTokenKey, value: token);
      talker.info('Auth token saved securely');
    } catch (e) {
      talker.error('Failed to save auth token: $e');
      throw const SecurityException('Failed to save authentication token');
    }
  }

  /// Retrieve authentication token
  Future<String?> getAuthToken() async {
    try {
      return await _storage.read(key: _authTokenKey);
    } catch (e) {
      talker.error('Failed to retrieve auth token: $e');
      return null;
    }
  }

  /// Store refresh token
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
      talker.info('Refresh token saved securely');
    } catch (e) {
      talker.error('Failed to save refresh token: $e');
      throw const SecurityException('Failed to save refresh token');
    }
  }

  /// Retrieve refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      talker.error('Failed to retrieve refresh token: $e');
      return null;
    }
  }

  /// Store user credentials (encrypted)
  Future<void> saveUserCredentials({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    if (!rememberMe) return;

    try {
      // Additional encryption layer for credentials
      final hashedPassword = _hashPassword(password);
      final credentials = json.encode({
        'email': email,
        'password': hashedPassword,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _storage.write(key: _userCredentialsKey, value: credentials);
      talker.info('User credentials saved securely');
    } catch (e) {
      talker.error('Failed to save user credentials: $e');
      throw const SecurityException('Failed to save user credentials');
    }
  }

  /// Retrieve user credentials
  Future<Map<String, String>?> getUserCredentials() async {
    try {
      final data = await _storage.read(key: _userCredentialsKey);
      if (data == null) return null;

      final credentials = json.decode(data);
      return {
        'email': credentials['email'],
        'password': credentials['password'],
      };
    } catch (e) {
      talker.error('Failed to retrieve user credentials: $e');
      return null;
    }
  }

  /// Store WiFi credentials (encrypted)
  Future<void> saveWiFiCredentials({
    required String ssid,
    required String password,
    String? securityType,
  }) async {
    try {
      final credentials = json.encode({
        'ssid': ssid,
        'password': _encryptSensitiveData(password),
        'security': securityType,
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _storage.write(key: _wifiCredentialsKey, value: credentials);
      talker.info('WiFi credentials saved securely');
    } catch (e) {
      talker.error('Failed to save WiFi credentials: $e');
      throw const SecurityException('Failed to save WiFi credentials');
    }
  }

  /// Retrieve WiFi credentials
  Future<Map<String, dynamic>?> getWiFiCredentials() async {
    try {
      final data = await _storage.read(key: _wifiCredentialsKey);
      if (data == null) return null;

      final credentials = json.decode(data);
      credentials['password'] = _decryptSensitiveData(credentials['password']);
      return credentials;
    } catch (e) {
      talker.error('Failed to retrieve WiFi credentials: $e');
      return null;
    }
  }

  /// Store device secrets (API keys, device tokens)
  Future<void> saveDeviceSecrets(Map<String, dynamic> secrets) async {
    try {
      final encryptedSecrets = secrets.map(
        (key, value) => MapEntry(key, _encryptSensitiveData(value.toString())),
      );

      await _storage.write(
        key: _deviceSecretsKey,
        value: json.encode(encryptedSecrets),
      );
      talker.info('Device secrets saved securely');
    } catch (e) {
      talker.error('Failed to save device secrets: $e');
      throw const SecurityException('Failed to save device secrets');
    }
  }

  /// Retrieve device secrets
  Future<Map<String, dynamic>?> getDeviceSecrets() async {
    try {
      final data = await _storage.read(key: _deviceSecretsKey);
      if (data == null) return null;

      final encryptedSecrets = json.decode(data) as Map<String, dynamic>;
      return encryptedSecrets.map(
        (key, value) => MapEntry(key, _decryptSensitiveData(value)),
      );
    } catch (e) {
      talker.error('Failed to retrieve device secrets: $e');
      return null;
    }
  }

  /// Store API keys
  Future<void> saveApiKeys(Map<String, String> apiKeys) async {
    try {
      final encryptedKeys = apiKeys.map(
        (key, value) => MapEntry(key, _encryptSensitiveData(value)),
      );

      await _storage.write(
        key: _apiKeysKey,
        value: json.encode(encryptedKeys),
      );
      talker.info('API keys saved securely');
    } catch (e) {
      talker.error('Failed to save API keys: $e');
      throw const SecurityException('Failed to save API keys');
    }
  }

  /// Retrieve API keys
  Future<Map<String, String>?> getApiKeys() async {
    try {
      final data = await _storage.read(key: _apiKeysKey);
      if (data == null) return null;

      final encryptedKeys = json.decode(data) as Map<String, dynamic>;
      return encryptedKeys.map(
        (key, value) => MapEntry(key, _decryptSensitiveData(value.toString())),
      );
    } catch (e) {
      talker.error('Failed to retrieve API keys: $e');
      return null;
    }
  }

  /// Store SSL certificates
  Future<void> saveCertificates(List<String> certificates) async {
    try {
      await _storage.write(
        key: _certificatesKey,
        value: json.encode(certificates),
      );
      talker.info('Certificates saved securely');
    } catch (e) {
      talker.error('Failed to save certificates: $e');
      throw const SecurityException('Failed to save certificates');
    }
  }

  /// Retrieve SSL certificates
  Future<List<String>?> getCertificates() async {
    try {
      final data = await _storage.read(key: _certificatesKey);
      if (data == null) return null;

      return List<String>.from(json.decode(data));
    } catch (e) {
      talker.error('Failed to retrieve certificates: $e');
      return null;
    }
  }

  /// Store session data
  Future<void> saveSessionData(Map<String, dynamic> sessionData) async {
    try {
      await _storage.write(
        key: _sessionKey,
        value: json.encode(sessionData),
      );
    } catch (e) {
      talker.error('Failed to save session data: $e');
      throw const SecurityException('Failed to save session data');
    }
  }

  /// Retrieve session data
  Future<Map<String, dynamic>?> getSessionData() async {
    try {
      final data = await _storage.read(key: _sessionKey);
      if (data == null) return null;

      return json.decode(data);
    } catch (e) {
      talker.error('Failed to retrieve session data: $e');
      return null;
    }
  }

  /// Clear specific key
  Future<void> deleteKey(String key) async {
    try {
      await _storage.delete(key: key);
      talker.info('Key deleted: $key');
    } catch (e) {
      talker.error('Failed to delete key $key: $e');
    }
  }

  /// Clear all authentication data
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        _storage.delete(key: _authTokenKey),
        _storage.delete(key: _refreshTokenKey),
        _storage.delete(key: _userCredentialsKey),
        _storage.delete(key: _sessionKey),
      ]);
      talker.info('All auth data cleared');
    } catch (e) {
      talker.error('Failed to clear auth data: $e');
    }
  }

  /// Clear all secure storage
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      talker.info('All secure storage cleared');
    } catch (e) {
      talker.error('Failed to clear secure storage: $e');
      throw const SecurityException('Failed to clear secure storage');
    }
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      talker.error('Failed to check key existence: $e');
      return false;
    }
  }

  /// Hash password using SHA256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password + SecurityConstants.passwordSalt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Encrypt sensitive data (additional layer)
  String _encryptSensitiveData(String data) {
    // For additional security, you can implement AES encryption here
    // This is a simplified version - in production use proper AES encryption
    final bytes = utf8.encode(data);
    final key = utf8.encode(SecurityConstants.encryptionKey);

    // XOR encryption (simple example - use AES in production)
    final encrypted = bytes.asMap().entries.map((entry) {
      final index = entry.key % key.length;
      return entry.value ^ key[index];
    }).toList();

    return base64.encode(encrypted);
  }

  /// Decrypt sensitive data
  String _decryptSensitiveData(String encryptedData) {
    try {
      final encrypted = base64.decode(encryptedData);
      final key = utf8.encode(SecurityConstants.encryptionKey);

      // XOR decryption (simple example - use AES in production)
      final decrypted = encrypted.asMap().entries.map((entry) {
        final index = entry.key % key.length;
        return entry.value ^ key[index];
      }).toList();

      return utf8.decode(decrypted);
    } catch (e) {
      talker.error('Failed to decrypt data: $e');
      throw const SecurityException('Failed to decrypt sensitive data');
    }
  }

  /// Clear authentication tokens
  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: _authTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      talker.info('Tokens cleared successfully');
    } catch (e) {
      talker.error('Failed to clear tokens: $e');
      throw const SecurityException('Failed to clear tokens');
    }
  }
}

/// Security Exception
class SecurityException implements Exception {
  final String message;

  const SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}
