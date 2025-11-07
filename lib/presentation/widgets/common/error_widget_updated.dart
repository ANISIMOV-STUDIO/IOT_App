/// Updated error widget using refactored components
///
/// This file now acts as a facade for the refactored error components
library;

import 'package:flutter/material.dart';
import 'error/error_types.dart';
import 'error/app_error_widget_refactored.dart';

export 'error/error_types.dart';
export 'error/app_error_widget_refactored.dart';

/// Main error widget - now a thin wrapper around refactored components
class AppErrorWidget extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? errorCode;
  final String? technicalDetails;
  final bool showTechnicalDetails;
  final List<ErrorAction>? additionalActions;
  final ErrorType type;

  const AppErrorWidget({
    super.key,
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

  /// Factory constructor for network errors
  factory AppErrorWidget.network({
    required BuildContext context,
    VoidCallback? onRetry,
    String? customMessage,
  }) {
    return AppErrorWidget._fromRefactored(
      AppErrorWidgetRefactored.network(
        context: context,
        onRetry: onRetry,
        customMessage: customMessage,
      ),
    );
  }

  /// Factory constructor for server errors
  factory AppErrorWidget.server({
    required BuildContext context,
    VoidCallback? onRetry,
    String? errorCode,
    String? technicalDetails,
  }) {
    return AppErrorWidget._fromRefactored(
      AppErrorWidgetRefactored.server(
        context: context,
        onRetry: onRetry,
        errorCode: errorCode,
        technicalDetails: technicalDetails,
      ),
    );
  }

  /// Factory constructor for permission errors
  factory AppErrorWidget.permission({
    required BuildContext context,
    VoidCallback? onRetry,
    String? customMessage,
    List<ErrorAction>? actions,
  }) {
    return AppErrorWidget._fromRefactored(
      AppErrorWidgetRefactored.permission(
        context: context,
        onRetry: onRetry,
        customMessage: customMessage,
        actions: actions,
      ),
    );
  }

  /// Private constructor to create from refactored widget
  factory AppErrorWidget._fromRefactored(AppErrorWidgetRefactored refactored) {
    final config = refactored.config;
    return AppErrorWidget(
      title: config.title,
      message: config.message,
      onRetry: config.onRetry,
      icon: config.icon,
      errorCode: config.errorCode,
      technicalDetails: config.technicalDetails,
      showTechnicalDetails: config.showTechnicalDetails,
      additionalActions: config.additionalActions,
      type: config.type,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Delegate to the refactored widget
    return AppErrorWidgetRefactored(
      config: ErrorConfig(
        title: title,
        message: message,
        icon: icon,
        type: type,
        errorCode: errorCode,
        technicalDetails: technicalDetails,
        showTechnicalDetails: showTechnicalDetails,
        onRetry: onRetry,
        additionalActions: additionalActions,
      ),
    );
  }
}
