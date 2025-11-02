/// Skip Auth Use Case
///
/// Business logic for guest/demo mode access
library;

import '../../entities/user.dart';

/// Use case for skipping authentication
///
/// Allows users to access the app in guest/demo mode
/// with limited functionality
class SkipAuth {
  const SkipAuth();

  /// Execute the skip auth use case
  ///
  /// Creates a temporary guest user for demo access
  /// Returns guest [User] with limited permissions
  Future<User> call() async {
    // Create guest user with predefined limitations
    final guestUser = User(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      email: 'guest@demo.local',
      name: 'Guest User',
      createdAt: DateTime.now(),
      isGuest: true,
      permissions: const [
        'view_devices',
        'view_analytics',
        'view_settings',
        // Guest users cannot:
        // - modify device settings
        // - add/remove devices
        // - access schedule management
        // - save preferences
      ],
    );

    // Simulate async operation for consistency
    await Future.delayed(const Duration(milliseconds: 100));

    return guestUser;
  }
}