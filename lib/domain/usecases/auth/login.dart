/// Login Use Case
///
/// Business logic for user authentication
library;

import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Parameters for login use case
class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

/// Use case for user login
///
/// Handles business logic for authenticating users
/// following clean architecture principles
class Login {
  final AuthRepository _repository;

  const Login(this._repository);

  /// Execute the login use case
  ///
  /// Validates input and delegates to repository
  /// Returns authenticated [User] on success
  /// Throws [Exception] with descriptive message on failure
  Future<User> call(LoginParams params) async {
    // Validate email format
    if (!_isValidEmail(params.email)) {
      throw Exception('Invalid email format');
    }

    // Validate password requirements
    if (params.password.isEmpty) {
      throw Exception('Password cannot be empty');
    }

    if (params.password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    try {
      // Delegate to repository for actual authentication
      final user = await _repository.login(
        email: params.email.toLowerCase().trim(),
        password: params.password,
      );

      // Store authentication token if login successful
      // This is handled internally by the repository

      return user;
    } catch (e) {
      // Transform repository exceptions to domain exceptions
      if (e.toString().contains('401')) {
        throw Exception('Invalid email or password');
      } else if (e.toString().contains('network')) {
        throw Exception('Network error. Please check your connection');
      } else {
        throw Exception('Login failed: ${e.toString()}');
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
}