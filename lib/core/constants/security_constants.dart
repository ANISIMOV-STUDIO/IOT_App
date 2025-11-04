/// Security Constants
///
/// Defines security-related constants and configuration
library;

class SecurityConstants {
  // Prevent instantiation
  SecurityConstants._();

  /// Password requirements
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const bool requireUppercase = true;
  static const bool requireLowercase = true;
  static const bool requireNumber = true;
  static const bool requireSpecialChar = true;

  /// Session configuration
  static const Duration sessionTimeout = Duration(minutes: 30);
  static const Duration tokenRefreshInterval = Duration(minutes: 25);
  static const Duration maxSessionDuration = Duration(hours: 24);

  /// Rate limiting
  static const int maxLoginAttempts = 5;
  static const Duration loginLockoutDuration = Duration(minutes: 15);
  static const int maxApiRequestsPerMinute = 60;

  /// JWT Configuration
  static const String jwtIssuer = 'breez_home_app';
  static const String jwtAudience = 'breez_users';
  static const Duration jwtExpiry = Duration(hours: 1);
  static const Duration refreshTokenExpiry = Duration(days: 30);

  /// Encryption keys (In production, these should be in environment variables)
  /// These are placeholder values - NEVER commit real keys
  static const String passwordSalt = 'HVAC_SECURE_SALT_2024_V1';
  static const String encryptionKey = 'HVAC_ENCRYPTION_KEY_32BYTES_V1!';

  /// API Security
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
  static const List<String> allowedMethods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];

  /// Certificate Pinning (SHA256 fingerprints)
  /// Replace with your actual certificate fingerprints
  static const List<String> certificateFingerprints = [
    // Production API certificate
    'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
    // Backup certificate
    'sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
  ];

  /// Guest user limitations
  static const GuestLimitations guestLimitations = GuestLimitations(
    canViewDevices: true,
    canControlDevices: false,
    canViewAnalytics: true,
    canModifySettings: false,
    canAccessSchedules: false,
    canViewNotifications: true,
    canExportData: false,
    sessionDuration: Duration(hours: 1),
  );

  /// Input validation patterns
  static final RegExp emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp phonePattern = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );

  static final RegExp alphanumericPattern = RegExp(
    r'^[a-zA-Z0-9]+$',
  );

  static final RegExp namePattern = RegExp(
    r"^[a-zA-Z\s'-]+$",
  );

  static final RegExp urlPattern = RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
  );

  /// Sanitization rules
  static const List<String> bannedCharacters = [
    '<', '>', '"', "'", '&', '/', '\\',
    '\$', '{', '}', '(', ')', '[', ']',
    ';', ':', '?', '!', '|', '`', '~',
  ];

  /// Security headers
  static const Map<String, String> securityHeaders = {
    'X-Content-Type-Options': 'nosniff',
    'X-Frame-Options': 'DENY',
    'X-XSS-Protection': '1; mode=block',
    'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
    'Content-Security-Policy': "default-src 'self'",
    'Referrer-Policy': 'strict-origin-when-cross-origin',
  };

  /// Allowed domains for API communication
  static const List<String> allowedDomains = [
    'api.hvaccontrol.com',
    'staging.hvaccontrol.com',
    'localhost',
    '127.0.0.1',
  ];

  /// File upload restrictions
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedFileTypes = [
    'jpg', 'jpeg', 'png', 'pdf', 'csv', 'json',
  ];

  /// Biometric authentication settings
  static const bool biometricEnabled = true;
  static const String biometricReason = 'Please authenticate to access BREEZ Home';
  static const bool biometricRequired = false; // Optional enhancement

  /// Security event types for logging
  static const List<String> securityEvents = [
    'LOGIN_SUCCESS',
    'LOGIN_FAILURE',
    'LOGOUT',
    'TOKEN_REFRESH',
    'TOKEN_EXPIRED',
    'SESSION_TIMEOUT',
    'UNAUTHORIZED_ACCESS',
    'RATE_LIMIT_EXCEEDED',
    'SUSPICIOUS_ACTIVITY',
    'PASSWORD_CHANGE',
    'BIOMETRIC_AUTH',
    'CERTIFICATE_VALIDATION_FAILURE',
  ];
}

/// Guest user limitations configuration
class GuestLimitations {
  final bool canViewDevices;
  final bool canControlDevices;
  final bool canViewAnalytics;
  final bool canModifySettings;
  final bool canAccessSchedules;
  final bool canViewNotifications;
  final bool canExportData;
  final Duration sessionDuration;

  const GuestLimitations({
    required this.canViewDevices,
    required this.canControlDevices,
    required this.canViewAnalytics,
    required this.canModifySettings,
    required this.canAccessSchedules,
    required this.canViewNotifications,
    required this.canExportData,
    required this.sessionDuration,
  });
}

/// Password strength levels
enum PasswordStrength {
  weak,
  medium,
  strong,
  veryStrong,
}

/// Authentication methods
enum AuthMethod {
  email,
  biometric,
  social,
  guest,
}