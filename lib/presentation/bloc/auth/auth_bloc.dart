/// Auth BLoC
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/services/auth_storage_service.dart';
import 'package:hvac_control/core/services/token_refresh_service.dart';
import 'package:hvac_control/data/api/http/clients/user_http_client.dart';
import 'package:hvac_control/data/api/http/interceptors/auth_http_interceptor.dart';
import 'package:hvac_control/data/models/auth_models.dart';
import 'package:hvac_control/data/services/auth_service.dart';
import 'package:hvac_control/domain/entities/user_preferences.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_event.dart';
import 'package:hvac_control/presentation/bloc/auth/auth_state.dart';

/// BLoC для управления состоянием аутентификации
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthService authService,
    required AuthStorageService storageService,
    TokenRefreshService? tokenRefreshService,
    UserHttpClient? userHttpClient,
  })  : _authService = authService,
        _storageService = storageService,
        _tokenRefreshService = tokenRefreshService,
        _userHttpClient = userHttpClient,
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
    on<AuthUpdatePreferencesRequested>(_onUpdatePreferencesRequested);

    // Подписка на события истечения сессии от TokenRefreshService
    _sessionExpiredSubscription = _tokenRefreshService?.onSessionExpired.listen((_) {
      if (!isClosed) {
        add(const AuthSessionExpired());
      }
    });
  }

  final AuthService _authService;
  final AuthStorageService _storageService;
  final TokenRefreshService? _tokenRefreshService;
  final UserHttpClient? _userHttpClient;
  StreamSubscription<void>? _sessionExpiredSubscription;

  /// Временное хранение credentials для авто-логина после верификации email
  /// Очищается сразу после использования, при logout, или по таймауту
  String? _pendingEmail;
  String? _pendingPassword;
  Timer? _credentialsTimeoutTimer;

  /// Таймаут для автоматической очистки credentials (15 минут)
  static const _credentialsTimeout = Duration(minutes: 15);

  @override
  Future<void> close() {
    _clearPendingCredentials();
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

        // Загрузить настройки пользователя
        final preferences = await _loadPreferences();

        emit(AuthAuthenticated(
          user: user,
          accessToken: accessToken,
          refreshToken: refreshToken,
          preferences: preferences,
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

      // Загрузить настройки пользователя
      final preferences = await _loadPreferences();

      emit(AuthAuthenticated(
        user: response.user,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        preferences: preferences,
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

      // Сохраняем credentials для авто-логина после верификации (с таймаутом)
      _setPendingCredentials(event.email, event.password);

      // Регистрация успешна, требуется подтверждение email
      emit(AuthRegistered(email: response.email));
    } catch (e) {
      _clearPendingCredentials();
      emit(AuthError(e.toString()));
    }
  }

  /// Очистка временных credentials
  void _clearPendingCredentials() {
    _credentialsTimeoutTimer?.cancel();
    _credentialsTimeoutTimer = null;
    _pendingEmail = null;
    _pendingPassword = null;
  }

  /// Сохранение credentials с автоматическим таймаутом
  void _setPendingCredentials(String email, String password) {
    // Очищаем предыдущие credentials и таймер
    _clearPendingCredentials();

    _pendingEmail = email;
    _pendingPassword = password;

    // Запускаем таймер для автоматической очистки
    _credentialsTimeoutTimer = Timer(_credentialsTimeout, _clearPendingCredentials);
  }

  /// Обработка успешной авторизации (общий код для login и verify)
  Future<void> _handleAuthResponse(
    AuthResponse response,
    Emitter<AuthState> emit,
  ) async {
    // Сохранить токены
    await _storageService.saveTokens(
      response.accessToken,
      response.refreshToken,
    );
    await _storageService.saveUserId(response.user.id);

    // Сбросить состояние сессии
    AuthHttpInterceptor.resetSessionState();

    // Запустить фоновое обновление токенов
    _tokenRefreshService?.start();

    // Загрузить настройки пользователя
    final preferences = await _loadPreferences();

    emit(AuthAuthenticated(
      user: response.user,
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      preferences: preferences,
    ));
  }

  /// Выход
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Очистить временные credentials
    _clearPendingCredentials();

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
    // Очистить временные credentials
    _clearPendingCredentials();

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
    // Очистить временные credentials
    _clearPendingCredentials();

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

  /// Подтверждение email с авто-логином
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

      // Верификация — бэкенд может вернуть токены сразу
      final verifyResponse = await _authService.verifyEmail(request);

      // Если бэкенд вернул токены — используем их напрямую
      if (verifyResponse != null) {
        _clearPendingCredentials();
        await _handleAuthResponse(verifyResponse, emit);
        return;
      }

      // Fallback: авто-логин если есть сохранённые credentials
      if (_pendingEmail != null && _pendingPassword != null) {
        try {
          final loginRequest = LoginRequest(
            email: _pendingEmail!,
            password: _pendingPassword!,
          );

          final response = await _authService.login(loginRequest);

          // Очищаем временные credentials
          _clearPendingCredentials();

          await _handleAuthResponse(response, emit);
          return;
        } catch (loginError) {
          // Если авто-логин не удался, показываем что email подтверждён
          // и пользователь войдёт вручную
          _clearPendingCredentials();
          emit(const AuthEmailVerified());
          return;
        }
      }

      // Нет сохранённых credentials — обычный flow
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

      // Сохраняем preferences из текущего состояния
      final currentPreferences = currentState is AuthAuthenticated
          ? currentState.preferences
          : null;

      // Возвращаем AuthAuthenticated с обновленным пользователем
      emit(AuthAuthenticated(
        user: updatedUser,
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
        preferences: currentPreferences,
      ));

      // Также эмитим событие успеха для UI
      emit(AuthProfileUpdated(user: updatedUser));

      // И снова возвращаем AuthAuthenticated для стабильного состояния
      if (currentState is AuthAuthenticated) {
        emit(AuthAuthenticated(
          user: updatedUser,
          accessToken: accessToken,
          refreshToken: refreshToken ?? '',
          preferences: currentPreferences,
        ));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Обновление настроек пользователя
  Future<void> _onUpdatePreferencesRequested(
    AuthUpdatePreferencesRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AuthAuthenticated) {
      emit(const AuthError('Not authenticated'));
      return;
    }

    final oldPreferences = currentState.preferences ?? const UserPreferences();

    // Оптимистичное обновление UI
    final optimisticPreferences = oldPreferences.copyWith(
      pushNotificationsEnabled: event.pushNotificationsEnabled,
      emailNotificationsEnabled: event.emailNotificationsEnabled,
      theme: event.theme != null
          ? PreferenceTheme.fromString(event.theme!)
          : null,
      language: event.language != null
          ? PreferenceLanguage.fromString(event.language!)
          : null,
    );
    emit(currentState.copyWith(preferences: optimisticPreferences));

    try {
      final updatedPreferences = await _userHttpClient?.updatePreferences(
        pushNotificationsEnabled: event.pushNotificationsEnabled,
        emailNotificationsEnabled: event.emailNotificationsEnabled,
        theme: event.theme,
        language: event.language,
      );

      // Обновляем состояние данными с сервера (могут отличаться)
      if (updatedPreferences != null) {
        emit(currentState.copyWith(preferences: updatedPreferences));
      }
    } catch (e) {
      developer.log(
        'Failed to update preferences: $e',
        name: 'AuthBloc',
        error: e,
      );
      // Откат к предыдущим настройкам при ошибке
      emit(currentState.copyWith(preferences: oldPreferences));
    }
  }

  /// Загрузить настройки пользователя с сервера
  Future<UserPreferences?> _loadPreferences() async {
    try {
      return await _userHttpClient?.getPreferences();
    } catch (e) {
      developer.log(
        'Failed to load preferences: $e',
        name: 'AuthBloc',
        error: e,
      );
      // Возвращаем дефолтные настройки при ошибке
      return const UserPreferences();
    }
  }
}
