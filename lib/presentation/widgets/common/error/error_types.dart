/// Error Types and Models
///
/// Common types and models for error handling
library;

import 'package:flutter/material.dart';

/// Types of errors
enum ErrorType {
  general,
  network,
  server,
  permission,
  notFound,
  timeout,
  validation,
  authentication,
  offline,
}

/// Error action for additional buttons
class ErrorAction {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isPrimary;

  const ErrorAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isPrimary = false,
  });
}

/// Error configuration
class ErrorConfig {
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? errorCode;
  final String? technicalDetails;
  final bool showTechnicalDetails;
  final List<ErrorAction>? additionalActions;
  final ErrorType type;

  const ErrorConfig({
    this.title,
    required this.message,
    this.onRetry,
    this.icon,
    this.errorCode,
    this.technicalDetails,
    this.showTechnicalDetails = false,
    this.additionalActions,
    this.type = ErrorType.general,
  });
}
