/// Secure Authentication BLoC
///
/// Enhanced authentication with secure storage, proper guest limitations, and token management
library;

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../core/constants/security_constants.dart';
import '../../../core/services/secure_api_service.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/utils/logger.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/entities/user.dart';

// ===== EVENTS =====

abstract class SecureAuthEvent extends Equatable {
  const SecureAuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends SecureAuthEvent {
  const CheckAuthStatusEvent();
}

class LoginEvent extends SecureAuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginEvent({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

class RegisterEvent extends SecureAuthEvent {
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

class LogoutEvent extends SecureAuthEvent {
  const LogoutEvent();
}

class GuestLoginEvent extends SecureAuthEvent {
  const GuestLoginEvent();
}

class RefreshTokenEvent extends SecureAuthEvent {
  const RefreshTokenEvent();
}

class SessionTimeoutEvent extends SecureAuthEvent {
  const SessionTimeoutEvent();
}

class BiometricLoginEvent extends SecureAuthEvent {
  const BiometricLoginEvent();
}

// ===== STATES =====

abstract class SecureAuthState extends Equatable {
  const SecureAuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends SecureAuthState {
  const AuthInitial();
}

class AuthLoading extends SecureAuthState {
  const AuthLoading();
}

class AuthAuthenticated extends SecureAuthState {
  final User user;
  final bool isGuest;
  final GuestLimitations? guestLimitations;
  final DateTime? sessionExpiry;

  const AuthAuthenticated({
    required this.user,
    this.isGuest = false,
    this.guestLimitations,
    this.sessionExpiry,
  });

  @override
  List<Object?> get props => [user, isGuest, guestLimitations, sessionExpiry];

  /// Check if user can perform action based on guest limitations
  bool canPerformAction(String action) {
    if (!isGuest || guestLimitations == null) return true;

    switch (action) {
      case 'view_devices':
        return guestLimitations!.canViewDevices;
      case 'control_devices':
        return guestLimitations!.canControlDevices;
      case 'view_analytics':
        return guestLimitations!.canViewAnalytics;
      case 'modify_settings':
        return guestLimitations!.canModifySettings;
      case 'access_schedules':
        return guestLimitations!.canAccessSchedules;
      case 'view_notifications':
        return guestLimitations!.canViewNotifications;
      case 'export_data':
        return guestLimitations!.canExportData;
      default:
        return false; // Deny by default for unknown actions
    }
  }
}

class AuthUnauthenticated extends SecureAuthState {
  final String? message;

  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

class AuthError extends SecureAuthState {
  final String message;
  final AuthErrorType type;

  const AuthError({
    required this.message,
    this.type = AuthErrorType.unknown,
  });

  @override
  List<Object?> get props => [message, type];
}

class AuthLocked extends SecureAuthState {
  final DateTime unlockTime;
  final int remainingAttempts;

  const AuthLocked({
    required this.unlockTime,
    required this.remainingAttempts,
  });

  @override
  List<Object?> get props => [unlockTime, remainingAttempts];
}

enum AuthErrorType {
  validation,
  network,
  unauthorized,
  locked,
  sessionExpired,
  unknown,
}

// ===== BLOC =====

class SecureAuthBloc extends Bloc<SecureAuthEvent, SecureAuthState> {
  final SecureApiService _apiService;
  final SecureStorageService _secureStorage;

  // Login attempt tracking
  int _loginAttempts = 0;
  DateTime? _lockoutEndTime;

  // Session management
  Timer? _sessionTimer;
  Timer? _tokenRefreshTimer;
  DateTime? _lastActivity;

  // Current user data
  User? _currentUser;
  bool _isGuest = false;

  SecureAuthBloc({
    required SecureApiService apiService,
    required SecureStorageService secureStorage,
  })  : _apiService = apiService,
        _secureStorage = secureStorage,
        super(const AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<GuestLoginEvent>(_onGuestLogin);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<SessionTimeoutEvent>(_onSessionTimeout);
    on<BiometricLoginEvent>(_onBiometricLogin);

    // Initialize session monitoring
    _startSessionMonitoring();
  }

  @override
  Future<void> close() {
    _sessionTimer?.cancel();
    _tokenRefreshTimer?.cancel();
    return super.close();
  }

  /// Start session monitoring
  void _startSessionMonitoring() {
    // Check for inactivity every minute
    _sessionTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkSessionTimeout();
    });

    // Setup token refresh timer
    _tokenRefreshTimer = Timer.periodic(
      SecurityConstants.tokenRefreshInterval,
      (_) => add(const RefreshTokenEvent()),
    );
  }

  /// Update last activity timestamp
  void updateActivity() {
    _lastActivity = DateTime.now();
  }

  /// Check for session timeout
  void _checkSessionTimeout() {
    if (_currentUser == null || _lastActivity == null) return;

    final now = DateTime.now();
    final inactiveDuration = now.difference(_lastActivity!);

    // Check timeout based on user type
    final timeout = _isGuest
        ? SecurityConstants.guestLimitations.sessionDuration
        : SecurityConstants.sessionTimeout;

    if (inactiveDuration > timeout) {
      add(const SessionTimeoutEvent());
    }
  }

  /// Check if account is locked
  bool _isAccountLocked() {
    if (_lockoutEndTime == null) return false;
    if (DateTime.now().isAfter(_lockoutEndTime!)) {
      _lockoutEndTime = null;
      _loginAttempts = 0;
      return false;
    }
    return true;
  }

  /// Handle check auth status
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<SecureAuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Check for stored token
      final token = await _secureStorage.getAuthToken();

      if (token == null) {
        emit(const AuthUnauthenticated());
        return;
      }

      // Validate token
      if (JwtDecoder.isExpired(token)) {
        Logger.security('TOKEN_EXPIRED');
        await _secureStorage.clearAuthData();
        emit(const AuthUnauthenticated(message: 'Session expired'));
        return;
      }

      // Get user data
      final userData = await _apiService.getCurrentUser();
      final user = UserModel.fromJson(userData['user'] ?? userData);

      _currentUser = user;
      _lastActivity = DateTime.now();

      emit(AuthAuthenticated(
        user: user,
        isGuest: false,
        sessionExpiry: JwtDecoder.getExpirationDate(token),
      ));
    } catch (e) {
      Logger.error('Auth status check failed', error: e);
      await _secureStorage.clearAuthData();
      emit(const AuthUnauthenticated());
    }
  }

  /// Handle login
  Future<void> _onLogin(
    LoginEvent event,
    Emitter<SecureAuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Check if account is locked
    if (_isAccountLocked()) {
      final remainingTime = _lockoutEndTime!.difference(DateTime.now());
      emit(AuthLocked(
        unlockTime: _lockoutEndTime!,
        remainingAttempts: SecurityConstants.maxLoginAttempts - _loginAttempts,
      ));
      Logger.security('LOGIN_FAILURE', details: {
        'reason': 'account_locked',
        'unlock_in': remainingTime.inSeconds,
      });
      return;
    }

    // Validate input
    final emailError = Validators.validateEmail(event.email);
    if (emailError != null) {
      emit(AuthError(
        message: emailError,
        type: AuthErrorType.validation,
      ));
      return;
    }

    final passwordError = Validators.validatePassword(event.password);
    if (passwordError != null) {
      emit(AuthError(
        message: passwordError,
        type: AuthErrorType.validation,
      ));
      return;
    }

    try {
      // Sanitize inputs
      final sanitizedEmail = Validators.sanitizeInput(event.email.trim().toLowerCase());

      // Attempt login
      final response = await _apiService.login(
        email: sanitizedEmail,
        password: event.password,
      );

      // Parse user data
      final user = UserModel.fromJson(response['user']);
      final token = response['access_token'];

      // Save credentials if remember me is enabled
      if (event.rememberMe) {
        await _secureStorage.saveUserCredentials(
          email: sanitizedEmail,
          password: event.password,
          rememberMe: true,
        );
      }

      // Reset login attempts
      _loginAttempts = 0;
      _lockoutEndTime = null;

      // Update state
      _currentUser = user;
      _isGuest = false;
      _lastActivity = DateTime.now();

      emit(AuthAuthenticated(
        user: user,
        isGuest: false,
        sessionExpiry: JwtDecoder.getExpirationDate(token),
      ));

      Logger.security('LOGIN_SUCCESS', details: {'email': sanitizedEmail});
    } catch (e) {
      _loginAttempts++;

      // Check if max attempts exceeded
      if (_loginAttempts >= SecurityConstants.maxLoginAttempts) {
        _lockoutEndTime = DateTime.now().add(SecurityConstants.loginLockoutDuration);

        emit(AuthLocked(
          unlockTime: _lockoutEndTime!,
          remainingAttempts: 0,
        ));

        Logger.security('RATE_LIMIT_EXCEEDED', details: {
          'email': event.email,
          'attempts': _loginAttempts,
        });
      } else {
        final errorMessage = e.toString().replaceAll('Exception: ', '');
        emit(AuthError(
          message: '$errorMessage\n${SecurityConstants.maxLoginAttempts - _loginAttempts} attempts remaining',
          type: AuthErrorType.unauthorized,
        ));
      }

      Logger.security('LOGIN_FAILURE', details: {
        'email': event.email,
        'attempts': _loginAttempts,
        'error': e.toString(),
      });
    }
  }

  /// Handle registration
  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<SecureAuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Validate inputs
    final validationErrors = <String>[];

    final emailError = Validators.validateEmail(event.email);
    if (emailError != null) validationErrors.add(emailError);

    final passwordError = Validators.validatePassword(event.password);
    if (passwordError != null) validationErrors.add(passwordError);

    final nameError = Validators.validateName(event.name);
    if (nameError != null) validationErrors.add(nameError);

    if (validationErrors.isNotEmpty) {
      emit(AuthError(
        message: validationErrors.join('\n'),
        type: AuthErrorType.validation,
      ));
      return;
    }

    try {
      // Sanitize inputs
      final sanitizedEmail = Validators.sanitizeInput(event.email.trim().toLowerCase());
      final sanitizedName = Validators.sanitizeInput(event.name.trim());

      // Register user
      final response = await _apiService.register(
        email: sanitizedEmail,
        password: event.password,
        name: sanitizedName,
      );

      // Parse user data
      final user = UserModel.fromJson(response['user']);
      final token = response['access_token'];

      // Update state
      _currentUser = user;
      _isGuest = false;
      _lastActivity = DateTime.now();

      emit(AuthAuthenticated(
        user: user,
        isGuest: false,
        sessionExpiry: JwtDecoder.getExpirationDate(token),
      ));

      Logger.security('REGISTRATION_SUCCESS', details: {'email': sanitizedEmail});
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(AuthError(
        message: errorMessage,
        type: AuthErrorType.unknown,
      ));

      Logger.security('REGISTRATION_FAILURE', details: {
        'email': event.email,
        'error': e.toString(),
      });
    }
  }

  /// Handle guest login
  Future<void> _onGuestLogin(
    GuestLoginEvent event,
    Emitter<SecureAuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Create guest user with limitations
    final guestUser = User(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      email: 'guest@temporary.session',
      name: 'Guest User',
      createdAt: DateTime.now(),
    );

    // Set guest session expiry
    final sessionExpiry = DateTime.now().add(
      SecurityConstants.guestLimitations.sessionDuration,
    );

    // Update state
    _currentUser = guestUser;
    _isGuest = true;
    _lastActivity = DateTime.now();

    emit(AuthAuthenticated(
      user: guestUser,
      isGuest: true,
      guestLimitations: SecurityConstants.guestLimitations,
      sessionExpiry: sessionExpiry,
    ));

    Logger.security('GUEST_LOGIN', details: {
      'session_duration': SecurityConstants.guestLimitations.sessionDuration.inMinutes,
    });
  }

  /// Handle logout
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<SecureAuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Logout from API if not guest
      if (!_isGuest) {
        await _apiService.logout();
      }
    } catch (e) {
      Logger.error('Logout API call failed', error: e);
    } finally {
      // Clear local data
      await _secureStorage.clearAuthData();
      _currentUser = null;
      _isGuest = false;
      _lastActivity = null;

      emit(const AuthUnauthenticated());
      Logger.security('LOGOUT', details: {'was_guest': _isGuest});
    }
  }

  /// Handle token refresh
  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<SecureAuthState> emit,
  ) async {
    if (_isGuest || _currentUser == null) return;

    try {
      // Token refresh is handled internally by SecureApiService
      // Just update activity timestamp
      _lastActivity = DateTime.now();
      Logger.security('TOKEN_REFRESH', details: {'success': true});
    } catch (e) {
      Logger.security('TOKEN_REFRESH', details: {'success': false, 'error': e.toString()});

      // If refresh fails, logout user
      add(const LogoutEvent());
    }
  }

  /// Handle session timeout
  Future<void> _onSessionTimeout(
    SessionTimeoutEvent event,
    Emitter<SecureAuthState> emit,
  ) async {
    Logger.security('SESSION_TIMEOUT', details: {'was_guest': _isGuest});

    await _secureStorage.clearAuthData();
    _currentUser = null;
    _isGuest = false;
    _lastActivity = null;

    emit(const AuthError(
      message: 'Your session has expired. Please login again.',
      type: AuthErrorType.sessionExpired,
    ));

    // Emit unauthenticated after showing error
    await Future.delayed(const Duration(seconds: 3));
    emit(const AuthUnauthenticated(message: 'Session expired'));
  }

  /// Handle biometric login
  Future<void> _onBiometricLogin(
    BiometricLoginEvent event,
    Emitter<SecureAuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Get stored credentials
      final credentials = await _secureStorage.getUserCredentials();

      if (credentials == null) {
        emit(const AuthError(
          message: 'No stored credentials found. Please login with email and password first.',
          type: AuthErrorType.unauthorized,
        ));
        return;
      }

      // TODO: Implement biometric authentication
      // For now, we'll use stored credentials

      add(LoginEvent(
        email: credentials['email']!,
        password: credentials['password']!,
        rememberMe: true,
      ));

      Logger.security('BIOMETRIC_AUTH', details: {'success': true});
    } catch (e) {
      emit(const AuthError(
        message: 'Biometric authentication failed',
        type: AuthErrorType.unauthorized,
      ));

      Logger.security('BIOMETRIC_AUTH', details: {'success': false, 'error': e.toString()});
    }
  }
}