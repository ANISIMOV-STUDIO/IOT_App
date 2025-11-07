/// Check Auth Status Use Case
///
/// Business logic for verifying authentication status
library;

import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Use case for checking authentication status
///
/// Verifies if user is authenticated and returns user data
/// Used on app startup and after token refresh
class CheckAuthStatus {
  final AuthRepository _repository;

  const CheckAuthStatus(this._repository);

  /// Execute the check auth status use case
  ///
  /// Returns authenticated [User] if valid session exists
  /// Returns null if not authenticated
  /// Throws [Exception] if token is expired or invalid
  Future<User?> call() async {
    // Check if authentication token exists
    if (!_repository.isAuthenticated) {
      return null;
    }

    try {
      // Verify token validity with server
      final isValid = await _repository.isTokenValid();

      if (!isValid) {
        // Try to refresh token if invalid
        try {
          await _repository.refreshToken();
        } catch (e) {
          // Refresh failed, clear auth state
          await _repository.clearAuthToken();
          return null;
        }
      }

      // Get current user data
      final user = await _repository.getCurrentUser();

      if (user == null) {
        // Token exists but user data unavailable
        // Clear invalid auth state
        await _repository.clearAuthToken();
        return null;
      }

      return user;
    } catch (e) {
      // Any error in auth check means user is not authenticated
      // Clear potentially corrupted auth state
      await _repository.clearAuthToken();

      // Re-throw for specific error handling if needed
      if (e.toString().contains('network')) {
        throw Exception('Cannot verify authentication. Check your connection');
      }

      return null;
    }
  }
}
