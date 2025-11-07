/// Error Widget - Refactored Version
///
/// Comprehensive error widget with retry functionality
/// Reduced from 437 lines to <200 lines through component extraction
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../generated/l10n/app_localizations.dart';
import 'error_types.dart';
import 'error_icon.dart';
import 'error_actions.dart';
import 'error_details.dart';

/// Main error widget
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

  factory AppErrorWidget.network({
    required BuildContext context,
    VoidCallback? onRetry,
    String? customMessage,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return AppErrorWidget(
      title: l10n.connectionError,
      message: customMessage ?? l10n.unableToConnect,
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
      type: ErrorType.network,
    );
  }

  factory AppErrorWidget.server({
    required BuildContext context,
    VoidCallback? onRetry,
    String? errorCode,
    String? technicalDetails,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return AppErrorWidget(
      title: l10n.serverError,
      message: l10n.serverErrorMessage,
      icon: Icons.cloud_off_rounded,
      errorCode: errorCode,
      technicalDetails: technicalDetails,
      onRetry: onRetry,
      type: ErrorType.server,
    );
  }

  factory AppErrorWidget.permission({
    required BuildContext context,
    VoidCallback? onRetry,
    String? customMessage,
    List<ErrorAction>? actions,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return AppErrorWidget(
      title: l10n.permissionRequired,
      message: customMessage ?? l10n.permissionRequiredMessage,
      icon: Icons.lock_outline_rounded,
      onRetry: onRetry,
      additionalActions: actions,
      type: ErrorType.permission,
    );
  }

  factory AppErrorWidget.notFound({
    required BuildContext context,
    String? customMessage,
    VoidCallback? onRetry,
  }) {
    return AppErrorWidget(
      title: 'Not Found',
      message: customMessage ?? 'The requested page could not be found',
      icon: Icons.search_off_rounded,
      onRetry: onRetry,
      type: ErrorType.notFound,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      label: '${title ?? l10n.error}: $message',
      hint: onRetry != null ? l10n.doubleTapToRetry : null,
      button: onRetry != null,
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600.w),
          padding: EdgeInsets.all(HvacSpacing.xl.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              ErrorIcon(
                type: type,
                customIcon: icon,
                size: 72.w,
              ),

              SizedBox(height: HvacSpacing.lg.h),

              // Title
              _buildTitle(context, theme),

              SizedBox(height: HvacSpacing.sm.h),

              // Message
              _buildMessage(context, theme),

              // Error details (code + technical)
              ErrorDetails(
                errorCode: errorCode,
                technicalDetails: technicalDetails,
                showTechnicalDetails: showTechnicalDetails,
              ),

              SizedBox(height: HvacSpacing.xl.h),

              // Action buttons
              ErrorActions(
                onRetry: onRetry,
                additionalActions: additionalActions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveTitle = title ?? l10n.somethingWentWrong;

    return Text(
      effectiveTitle,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 24.sp,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(BuildContext context, ThemeData theme) {
    return Text(
      message,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        fontSize: 16.sp,
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}