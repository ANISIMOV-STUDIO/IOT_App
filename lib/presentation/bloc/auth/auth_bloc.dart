/// Auth BLoC
library;

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/services/auth_storage_service.dart';
import 'package:hvac_control/core/services/token_refresh_service.dart';
import 'package:hvac_control/data/api/http/interceptors/auth_http_interceptor.dart';
import 'package:hvac_control/data/models/auth_models.dart';
import 'package:hvac_control/data/services/auth_service.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_event.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_state.dart';

/// BLoC для управления состоянием аутентификации
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthService authService,
    required AuthStorageService storageService,
    TokenRefreshService? tokenRefreshService,
  })  : _authService = authService,
        _storageService = storageService,
        _tokenRefreshService = tokenRefreshService,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthLogoutAllRequested>(_onLogoutAllRequested);
    on<AuthVerifyEmailRequested>(_onVerifyEmailRequested);
    on<AuthResendCodeRequested>(_onResendCodeRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthChangePasswordRequested>(_onChangePasswordRequested);
    on<AuthUpdateProfileRequested>(_onUpdateProfileRequested);
    on<AuthSessionExpired>(_onSessionExpired);

    // Подписка на события истечения сессии от TokenRefreshService
    _sessionExpiredSubscription = _tokenRefreshService?.onSessionExpired.listen((_) {
      add(const AuthSessionExpired());
    });
  }

  final AuthService _authService;
  final AuthStorageService _storageService;
  final TokenRefreshService? _tokenRefreshService;
  StreamSubscription<void>? _sessionExpiredSubscription;

  @override
  Future<void> close() {
    _sessionExpiredSubscription?.cancel();
    _tokenRefreshService?.dispose();
    return super.close();
  }

  /// Проверка сохраненной сессии
  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final accessToken = await _storageService.getToken();
      final refreshToken = await _storageService.getRefreshToken();

      if (accessToken != null &&
          accessToken.isNotEmpty &&
          refreshToken != null &&
          refreshToken.isNotEmpty) {
        final user = await _authService.getCurrentUser(accessToken);

        // Сбросить состояние сессии при успешной проверке
        AuthHttpInterceptor.resetSessionState();

        // Запустить фоновое обновление токенов
        _tokenRefreshService?.start();

        emit(AuthAuthenticated(
          user: user,
          accessToken: accessToken,
          refreshToken: refreshToken,
        ));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      await _storageService.deleteToken();
      emit(const AuthUnauthenticated());
    }
  }

  /// Вход
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final request = LoginRequest(
        email: event.email,
        password: event.password,
      );

      final response = await _authService.login(request);

      // Сохранить оба токены
      await _storageService.saveTokens(
        response.accessToken,
        response.refreshToken,
      );
      await _storageService.saveUserId(response.user.id);

      // Сбросить состояние сессии после успешного логина
      AuthHttpInterceptor.resetSessionState();

      // Запустить фоновое обновление токенов
      _tokenRefreshService?.start();

      emit(AuthAuthenticated(
        user: response.user,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Регистрация
  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final request = RegisterRequest(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        dataProcessingConsent: event.dataProcessingConsent,
      );

      final response = await _authService.register(request);

      // Регистрация успешна, требуется подтверждение email
      // password НЕ передаётся в состояние для безопасности
      emit(AuthRegistered(email: response.email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Выход
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Остановить фоновое обновление токенов
    _tokenRefreshService?.stop();

    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _authService.logout(refreshToken);
      }
    } catch (e) {
      // Логировать, но продолжить logout
    }

    await _storageService.deleteToken();
    emit(const AuthUnauthenticated());
  }

  /// Выход со всех устройств
  Future<void> _onLogoutAllRequested(
    AuthLogoutAllRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Остановить фоновое обновление токенов
    _tokenRefreshService?.stop();

    try {
      final accessToken = await _storageService.getToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        await _authService.logoutAll(accessToken);
      }
    } catch (e) {
      // Логировать, но продолжить logout
    }

    await _storageService.deleteToken();
    emit(const AuthUnauthenticated());
  }

  /// Сессия истекла
  Future<void> _onSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    // Остановить фоновое обновление токенов
    _tokenRefreshService?.stop();

    // Сначала показываем предупреждение
    emit(const AuthSessionExpiredState());

    // Небольшая задержка для показа сообщения
    await Future<void>.delayed(const Duration(seconds: 2));

    // Проверяем что BLoC не закрыт после await
    if (isClosed) {
      return;
    }

    // Очищаем токены
    await _storageService.deleteToken();

    // Проверяем что BLoC не закрыт после await
    if (isClosed) {
      return;
    }

    // Переходим в неавторизованное состояние
    emit(const AuthUnauthenticated());
  }

  /// Подтверждение email
  Future<void> _onVerifyEmailRequested(
    AuthVerifyEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final request = VerifyEmailRequest(
        email: event.email,
        code: event.code,
      );

      await _authService.verifyEmail(request);

      emit(const AuthEmailVerified());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Повторная отправка кода
  Future<void> _onResendCodeRequested(
    AuthResendCodeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final request = ResendCodeRequest(
        email: event.email,
      );

      await _authService.resendCode(request);

      emit(const AuthCodeResent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Запрос сброса пароля (отправка кода на email)
  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final request = ForgotPasswordRequest(
        email: event.email,
      );

      await _authService.forgotPassword(request);

      emit(AuthPasswordResetCodeSent(email: event.email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Сброс пароля по коду
  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final request = ResetPasswordRequest(
        email: event.email,
        code: event.code,
        newPassword: event.newPassword,
      );

      await _authService.resetPassword(request);

      emit(const AuthPasswordReset());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Смена пароля (авторизованный пользователь)
  Future<void> _onChangePasswordRequested(
    AuthChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final accessToken = await _storageService.getToken();
      if (accessToken == null || accessToken.isEmpty) {
        emit(const AuthError('Not authenticated'));
        return;
      }

      final request = ChangePasswordRequest(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );

      await _authService.changePassword(request, accessToken);

      // После смены пароля нужно перелогиниться (все токены отозваны на сервере)
      _tokenRefreshService?.stop();
      await _storageService.deleteToken();
      emit(const AuthPasswordChanged());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Обновление профиля
  Future<void> _onUpdateProfileRequested(
    AuthUpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Сохраняем текущее состояние для восстановления токенов
    final currentState = state;
    emit(const AuthLoading());

    try {
      final accessToken = await _storageService.getToken();
      final refreshToken = await _storageService.getRefreshToken();

      if (accessToken == null || accessToken.isEmpty) {
        emit(const AuthError('Not authenticated'));
        return;
      }

      final request = UpdateProfileRequest(
        firstName: event.firstName,
        lastName: event.lastName,
      );

      final updatedUser = await _authService.updateProfile(request, accessToken);

      // Возвращаем AuthAuthenticated с обновленным пользователем
      emit(AuthAuthenticated(
        user: updatedUser,
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
      ));

      // Также эмитим событие успеха для UI
      emit(AuthProfileUpdated(user: updatedUser));

      // И снова возвращаем AuthAuthenticated для стабильного состояния
      if (currentState is AuthAuthenticated) {
        emit(AuthAuthenticated(
          user: updatedUser,
          accessToken: accessToken,
          refreshToken: refreshToken ?? '',
        ));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
