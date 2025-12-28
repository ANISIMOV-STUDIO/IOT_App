/// API Configuration for backend communication
library;

import 'package:flutter/foundation.dart';

class ApiConfig {
  // Backend configuration
  static const String backendHost = '89.207.223.45';
  static const int grpcPort = 443; // gRPC over TLS
  static const int httpPort = 443; // HTTPS

  // URLs
  static String get grpcUrl => 'https://$backendHost:$grpcPort';
  static String get httpUrl => 'https://$backendHost:$httpPort';
  static String get websocketUrl =>
      'wss://$backendHost:$httpPort/hubs/devices';

  // REST API endpoints (for web)
  static String get apiBaseUrl => '$httpUrl/api';
  static String get hvacApiUrl => '$apiBaseUrl/hvac';
  static String get analyticsApiUrl => '$apiBaseUrl/analytics';
  static String get scheduleApiUrl => '$apiBaseUrl/schedule';
  static String get notificationApiUrl => '$apiBaseUrl/notifications';
  static String get occupantApiUrl => '$apiBaseUrl/occupants';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration streamTimeout = Duration(minutes: 5);

  // gRPC options
  static const bool useGrpcCompression = true;
  static const int maxReceiveMessageLength = 10 * 1024 * 1024; // 10MB

  // Platform detection
  static bool get isWeb => kIsWeb;
  static bool get useGrpc => !kIsWeb; // gRPC for mobile/desktop only

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
