/// Authentication Repository Interface
///
/// Abstract repository defining the contract for authentication operations
/// following clean architecture principles
library;

import '../entities/user.dart';

/// Interface for authentication data operations
abstract class AuthRepository {
  /// Login with email and password
  /// Returns authenticated [User] on success
  /// Throws [Exception] on failure
  Future<User> login({
    required String email,
    required String password,
  });

  /// Register a new user account
  /// Returns newly created [User] on success
  /// Throws [Exception] on failure
  Future<User> register({
    required String email,
    required String password,
    required String name,
  });

  /// Logout the current user
  /// Clears authentication tokens and cached data
  Future<void> logout();

  /// Get the currently authenticated user
  /// Returns [User] if authenticated, null otherwise
  Future<User?> getCurrentUser();

  /// Check if user is authenticated
  /// Returns true if valid authentication token exists
  bool get isAuthenticated;

  /// Get stored authentication token
  /// Returns token string if exists, null otherwise
  String? get authToken;

  /// Store authentication token
  /// Persists token for future API calls
  Future<void> saveAuthToken(String token);

  /// Clear stored authentication token
  /// Removes token from persistent storage
  Future<void> clearAuthToken();

  /// Refresh authentication token
  /// Returns new token if refresh successful
  /// Throws [Exception] if refresh fails
  Future<String> refreshToken();

  /// Verify if current token is valid
  /// Returns true if token is valid and not expired
  Future<bool> isTokenValid();
}
