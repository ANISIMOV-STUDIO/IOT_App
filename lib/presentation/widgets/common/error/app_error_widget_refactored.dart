/// Refactored comprehensive error widget
///
/// Split into smaller components following SOLID principles
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../generated/l10n/app_localizations.dart';
import 'error_types.dart';
import 'error_icon_widget.dart';
import 'error_actions_widget.dart';

/// Main error widget - refactored to <300 lines
class AppErrorWidgetRefactored extends StatelessWidget {
  final ErrorConfig config;

  const AppErrorWidgetRefactored({
    super.key,
    required this.config,
  });

  /// Factory constructor for network errors
  factory AppErrorWidgetRefactored.network({
    required BuildContext context,
    VoidCallback? onRetry,
    String? customMessage,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return AppErrorWidgetRefactored(
      config: ErrorConfig(
        title: l10n.connectionError,
        message: customMessage ?? l10n.unableToConnect,
        icon: Icons.wifi_off_rounded,
        onRetry: onRetry,
        type: ErrorType.network,
      ),
    );
  }

  /// Factory constructor for server errors
  factory AppErrorWidgetRefactored.server({
    required BuildContext context,
    VoidCallback? onRetry,
    String? errorCode,
    String? technicalDetails,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return AppErrorWidgetRefactored(
      config: ErrorConfig(
        title: l10n.serverError,
        message: l10n.serverErrorMessage,
        icon: Icons.cloud_off_rounded,
        errorCode: errorCode,
        technicalDetails: technicalDetails,
        onRetry: onRetry,
        type: ErrorType.server,
      ),
    );
  }

  /// Factory constructor for permission errors
  factory AppErrorWidgetRefactored.permission({
    required BuildContext context,
    VoidCallback? onRetry,
    String? customMessage,
    List<ErrorAction>? actions,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return AppErrorWidgetRefactored(
      config: ErrorConfig(
        title: l10n.permissionRequired,
        message: customMessage ?? l10n.permissionRequiredMessage,
        icon: Icons.lock_outline_rounded,
        onRetry: onRetry,
        additionalActions: actions,
        type: ErrorType.permission,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      label: '${config.title ?? l10n.error}: ${config.message}',
      hint: config.onRetry != null ? l10n.doubleTapToRetry : null,
      button: config.onRetry != null,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveUtils.getMaxContentWidth(context),
          ),
          padding: EdgeInsets.all(
            ResponsiveUtils.scaledSpacing(context, HvacSpacing.xl),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Error icon
              ErrorIconWidget(
                icon: config.icon,
                type: config.type,
                size: ResponsiveUtils.scaledIconSize(context, 72.0),
              ),
              const SizedBox(height: HvacSpacing.lg),

              // Title
              _buildTitle(context, theme),
              const SizedBox(height: HvacSpacing.sm),

              // Message
              _buildMessage(context, theme),

              // Error code
              if (config.errorCode != null) ...[
                const SizedBox(height: HvacSpacing.md),
                _ErrorCodeWidget(errorCode: config.errorCode!),
              ],

              // Technical details
              if (config.showTechnicalDetails &&
                  config.technicalDetails != null) ...[
                const SizedBox(height: HvacSpacing.md),
                _TechnicalDetailsWidget(details: config.technicalDetails!),
              ],

              const SizedBox(height: HvacSpacing.xl),

              // Actions
              ErrorActionsWidget(
                onRetry: config.onRetry,
                additionalActions: config.additionalActions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveTitle = config.title ?? l10n.somethingWentWrong;

    return Text(
      effectiveTitle,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: ResponsiveUtils.scaledFontSize(context, 24),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(BuildContext context, ThemeData theme) {
    return Text(
      config.message,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        fontSize: ResponsiveUtils.scaledFontSize(context, 16),
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Error code widget component
class _ErrorCodeWidget extends StatelessWidget {
  final String errorCode;

  const _ErrorCodeWidget({required this.errorCode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: errorCode));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorCodeCopied),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: HvacSpacing.md,
          vertical: HvacSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(HvacSpacing.xs),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.copy_rounded,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: HvacSpacing.xs),
            Text(
              '${l10n.errorCode}: $errorCode',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Technical details widget component
class _TechnicalDetailsWidget extends StatefulWidget {
  final String details;

  const _TechnicalDetailsWidget({required this.details});

  @override
  State<_TechnicalDetailsWidget> createState() =>
      _TechnicalDetailsWidgetState();
}

class _TechnicalDetailsWidgetState extends State<_TechnicalDetailsWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        TextButton.icon(
          onPressed: () => setState(() => _expanded = !_expanded),
          icon: Icon(
            _expanded ? Icons.expand_less : Icons.expand_more,
            size: 20,
          ),
          label: Text(l10n.technicalDetails),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: HvacSpacing.sm),
          Container(
            padding: const EdgeInsets.all(HvacSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(HvacRadius.sm),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: SelectableText(
              widget.details,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
