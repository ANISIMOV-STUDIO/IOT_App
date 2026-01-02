/// API Configuration for backend communication
library;

import 'package:flutter/foundation.dart';

class ApiConfig {
  // Backend configuration
  static const String backendHost = 'hvac.anisimovstudio.ru';

  // URLs
  static String get grpcUrl => 'https://$backendHost'; // HTTPS через nginx
  static String get httpUrl => 'https://$backendHost'; // HTTPS через nginx
  static String get websocketUrl =>
      'wss://$backendHost/hubs/devices'; // WSS через nginx

  // REST API endpoints (for web)
  static String get apiBaseUrl => '$httpUrl/api';
  static String get deviceApiUrl => '$apiBaseUrl/device'; // Новый DeviceController
  static String get hvacApiUrl => deviceApiUrl; // Алиас для совместимости
  static String get analyticsApiUrl => '$apiBaseUrl/analytics'; // Не реализован на бэке
  static String get scheduleApiUrl => deviceApiUrl; // Расписание через /device/{id}/schedule
  static String get notificationApiUrl => '$apiBaseUrl/notification'; // Без s!
  static String get occupantApiUrl => '$apiBaseUrl/occupant'; // Без s!
  static String get releaseApiUrl => '$apiBaseUrl/release'; // Версии приложения

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
