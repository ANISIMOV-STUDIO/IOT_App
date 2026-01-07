/// Тесты для HvacHttpClient
///
/// Проверяет HTTP методы HVAC API:
/// - listDevices
/// - getDevice
/// - setPower
/// - setTemperature
/// - setMode
/// - setFanSpeed
library;

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import 'package:hvac_control/data/api/http/clients/hvac_http_client.dart';
import 'package:hvac_control/data/api/platform/api_client.dart';

/// Mock для ApiClient
class MockApiClient extends Mock implements ApiClient {}

/// Mock для http.Client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockApiClient mockApiClient;
  late MockHttpClient mockHttpClient;
  late HvacHttpClient hvacClient;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue(<String, String>{});
  });

  setUp(() {
    mockApiClient = MockApiClient();
    mockHttpClient = MockHttpClient();
    hvacClient = HvacHttpClient(mockApiClient);

    // Настройка по умолчанию
    when(() => mockApiClient.getHttpClient()).thenReturn(mockHttpClient);
    when(() => mockApiClient.getAuthToken()).thenAnswer((_) async => 'test-token');
  });

  /// Создаёт успешный HTTP ответ с JSON
  http.Response successResponse(dynamic body) {
    return http.Response(
      json.encode(body),
      200,
      headers: {'content-type': 'application/json'},
    );
  }

  /// Создаёт ошибочный HTTP ответ
  http.Response errorResponse(int statusCode, String message) {
    return http.Response(
      json.encode({'message': message}),
      statusCode,
      headers: {'content-type': 'application/json'},
    );
  }

  group('HvacHttpClient.listDevices', () {
    test('возвращает список устройств при успешном ответе (массив)', () async {
      // Arrange
      final devicesJson = [
        {'id': 'device-1', 'name': 'Бризер 1', 'isOnline': true},
        {'id': 'device-2', 'name': 'Бризер 2', 'isOnline': false},
      ];
      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => successResponse(devicesJson));

      // Act
      final result = await hvacClient.listDevices();

      // Assert
      expect(result, hasLength(2));
      expect(result[0]['id'], equals('device-1'));
      expect(result[1]['name'], equals('Бризер 2'));
    });

    test('возвращает список устройств при успешном ответе (объект с devices)', () async {
      // Arrange
      final devicesJson = {
        'devices': [
          {'id': 'device-1', 'name': 'Бризер 1'},
        ],
      };
      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => successResponse(devicesJson));

      // Act
      final result = await hvacClient.listDevices();

      // Assert
      expect(result, hasLength(1));
      expect(result[0]['id'], equals('device-1'));
    });

    test('возвращает пустой список при неизвестном формате', () async {
      // Arrange
      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => successResponse({'unknown': 'format'}));

      // Act
      final result = await hvacClient.listDevices();

      // Assert
      expect(result, isEmpty);
    });

    test('выбрасывает исключение при ошибке сервера', () async {
      // Arrange
      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => errorResponse(500, 'Internal Server Error'));

      // Act & Assert
      expect(
        () => hvacClient.listDevices(),
        throwsException,
      );
    });
  });

  group('HvacHttpClient.getDevice', () {
    test('возвращает устройство при успешном ответе', () async {
      // Arrange
      final deviceJson = {
        'id': 'device-1',
        'name': 'Бризер Гостиная',
        'isOn': true,
        'temperature': 22,
        'targetTemperature': 23,
        'mode': 'heating',
      };
      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => successResponse(deviceJson));

      // Act
      final result = await hvacClient.getDevice('device-1');

      // Assert
      expect(result['id'], equals('device-1'));
      expect(result['name'], equals('Бризер Гостиная'));
      expect(result['temperature'], equals(22));
    });

    test('выбрасывает исключение при 404', () async {
      // Arrange
      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => errorResponse(404, 'Device not found'));

      // Act & Assert
      expect(
        () => hvacClient.getDevice('unknown-device'),
        throwsException,
      );
    });
  });

  group('HvacHttpClient.setPower', () {
    test('включает устройство при успешном запросе', () async {
      // Arrange
      final responseJson = {
        'id': 'device-1',
        'isOn': true,
      };
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => successResponse(responseJson));

      // Act
      final result = await hvacClient.setPower('device-1', true);

      // Assert
      expect(result['isOn'], isTrue);

      // Verify request body
      verify(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: json.encode({'power': true}),
          )).called(1);
    });

    test('выключает устройство при успешном запросе', () async {
      // Arrange
      final responseJson = {
        'id': 'device-1',
        'isOn': false,
      };
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => successResponse(responseJson));

      // Act
      final result = await hvacClient.setPower('device-1', false);

      // Assert
      expect(result['isOn'], isFalse);
    });
  });


  group('HvacHttpClient.setTemperature', () {
    test('устанавливает температуру через PATCH', () async {
      // Arrange
      final responseJson = {
        'id': 'device-1',
        'heatingTemperature': 24,
      };
      when(() => mockHttpClient.patch(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => successResponse(responseJson));

      // Act
      final result = await hvacClient.setHeatingTemperature('device-1', 24);

      // Assert
      expect(result['heatingTemperature'], equals(24));

      // Verify request body uses heatingTemperature
      verify(() => mockHttpClient.patch(
            any(),
            headers: any(named: 'headers'),
            body: json.encode({'heatingTemperature': 24}),
          )).called(1);
    });

    test('выбрасывает исключение при ошибке сервера', () async {
      // Arrange
      when(() => mockHttpClient.patch(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => errorResponse(400, 'Invalid temperature'));

      // Act & Assert
      expect(
        () => hvacClient.setHeatingTemperature('device-1', 100),
        throwsException,
      );
    });
  });
  group('HvacHttpClient.setMode', () {
    test('устанавливает режим heating', () async {
      // Arrange
      final responseJson = {
        'id': 'device-1',
        'mode': 'heating',
      };
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => successResponse(responseJson));

      // Act
      final result = await hvacClient.setMode('device-1', 'heating');

      // Assert
      expect(result['mode'], equals('heating'));

      // Verify request body
      verify(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: json.encode({'mode': 'heating'}),
          )).called(1);
    });

    test('устанавливает режим cooling', () async {
      // Arrange
      final responseJson = {
        'id': 'device-1',
        'mode': 'cooling',
      };
      when(() => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => successResponse(responseJson));

      // Act
      final result = await hvacClient.setMode('device-1', 'cooling');

      // Assert
      expect(result['mode'], equals('cooling'));
    });
  });


  group('HvacHttpClient.setFanSpeed', () {
    test('устанавливает скорости вентиляторов через PATCH', () async {
      // Arrange
      final responseJson = {
        'id': 'device-1',
        'supplyFan': 80,
        'exhaustFan': 60,
      };
      when(() => mockHttpClient.patch(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => successResponse(responseJson));

      // Act
      final result = await hvacClient.setFanSpeed('device-1', 80, 60);

      // Assert
      expect(result['supplyFan'], equals(80));
      expect(result['exhaustFan'], equals(60));

      // Verify request uses PATCH to device endpoint
      verify(() => mockHttpClient.patch(
            any(),
            headers: any(named: 'headers'),
            body: json.encode({
              'supplyFan': 80,
              'exhaustFan': 60,
            }),
          )).called(1);
    });

    test('устанавливает минимальные значения вентиляторов', () async {
      // Arrange
      final responseJson = {
        'id': 'device-1',
        'supplyFan': 20,
        'exhaustFan': 20,
      };
      when(() => mockHttpClient.patch(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => successResponse(responseJson));

      // Act
      final result = await hvacClient.setFanSpeed('device-1', 20, 20);

      // Assert
      expect(result['supplyFan'], equals(20));
      expect(result['exhaustFan'], equals(20));
    });
  });
  group('HvacHttpClient авторизация', () {
    test('отправляет Authorization header с токеном', () async {
      // Arrange
      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => successResponse([]));

      // Act
      await hvacClient.listDevices();

      // Assert - проверяем что токен был запрошен
      verify(() => mockApiClient.getAuthToken()).called(1);
    });

    test('работает без токена (null)', () async {
      // Arrange
      when(() => mockApiClient.getAuthToken()).thenAnswer((_) async => null);
      when(() => mockHttpClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => successResponse([]));

      // Act & Assert - не должно выбрасывать исключение
      await expectLater(
        hvacClient.listDevices(),
        completes,
      );
    });
  });
}
