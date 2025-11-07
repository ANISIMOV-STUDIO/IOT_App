/// Error types and models for error widgets
library;

import 'package:flutter/material.dart';

/// Types of errors that can be displayed
enum ErrorType {
  general,
  network,
  server,
  permission,
  validation,
  authentication,
  timeout,
  notFound,
  offline,
}

/// Action that can be taken on an error
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

/// Error widget configuration
class ErrorConfig {
  final String? title;
  final String message;
  final IconData? icon;
  final ErrorType type;
  final String? errorCode;
  final String? technicalDetails;
  final bool showTechnicalDetails;
  final VoidCallback? onRetry;
  final List<ErrorAction>? additionalActions;

  const ErrorConfig({
    this.title,
    required this.message,
    this.icon,
    this.type = ErrorType.general,
    this.errorCode,
    this.technicalDetails,
    this.showTechnicalDetails = false,
    this.onRetry,
    this.additionalActions,
  });
}