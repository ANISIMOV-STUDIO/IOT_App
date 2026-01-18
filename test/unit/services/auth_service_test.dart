/// Тесты для AuthService
///
/// Проверяет все методы API авторизации:
/// - register
/// - login
/// - getCurrentUser
/// - verifyEmail
/// - resendCode
/// - refreshToken
/// - logout / logoutAll
library;

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:hvac_control/data/services/auth_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/test_data.dart';

/// Mock для HTTP клиента
class MockHttpClient extends Mock implements http.Client {}


void main() {
  late MockHttpClient mockClient;
  late AuthService authService;

  setUpAll(() {
    // Регистрация fallback значений
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue(<String, String>{});
  });

  setUp(() {
    mockClient = MockHttpClient();
    authService = AuthService(mockClient);
  });

  /// Создаёт успешный HTTP ответ с JSON
  http.Response successResponse(Map<String, dynamic> body) => http.Response(
      json.encode(body),
      200,
      headers: {'content-type': 'application/json'},
    );

  /// Создаёт ошибочный HTTP ответ
  http.Response errorResponse(int statusCode, String message) => http.Response(
      json.encode({'message': message}),
      statusCode,
      headers: {'content-type': 'application/json'},
    );

  group('AuthService.register', () {
    test('возвращает RegisterResponse при успешной регистрации', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => successResponse(TestData.registerSuccessJson));

      // Act
      final result = await authService.register(TestData.registerRequest);

      // Assert
      expect(result.email, equals('newuser@example.com'));
      expect(result.requiresEmailVerification, isTrue);
    });

    test('выбрасывает AuthException при дублировании email', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => errorResponse(400, 'Пользователь уже существует'));

      // Act & Assert
      expect(
        () => authService.register(TestData.registerRequest),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          'Пользователь уже существует',
        )),
      );
    });

    test('выбрасывает AuthException при ошибке сети', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => authService.register(TestData.registerRequest),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          contains('Ошибка подключения'),
        )),
      );
    });
  });

  group('AuthService.login', () {
    test('возвращает AuthResponse при успешном входе', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => successResponse(TestData.loginSuccessJson));

      // Act
      final result = await authService.login(TestData.loginRequest);

      // Assert
      expect(result.accessToken, equals(TestData.testAccessToken));
      expect(result.refreshToken, equals(TestData.testRefreshToken));
      expect(result.user.email, equals('test@example.com'));
    });

    test('выбрасывает AuthException при 401', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('{}', 401));

      // Act & Assert
      expect(
        () => authService.login(TestData.loginRequest),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          'Неверный email или пароль',
        )),
      );
    });

    test('выбрасывает AuthException при неверных учётных данных', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => errorResponse(400, 'Неверный пароль'));

      // Act & Assert
      expect(
        () => authService.login(TestData.loginRequest),
        throwsA(isA<AuthException>()),
      );
    });

    test('выбрасывает AuthException при ошибке сети', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenThrow(Exception('Connection refused'));

      // Act & Assert
      expect(
        () => authService.login(TestData.loginRequest),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          contains('Ошибка подключения'),
        )),
      );
    });
  });

  group('AuthService.getCurrentUser', () {
    test('возвращает User при успешном запросе', () async {
      // Arrange
      when(() => mockClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => successResponse(TestData.userJson));

      // Act
      final result = await authService.getCurrentUser(TestData.testAccessToken);

      // Assert
      expect(result.id, equals(TestData.testUser.id));
      expect(result.email, equals(TestData.testUser.email));
    });

    test('выбрасывает AuthException при 401', () async {
      // Arrange
      when(() => mockClient.get(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response('{}', 401));

      // Act & Assert
      expect(
        () => authService.getCurrentUser(TestData.testAccessToken),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          'Токен недействителен',
        )),
      );
    });
  });

  group('AuthService.verifyEmail', () {
    test('завершается успешно при валидном коде', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('{}', 200));

      // Act & Assert
      await expectLater(
        authService.verifyEmail(TestData.verifyEmailRequest),
        completes,
      );
    });

    test('выбрасывает AuthException при неверном коде', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => errorResponse(400, 'Неверный код подтверждения'));

      // Act & Assert
      expect(
        () => authService.verifyEmail(TestData.verifyEmailRequest),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('AuthService.resendCode', () {
    test('завершается успешно', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('{}', 200));

      // Act & Assert
      await expectLater(
        authService.resendCode(TestData.resendCodeRequest),
        completes,
      );
    });

    test('выбрасывает AuthException при ошибке', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => errorResponse(429, 'Слишком много запросов'));

      // Act & Assert
      expect(
        () => authService.resendCode(TestData.resendCodeRequest),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('AuthService.refreshToken', () {
    test('возвращает новый AuthResponse', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => successResponse(TestData.loginSuccessJson));

      // Act
      final result = await authService.refreshToken(TestData.testRefreshToken);

      // Assert
      expect(result.accessToken, isNotEmpty);
      expect(result.refreshToken, isNotEmpty);
    });

    test('выбрасывает AuthException при истёкшем refresh token', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('{}', 401));

      // Act & Assert
      expect(
        () => authService.refreshToken(TestData.testRefreshToken),
        throwsA(isA<AuthException>().having(
          (e) => e.message,
          'message',
          contains('истек'),
        )),
      );
    });
  });

  group('AuthService.logout', () {
    test('завершается без ошибки при успешном logout', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('{}', 200));

      // Act & Assert
      await expectLater(
        authService.logout(TestData.testRefreshToken),
        completes,
      );
    });

    test('завершается без ошибки даже при ошибке сервера', () async {
      // Arrange - logout не должен выбрасывать исключения
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenThrow(Exception('Server error'));

      // Act & Assert - должен завершиться без ошибки
      await expectLater(
        authService.logout(TestData.testRefreshToken),
        completes,
      );
    });
  });

  group('AuthService.logoutAll', () {
    test('завершается без ошибки', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response('{}', 200));

      // Act & Assert
      await expectLater(
        authService.logoutAll(TestData.testAccessToken),
        completes,
      );
    });

    test('завершается без ошибки даже при ошибке сервера', () async {
      // Arrange
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
          )).thenThrow(Exception('Server error'));

      // Act & Assert
      await expectLater(
        authService.logoutAll(TestData.testAccessToken),
        completes,
      );
    });
  });
}
