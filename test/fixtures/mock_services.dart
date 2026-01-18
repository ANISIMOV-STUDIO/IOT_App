/// Mock-сервисы для тестирования
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hvac_control/core/services/auth_storage_service.dart';
import 'package:hvac_control/data/services/auth_service.dart';
import 'package:hvac_control/domain/repositories/schedule_repository.dart';
import 'package:mocktail/mocktail.dart';

/// Mock для AuthService
class MockAuthService extends Mock implements AuthService {}

/// Mock для AuthStorageService
class MockAuthStorageService extends Mock implements AuthStorageService {}

/// Mock для ScheduleRepository
class MockScheduleRepository extends Mock implements ScheduleRepository {}

/// Mock для HTTP клиента
class MockHttpClient extends Mock implements http.Client {}

/// Mock для безопасного хранилища
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

/// Mock для HTTP ответа
class MockResponse extends Mock implements http.Response {}

/// Регистрация fallback значений для mocktail
void registerFallbackValues() {
  // Регистрация fallback для Uri
  registerFallbackValue(Uri.parse('https://example.com'));

  // Регистрация fallback для Map<String, String>
  registerFallbackValue(<String, String>{});

  // Регистрация fallback для String
  registerFallbackValue('');
}
