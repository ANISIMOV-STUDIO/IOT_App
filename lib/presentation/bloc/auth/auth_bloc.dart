/// Authentication BLoC
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/entities/user.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class SkipAuthEvent extends AuthEvent {
  const SkipAuthEvent();
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService _apiService;

  AuthBloc({required ApiService apiService})
      : _apiService = apiService,
        super(const AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<SkipAuthEvent>(_onSkipAuth);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (_apiService.isAuthenticated) {
      try {
        final userData = await _apiService.getCurrentUser();
        final user = UserModel.fromJson(userData['user'] ?? userData);
        emit(AuthAuthenticated(user));
      } catch (e) {
        // Token might be invalid
        await _apiService.clearAuthToken();
        emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final response = await _apiService.login(
        email: event.email,
        password: event.password,
      );

      final user = UserModel.fromJson(response['user']);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      // Return to unauthenticated state after showing error
      await Future.delayed(const Duration(seconds: 3));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final response = await _apiService.register(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      final user = UserModel.fromJson(response['user']);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      // Return to unauthenticated state after showing error
      await Future.delayed(const Duration(seconds: 3));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _apiService.logout();
    } finally {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSkipAuth(
    SkipAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    // Create a temporary guest user
    final guestUser = User(
      id: 'guest',
      email: 'guest@temp.com',
      name: 'Guest User',
      createdAt: DateTime.now(),
    );

    emit(AuthAuthenticated(guestUser));
  }
}
