/// Legacy app_snackbar.dart - Redirects to modular snackbar system
///
/// This file maintains backward compatibility by exporting the new
/// modular snackbar system. All functionality has been refactored
/// into smaller, maintainable components in the snackbar/ directory.
///
/// File structure:
/// - snackbar/app_snackbar.dart - Main export file
/// - snackbar/base_snackbar.dart - Base snackbar with shared logic
/// - snackbar/success_snackbar.dart - Success variant
/// - snackbar/error_snackbar.dart - Error variant
/// - snackbar/warning_snackbar.dart - Warning variant
/// - snackbar/info_snackbar.dart - Info variant
/// - snackbar/loading_snackbar.dart - Loading snackbar
/// - snackbar/toast_notification.dart - Toast system
/// - snackbar/snackbar_types.dart - Enums and configs
/// - snackbar/responsive_utils.dart - Web-responsive utilities
library;

export 'snackbar/app_snackbar.dart';