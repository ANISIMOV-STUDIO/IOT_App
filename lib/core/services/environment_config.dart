/// Environment Configuration
///
/// Manages environment-specific configuration using flutter_dotenv
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/logger.dart';

class EnvironmentConfig {
  static EnvironmentConfig? _instance;

  // Environment variables
  late final String _environment;
  late final String _apiBaseUrl;
  late final String _apiSecret;
  late final String _appVersion;
  late final bool _isProduction;
  late final bool _enableAnalytics;
  late final bool _enableCrashReporting;

  // Private constructor
  EnvironmentConfig._();

  /// Get singleton instance
  static EnvironmentConfig get instance {
    _instance ??= EnvironmentConfig._();
    return _instance!;
  }

  /// Initialize environment configuration
  static Future<void> initialize() async {
    try {
      // Load appropriate .env file based on build mode
      String envFile = '.env';

      if (kDebugMode) {
        envFile = '.env.development';
      } else if (kProfileMode) {
        envFile = '.env.staging';
      } else if (kReleaseMode) {
        envFile = '.env.production';
      }

      // Try to load environment-specific file, fall back to default .env
      try {
        await dotenv.load(fileName: envFile);
        Logger.info('Loaded environment configuration from $envFile');
      } catch (e) {
        Logger.warning('Failed to load $envFile, trying default .env');
        await dotenv.load(fileName: '.env');
      }

      // Initialize instance
      instance._loadConfiguration();
    } catch (e) {
      Logger.error('Failed to initialize environment configuration', error: e);

      // Use default values as fallback
      instance._loadDefaultConfiguration();
    }
  }

  /// Load configuration from environment variables
  void _loadConfiguration() {
    _environment = dotenv.get('ENVIRONMENT', fallback: 'development');
    _apiBaseUrl = _sanitizeUrl(
        dotenv.get('API_BASE_URL', fallback: 'http://localhost:8080/api'));
    _apiSecret = dotenv.get('API_SECRET', fallback: _generateDefaultSecret());
    _appVersion = dotenv.get('APP_VERSION', fallback: '1.0.0');
    _isProduction = _environment == 'production';
    _enableAnalytics =
        dotenv.get('ENABLE_ANALYTICS', fallback: 'false') == 'true';
    _enableCrashReporting =
        dotenv.get('ENABLE_CRASH_REPORTING', fallback: 'true') == 'true';

    // Validate configuration
    _validateConfiguration();

    Logger.info('Environment configuration loaded: $_environment');
  }

  /// Load default configuration (fallback)
  void _loadDefaultConfiguration() {
    _environment = kDebugMode ? 'development' : 'production';
    _apiBaseUrl = 'https://api.hvaccontrol.com/v1';
    _apiSecret = _generateDefaultSecret();
    _appVersion = '1.0.0';
    _isProduction = !kDebugMode;
    _enableAnalytics = false;
    _enableCrashReporting = !kDebugMode;

    Logger.warning('Using default environment configuration');
  }

  /// Validate configuration values
  void _validateConfiguration() {
    // Validate API URL
    if (!_apiBaseUrl.startsWith('http://') &&
        !_apiBaseUrl.startsWith('https://')) {
      throw ConfigurationException('Invalid API base URL: $_apiBaseUrl');
    }

    // Enforce HTTPS in production
    if (_isProduction && !_apiBaseUrl.startsWith('https://')) {
      throw ConfigurationException(
          'HTTPS is required in production environment');
    }

    // Validate API secret
    if (_apiSecret.length < 32) {
      throw ConfigurationException('API secret must be at least 32 characters');
    }

    // Check for default/placeholder values in production
    if (_isProduction) {
      if (_apiSecret.contains('DEFAULT') ||
          _apiSecret.contains('PLACEHOLDER')) {
        throw ConfigurationException(
            'Default API secret cannot be used in production');
      }

      if (_apiBaseUrl.contains('localhost') ||
          _apiBaseUrl.contains('127.0.0.1')) {
        throw ConfigurationException(
            'Localhost URL cannot be used in production');
      }
    }
  }

  /// Sanitize URL
  String _sanitizeUrl(String url) {
    // Remove trailing slash
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }

    // Ensure proper protocol
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    return url;
  }

  /// Generate default secret (for development only)
  String _generateDefaultSecret() {
    if (kReleaseMode) {
      throw ConfigurationException('API secret must be provided in production');
    }
    return 'DEFAULT_SECRET_FOR_DEVELOPMENT_ONLY_32CHARS!!';
  }

  // ===== GETTERS =====

  String get environment => _environment;
  String get apiBaseUrl => _apiBaseUrl;
  String get apiSecret => _apiSecret;
  String get appVersion => _appVersion;
  bool get isProduction => _isProduction;
  bool get isDevelopment => _environment == 'development';
  bool get isStaging => _environment == 'staging';
  bool get enableAnalytics => _enableAnalytics;
  bool get enableCrashReporting => _enableCrashReporting;

  /// Get custom configuration value
  String? getCustomValue(String key, {String? fallback}) {
    try {
      return dotenv.get(key, fallback: fallback);
    } catch (e) {
      Logger.warning('Failed to get custom config value for key: $key');
      return fallback;
    }
  }

  /// Get feature flag
  bool isFeatureEnabled(String featureName) {
    final key = 'FEATURE_${featureName.toUpperCase()}';
    final value = getCustomValue(key, fallback: 'false');
    return value?.toLowerCase() == 'true';
  }

  /// Get API endpoint URL
  String getApiEndpoint(String path) {
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    return '$_apiBaseUrl$path';
  }

  /// Check if debug features should be enabled
  bool get showDebugInfo => !_isProduction && kDebugMode;

  /// Get configuration summary (for debugging)
  Map<String, dynamic> toJson() {
    return {
      'environment': _environment,
      'apiBaseUrl': _apiBaseUrl,
      'appVersion': _appVersion,
      'isProduction': _isProduction,
      'enableAnalytics': _enableAnalytics,
      'enableCrashReporting': _enableCrashReporting,
      'showDebugInfo': showDebugInfo,
    };
  }

  @override
  String toString() => 'EnvironmentConfig(${toJson()})';
}

/// Configuration Exception
class ConfigurationException implements Exception {
  final String message;

  ConfigurationException(this.message);

  @override
  String toString() => 'ConfigurationException: $message';
}
