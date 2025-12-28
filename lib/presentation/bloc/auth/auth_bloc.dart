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
    on<AuthSkipRequested>(_onSkipRequested);
  }

  /// Проверка сохраненной сессии
  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final token = await _storageService.getToken();

      if (token != null && token.isNotEmpty) {
        final user = await _authService.getCurrentUser(token);
        emit(AuthAuthenticated(user: user, token: token));
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

      await _storageService.saveToken(response.token);
      await _storageService.saveUserId(response.user.id);

      emit(AuthAuthenticated(
        user: response.user,
        token: response.token,
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

      await _storageService.saveToken(response.token);
      await _storageService.saveUserId(response.user.id);

      emit(AuthAuthenticated(
        user: response.user,
        token: response.token,
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
    await _storageService.deleteToken();
    emit(const AuthUnauthenticated());
  }

  /// Пропуск (dev mode)
  Future<void> _onSkipRequested(
    AuthSkipRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _storageService.saveSkipped();
    emit(const AuthSkipped());
  }
}
