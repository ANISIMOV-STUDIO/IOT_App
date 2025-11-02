/// Register Use Case
///
/// Business logic for user registration
library;

import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Parameters for register use case
class RegisterParams {
  final String email;
  final String password;
  final String name;
  final String? confirmPassword;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    this.confirmPassword,
  });
}

/// Use case for user registration
///
/// Handles business logic for creating new user accounts
/// with proper validation and error handling
class Register {
  final AuthRepository _repository;

  const Register(this._repository);

  /// Execute the register use case
  ///
  /// Validates input and creates new user account
  /// Returns newly created [User] on success
  /// Throws [Exception] with descriptive message on failure
  Future<User> call(RegisterParams params) async {
    // Validate name
    if (params.name.trim().isEmpty) {
      throw Exception('Name cannot be empty');
    }

    if (params.name.trim().length < 2) {
      throw Exception('Name must be at least 2 characters');
    }

    // Validate email format
    if (!_isValidEmail(params.email)) {
      throw Exception('Invalid email format');
    }

    // Validate password strength
    final passwordError = _validatePassword(params.password);
    if (passwordError != null) {
      throw Exception(passwordError);
    }

    // Validate password confirmation if provided
    if (params.confirmPassword != null &&
        params.password != params.confirmPassword) {
      throw Exception('Passwords do not match');
    }

    try {
      // Delegate to repository for actual registration
      final user = await _repository.register(
        email: params.email.toLowerCase().trim(),
        password: params.password,
        name: params.name.trim(),
      );

      // Authentication token is automatically stored by repository

      return user;
    } catch (e) {
      // Transform repository exceptions to domain exceptions
      if (e.toString().contains('already exists') ||
          e.toString().contains('409')) {
        throw Exception('An account with this email already exists');
      } else if (e.toString().contains('network')) {
        throw Exception('Network error. Please check your connection');
      } else {
        throw Exception('Registration failed: ${e.toString()}');
      }
    }
  }

  /// Validate email format using regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate password strength
  ///
  /// Returns error message if invalid, null if valid
  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Check for at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one number
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    // Check for at least one special character
    if (!password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null; // Password is valid
  }
}