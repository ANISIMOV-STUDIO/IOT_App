/// Тесты для AuthStorageService
///
/// Проверяет работу с токенами:
/// - Сохранение access и refresh токенов
/// - Получение токенов
/// - Проверка истечения токена
/// - Удаление токенов
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:hvac_control/core/services/auth_storage_service.dart';

/// Mock для FlutterSecureStorage
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late AuthStorageService authStorageService;

  /// Валидный JWT токен с exp в будущем (timestamp 9999999999 = 2286 год)
  const validToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0LXVzZXItaWQiLCJlbWFpbCI6InRlc3RAZXhhbXBsZS5jb20iLCJleHAiOjk5OTk5OTk5OTl9.signature';

  /// Истёкший JWT токен (timestamp 1600000000 = 2020 год)
  const _ =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0LXVzZXItaWQiLCJlbWFpbCI6InRlc3RAZXhhbXBsZS5jb20iLCJleHAiOjE2MDAwMDAwMDB9.signature';

  const refreshToken = 'test-refresh-token-123';
  const userId = 'test-user-id';

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    authStorageService = AuthStorageService(mockStorage);
  });

  group('AuthStorageService.saveTokens', () {
    test('сохраняет access и refresh токены', () async {
      // Arrange
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      // Act
      await authStorageService.saveTokens(validToken, refreshToken);

      // Assert
      verify(() => mockStorage.write(
            key: 'auth_access_token',
            value: validToken,
          )).called(1);
      verify(() => mockStorage.write(
            key: 'auth_refresh_token',
            value: refreshToken,
          )).called(1);
    });

    test('извлекает и сохраняет время истечения из JWT', () async {
      // Arrange
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      // Act
      await authStorageService.saveTokens(validToken, refreshToken);

      // Assert - проверяем что время истечения было сохранено
      verify(() => mockStorage.write(
            key: 'auth_token_expiry',
            value: any(named: 'value'),
          )).called(1);
    });
  });

  group('AuthStorageService.updateAccessToken', () {
    test('обновляет только access токен', () async {
      // Arrange
      const newToken = 'new-access-token';
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      // Act
      await authStorageService.updateAccessToken(newToken);

      // Assert
      verify(() => mockStorage.write(
            key: 'auth_access_token',
            value: newToken,
          )).called(1);
      // Не должен обновлять refresh token
      verifyNever(() => mockStorage.write(
            key: 'auth_refresh_token',
            value: any(named: 'value'),
          ));
    });
  });

  group('AuthStorageService.getToken', () {
    test('возвращает сохранённый access токен', () async {
      // Arrange
      when(() => mockStorage.read(key: 'auth_access_token'))
          .thenAnswer((_) async => validToken);

      // Act
      final result = await authStorageService.getToken();

      // Assert
      expect(result, equals(validToken));
    });

    test('возвращает null когда токен не сохранён', () async {
      // Arrange
      when(() => mockStorage.read(key: 'auth_access_token'))
          .thenAnswer((_) async => null);

      // Act
      final result = await authStorageService.getToken();

      // Assert
      expect(result, isNull);
    });
  });

  group('AuthStorageService.getRefreshToken', () {
    test('возвращает сохранённый refresh токен', () async {
      // Arrange
      when(() => mockStorage.read(key: 'auth_refresh_token'))
          .thenAnswer((_) async => refreshToken);

      // Act
      final result = await authStorageService.getRefreshToken();

      // Assert
      expect(result, equals(refreshToken));
    });

    test('возвращает null когда refresh токен не сохранён', () async {
      // Arrange
      when(() => mockStorage.read(key: 'auth_refresh_token'))
          .thenAnswer((_) async => null);

      // Act
      final result = await authStorageService.getRefreshToken();

      // Assert
      expect(result, isNull);
    });
  });

  group('AuthStorageService.isAccessTokenExpired', () {
    test('возвращает false для валидного токена', () async {
      // Arrange - токен истекает в 2286 году
      final futureExpiry = DateTime(2286, 1, 1).toIso8601String();
      when(() => mockStorage.read(key: 'auth_token_expiry'))
          .thenAnswer((_) async => futureExpiry);

      // Act
      final result = await authStorageService.isAccessTokenExpired();

      // Assert
      expect(result, isFalse);
    });

    test('возвращает true для истёкшего токена', () async {
      // Arrange - токен истёк в 2020 году
      final pastExpiry = DateTime(2020, 1, 1).toIso8601String();
      when(() => mockStorage.read(key: 'auth_token_expiry'))
          .thenAnswer((_) async => pastExpiry);

      // Act
      final result = await authStorageService.isAccessTokenExpired();

      // Assert
      expect(result, isTrue);
    });

    test('возвращает false когда expiry отсутствует', () async {
      // Arrange
      when(() => mockStorage.read(key: 'auth_token_expiry'))
          .thenAnswer((_) async => null);

      // Act
      final result = await authStorageService.isAccessTokenExpired();

      // Assert
      expect(result, isFalse);
    });

    test('возвращает false при некорректном формате даты', () async {
      // Arrange
      when(() => mockStorage.read(key: 'auth_token_expiry'))
          .thenAnswer((_) async => 'invalid-date');

      // Act
      final result = await authStorageService.isAccessTokenExpired();

      // Assert
      expect(result, isFalse);
    });
  });

  group('AuthStorageService.saveUserId', () {
    test('сохраняет ID пользователя', () async {
      // Arrange
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      // Act
      await authStorageService.saveUserId(userId);

      // Assert
      verify(() => mockStorage.write(
            key: 'user_id',
            value: userId,
          )).called(1);
    });
  });

  group('AuthStorageService.getUserId', () {
    test('возвращает сохранённый ID пользователя', () async {
      // Arrange
      when(() => mockStorage.read(key: 'user_id'))
          .thenAnswer((_) async => userId);

      // Act
      final result = await authStorageService.getUserId();

      // Assert
      expect(result, equals(userId));
    });

    test('возвращает null когда ID не сохранён', () async {
      // Arrange
      when(() => mockStorage.read(key: 'user_id'))
          .thenAnswer((_) async => null);

      // Act
      final result = await authStorageService.getUserId();

      // Assert
      expect(result, isNull);
    });
  });

  group('AuthStorageService.deleteToken', () {
    test('удаляет все токены и данные пользователя', () async {
      // Arrange
      when(() => mockStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      // Act
      await authStorageService.deleteToken();

      // Assert
      verify(() => mockStorage.delete(key: 'auth_access_token')).called(1);
      verify(() => mockStorage.delete(key: 'auth_refresh_token')).called(1);
      verify(() => mockStorage.delete(key: 'auth_token_expiry')).called(1);
      verify(() => mockStorage.delete(key: 'user_id')).called(1);
    });
  });

  group('AuthStorageService.hasToken', () {
    test('возвращает true когда токен существует', () async {
      // Arrange
      when(() => mockStorage.read(key: 'auth_access_token'))
          .thenAnswer((_) async => validToken);

      // Act
      final result = await authStorageService.hasToken();

      // Assert
      expect(result, isTrue);
    });

    test('возвращает false когда токен null', () async {
      // Arrange
      when(() => mockStorage.read(key: 'auth_access_token'))
          .thenAnswer((_) async => null);

      // Act
      final result = await authStorageService.hasToken();

      // Assert
      expect(result, isFalse);
    });

    test('возвращает false когда токен пустой', () async {
      // Arrange
      when(() => mockStorage.read(key: 'auth_access_token'))
          .thenAnswer((_) async => '');

      // Act
      final result = await authStorageService.hasToken();

      // Assert
      expect(result, isFalse);
    });
  });

  group('AuthStorageService.clearAll', () {
    test('очищает всё хранилище', () async {
      // Arrange
      when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

      // Act
      await authStorageService.clearAll();

      // Assert
      verify(() => mockStorage.deleteAll()).called(1);
    });
  });
}
