/// Auth BLoC
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/auth_storage_service.dart';
import '../../../data/models/auth_models.dart';
import '../../../data/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC для управления состоянием аутентификации
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final AuthStorageService _storageService;

  AuthBloc({
    required AuthService authService,
    required AuthStorageService storageService,
  })  : _authService = authService,
        _storageService = storageService,
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

      if (accessToken != null && accessToken.isNotEmpty &&
          refreshToken != null && refreshToken.isNotEmpty) {
        final user = await _authService.getCurrentUser(accessToken);
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
      emit(AuthRegistered(
        email: response.email,
        password: event.password,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Выход
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
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
}
