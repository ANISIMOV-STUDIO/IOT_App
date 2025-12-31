/// Тесты для AuthBloc
///
/// Проверяет все сценарии авторизации:
/// - Проверка сессии
/// - Вход
/// - Регистрация
/// - Выход
/// - Подтверждение email
/// - Повторная отправка кода
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hvac_control/presentation/bloc/auth/auth_bloc.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_event.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_state.dart';
import 'package:hvac_control/data/services/auth_service.dart';

import '../../fixtures/mock_services.dart';
import '../../fixtures/test_data.dart';

void main() {
  late MockAuthService mockAuthService;
  late MockAuthStorageService mockStorageService;

  setUpAll(() {
    // Регистрация fallback значений для mocktail
    registerFallbackValue(TestData.loginRequest);
    registerFallbackValue(TestData.registerRequest);
    registerFallbackValue(TestData.verifyEmailRequest);
    registerFallbackValue(TestData.resendCodeRequest);
  });

  setUp(() {
    mockAuthService = MockAuthService();
    mockStorageService = MockAuthStorageService();
  });

  /// Создаёт экземпляр AuthBloc с mock-зависимостями
  AuthBloc createBloc() {
    return AuthBloc(
      authService: mockAuthService,
      storageService: mockStorageService,
    );
  }

  group('AuthBloc - Инициализация', () {
    test('начальное состояние - AuthInitial', () {
      final bloc = createBloc();
      expect(bloc.state, isA<AuthInitial>());
      bloc.close();
    });
  });

  group('AuthBloc - AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthAuthenticated] когда токены валидны',
      build: () {
        when(() => mockStorageService.getToken())
            .thenAnswer((_) async => TestData.testAccessToken);
        when(() => mockStorageService.getRefreshToken())
            .thenAnswer((_) async => TestData.testRefreshToken);
        when(() => mockAuthService.getCurrentUser(any()))
            .thenAnswer((_) async => TestData.testUser);
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>()
            .having((s) => s.user, 'user', TestData.testUser)
            .having((s) => s.accessToken, 'accessToken', TestData.testAccessToken),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthUnauthenticated] когда токен отсутствует',
      build: () {
        when(() => mockStorageService.getToken()).thenAnswer((_) async => null);
        when(() => mockStorageService.getRefreshToken()).thenAnswer((_) async => null);
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthUnauthenticated] когда токен пустой',
      build: () {
        when(() => mockStorageService.getToken()).thenAnswer((_) async => '');
        when(() => mockStorageService.getRefreshToken()).thenAnswer((_) async => '');
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthUnauthenticated] и удаляет токен при ошибке API',
      build: () {
        when(() => mockStorageService.getToken())
            .thenAnswer((_) async => TestData.testAccessToken);
        when(() => mockStorageService.getRefreshToken())
            .thenAnswer((_) async => TestData.testRefreshToken);
        when(() => mockAuthService.getCurrentUser(any()))
            .thenThrow(const AuthException('Токен недействителен'));
        when(() => mockStorageService.deleteToken()).thenAnswer((_) async {});
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
      verify: (_) {
        verify(() => mockStorageService.deleteToken()).called(1);
      },
    );
  });

  group('AuthBloc - AuthLoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthAuthenticated] при успешном входе',
      build: () {
        when(() => mockAuthService.login(any()))
            .thenAnswer((_) async => TestData.authResponse);
        when(() => mockStorageService.saveTokens(any(), any()))
            .thenAnswer((_) async {});
        when(() => mockStorageService.saveUserId(any()))
            .thenAnswer((_) async {});
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: 'test@example.com',
        password: 'Password123!',
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>()
            .having((s) => s.user, 'user', TestData.testUser),
      ],
      verify: (_) {
        verify(() => mockStorageService.saveTokens(
              TestData.testAccessToken,
              TestData.testRefreshToken,
            )).called(1);
        verify(() => mockStorageService.saveUserId(TestData.testUser.id))
            .called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthError] при неверных учётных данных',
      build: () {
        when(() => mockAuthService.login(any()))
            .thenThrow(const AuthException('Неверный email или пароль'));
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: 'wrong@example.com',
        password: 'wrongpassword',
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>()
            .having((s) => s.message, 'message', 'Неверный email или пароль'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthError] при ошибке сети',
      build: () {
        when(() => mockAuthService.login(any()))
            .thenThrow(const AuthException('Ошибка подключения к серверу'));
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: 'test@example.com',
        password: 'Password123!',
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>()
            .having((s) => s.message, 'message', contains('Ошибка подключения')),
      ],
    );
  });

  group('AuthBloc - AuthRegisterRequested', () {
    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthRegistered] при успешной регистрации',
      build: () {
        when(() => mockAuthService.register(any()))
            .thenAnswer((_) async => TestData.registerResponse);
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthRegisterRequested(
        email: 'newuser@example.com',
        password: 'Password123!',
        firstName: 'Новый',
        lastName: 'Пользователь',
        dataProcessingConsent: true,
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthRegistered>()
            .having((s) => s.email, 'email', 'newuser@example.com'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthError] при дублирующемся email',
      build: () {
        when(() => mockAuthService.register(any()))
            .thenThrow(const AuthException('Пользователь уже существует'));
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthRegisterRequested(
        email: 'existing@example.com',
        password: 'Password123!',
        firstName: 'Тест',
        lastName: 'Тестов',
        dataProcessingConsent: true,
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>()
            .having((s) => s.message, 'message', 'Пользователь уже существует'),
      ],
    );
  });

  group('AuthBloc - AuthLogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthUnauthenticated] и очищает токены при выходе',
      build: () {
        when(() => mockStorageService.getRefreshToken())
            .thenAnswer((_) async => TestData.testRefreshToken);
        when(() => mockAuthService.logout(any())).thenAnswer((_) async {});
        when(() => mockStorageService.deleteToken()).thenAnswer((_) async {});
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [
        isA<AuthUnauthenticated>(),
      ],
      verify: (_) {
        verify(() => mockStorageService.deleteToken()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthUnauthenticated] даже при ошибке API logout',
      build: () {
        when(() => mockStorageService.getRefreshToken())
            .thenAnswer((_) async => TestData.testRefreshToken);
        when(() => mockAuthService.logout(any()))
            .thenThrow(const AuthException('Ошибка сервера'));
        when(() => mockStorageService.deleteToken()).thenAnswer((_) async {});
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [
        isA<AuthUnauthenticated>(),
      ],
      verify: (_) {
        // Токены всё равно должны быть удалены
        verify(() => mockStorageService.deleteToken()).called(1);
      },
    );
  });

  group('AuthBloc - AuthLogoutAllRequested', () {
    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthUnauthenticated] и очищает токены при выходе со всех устройств',
      build: () {
        when(() => mockStorageService.getToken())
            .thenAnswer((_) async => TestData.testAccessToken);
        when(() => mockAuthService.logoutAll(any())).thenAnswer((_) async {});
        when(() => mockStorageService.deleteToken()).thenAnswer((_) async {});
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthLogoutAllRequested()),
      expect: () => [
        isA<AuthUnauthenticated>(),
      ],
      verify: (_) {
        verify(() => mockAuthService.logoutAll(TestData.testAccessToken)).called(1);
        verify(() => mockStorageService.deleteToken()).called(1);
      },
    );
  });

  group('AuthBloc - AuthVerifyEmailRequested', () {
    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthEmailVerified] при успешной верификации',
      build: () {
        when(() => mockAuthService.verifyEmail(any()))
            .thenAnswer((_) async {});
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthVerifyEmailRequested(
        email: 'test@example.com',
        code: '123456',
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthEmailVerified>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthError] при неверном коде',
      build: () {
        when(() => mockAuthService.verifyEmail(any()))
            .thenThrow(const AuthException('Неверный код подтверждения'));
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthVerifyEmailRequested(
        email: 'test@example.com',
        code: '000000',
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>()
            .having((s) => s.message, 'message', 'Неверный код подтверждения'),
      ],
    );
  });

  group('AuthBloc - AuthResendCodeRequested', () {
    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthCodeResent] при успешной отправке кода',
      build: () {
        when(() => mockAuthService.resendCode(any()))
            .thenAnswer((_) async {});
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthResendCodeRequested(
        email: 'test@example.com',
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthCodeResent>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'эмитит [AuthLoading, AuthError] при ошибке отправки кода',
      build: () {
        when(() => mockAuthService.resendCode(any()))
            .thenThrow(const AuthException('Слишком много запросов'));
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthResendCodeRequested(
        email: 'test@example.com',
      )),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>()
            .having((s) => s.message, 'message', 'Слишком много запросов'),
      ],
    );
  });
}
