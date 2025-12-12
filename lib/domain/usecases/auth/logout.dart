/// Logout Use Case
///
/// Business logic for user logout
library;

import '../../repositories/auth_repository.dart';
import '../../../core/services/talker_service.dart';

/// Use case for user logout
///
/// Handles business logic for logging out users
/// and cleaning up authentication state
class Logout {
  final AuthRepository _repository;

  const Logout(this._repository);

  /// Execute the logout use case
  ///
  /// Clears authentication tokens and user data
  /// Always succeeds (errors are logged but not thrown)
  Future<void> call() async {
    try {
      // Notify server about logout if needed
      await _repository.logout();
    } catch (e) {
      // Log error but don't throw - logout should always succeed locally
      // even if server notification fails
      talker.debug('Logout server notification failed: $e');
    } finally {
      // Always clear local authentication state
      await _repository.clearAuthToken();
    }
  }
}
