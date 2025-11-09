/// Authentication BLoC - Clean Architecture Version
///
/// Refactored to follow clean architecture principles
/// Uses domain use cases instead of direct repository access
library;

import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auth/login.dart';
import '../../../domain/usecases/auth/logout.dart';
import '../../../domain/usecases/auth/register.dart';
import '../../../domain/usecases/auth/check_auth_status.dart';
import '../../../domain/usecases/auth/skip_auth.dart';

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
  final String? confirmPassword;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.name,
    this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, password, name, confirmPassword];
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

/// Authentication BLoC
///
/// Manages authentication state using clean architecture principles
/// All business logic is delegated to use cases
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Logout _logout;
  final Register _register;
  final CheckAuthStatus _checkAuthStatus;
  final SkipAuth _skipAuth;

  AuthBloc({
    required Login login,
    required Logout logout,
    required Register register,
    required CheckAuthStatus checkAuthStatus,
    required SkipAuth skipAuth,
  })  : _login = login,
        _logout = logout,
        _register = register,
        _checkAuthStatus = checkAuthStatus,
        _skipAuth = skipAuth,
        super(const AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<SkipAuthEvent>(_onSkipAuth);
  }

  /// Handle check auth status event
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _checkAuthStatus();

      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      // Network errors during auth check are not critical
      // User can still use the app offline if previously authenticated
      if (e.toString().contains('network')) {
        emit(const AuthUnauthenticated());
      } else {
        emit(AuthError(_formatError(e)));
        // Return to unauthenticated after error
        await Future.delayed(const Duration(seconds: 2));
        if (!isClosed) {
          emit(const AuthUnauthenticated());
        }
      }
    }
  }

  /// Handle login event
  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final params = LoginParams(
        email: event.email,
        password: event.password,
      );

      final user = await _login(params);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_formatError(e)));
      // Return to unauthenticated state after showing error
      await Future.delayed(const Duration(seconds: 3));
      if (!isClosed) {
        emit(const AuthUnauthenticated());
      }
    }
  }

  /// Handle register event
  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final params = RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
        confirmPassword: event.confirmPassword,
      );

      final user = await _register(params);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_formatError(e)));
      // Return to unauthenticated state after showing error
      await Future.delayed(const Duration(seconds: 3));
      if (!isClosed) {
        emit(const AuthUnauthenticated());
      }
    }
  }

  /// Handle logout event
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _logout();
    } finally {
      // Always emit unauthenticated after logout
      emit(const AuthUnauthenticated());
    }
  }

  /// Handle skip auth event
  Future<void> _onSkipAuth(
    SkipAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final guestUser = await _skipAuth();
      emit(AuthAuthenticated(guestUser));
    } catch (e) {
      emit(AuthError(_formatError(e)));
      // Return to unauthenticated state after error
      await Future.delayed(const Duration(seconds: 2));
      if (!isClosed) {
        emit(const AuthUnauthenticated());
      }
    }
  }

  /// Format error messages for display
  String _formatError(dynamic error) {
    String message = error.toString();

    // Remove exception prefix if present
    message = message.replaceAll('Exception: ', '');

    // Capitalize first letter
    if (message.isNotEmpty) {
      message = message[0].toUpperCase() + message.substring(1);
    }

    return message;
  }
}
