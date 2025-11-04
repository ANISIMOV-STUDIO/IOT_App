import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Comprehensive error widget with retry functionality
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
          constraints: BoxConstraints(
            maxWidth: ResponsiveUtils.getMaxContentWidth(context),
          ),
          padding: EdgeInsets.all(
            ResponsiveUtils.scaledSpacing(context, HvacSpacing.xl),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(context, theme),
              const SizedBox(height: HvacSpacing.lg),
              _buildTitle(context, theme),
              const SizedBox(height: HvacSpacing.sm),
              _buildMessage(context, theme),
              if (errorCode != null) ...[
                const SizedBox(height: HvacSpacing.md),
                _buildErrorCode(context, theme),
              ],
              if (showTechnicalDetails && technicalDetails != null) ...[
                const SizedBox(height: HvacSpacing.md),
                _buildTechnicalDetails(context, theme),
              ],
              const SizedBox(height: HvacSpacing.xl),
              _buildActions(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, ThemeData theme) {
    final effectiveIcon = icon ?? _getIconForType();
    final iconSize = ResponsiveUtils.scaledIconSize(context, 72.0);
    final iconColor = _getColorForType(theme);

    return Container(
      width: iconSize * 1.5,
      height: iconSize * 1.5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColor.withValues(alpha: 0.1),
      ),
      child: Icon(
        effectiveIcon,
        size: iconSize,
        color: iconColor,
        semanticLabel: 'Error icon',
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
        fontSize: ResponsiveUtils.scaledFontSize(context, 24),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage(BuildContext context, ThemeData theme) {
    return Text(
      message,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        fontSize: ResponsiveUtils.scaledFontSize(context, 16),
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildErrorCode(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        // Copy error code to clipboard
        Clipboard.setData(ClipboardData(text: errorCode!));
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
              Icons.info_outline,
              size: ResponsiveUtils.scaledIconSize(context, 16),
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: HvacSpacing.xs),
            Text(
              l10n.errorCode(errorCode!),
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: ResponsiveUtils.scaledFontSize(context, 12),
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(width: HvacSpacing.xs),
            Icon(
              Icons.copy,
              size: ResponsiveUtils.scaledIconSize(context, 14),
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalDetails(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return ExpansionTile(
      title: Text(
        l10n.technicalDetails,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: ResponsiveUtils.scaledFontSize(context, 12),
        ),
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(HvacSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(HvacSpacing.xs),
          ),
          child: SelectableText(
            technicalDetails!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: ResponsiveUtils.scaledFontSize(context, 11),
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final actions = <Widget>[];

    // Primary retry button
    if (onRetry != null) {
      actions.add(
        Semantics(
          button: true,
          label: l10n.retry,
          child: SizedBox(
            height: 48.0, // Minimum touch target
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                onRetry!();
              },
              icon: Icon(
                Icons.refresh_rounded,
                size: ResponsiveUtils.scaledIconSize(context, 20),
              ),
              label: Text(
                l10n.tryAgain,
                style: TextStyle(
                  fontSize: ResponsiveUtils.scaledFontSize(context, 16),
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: HvacSpacing.xl,
                  vertical: HvacSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(HvacSpacing.md),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Additional actions
    if (additionalActions != null) {
      for (final action in additionalActions!) {
        actions.add(
          const SizedBox(width: HvacSpacing.md, height: HvacSpacing.md),
        );
        actions.add(
          Semantics(
            button: true,
            label: action.label,
            child: SizedBox(
              height: 48.0, // Minimum touch target
              child: action.isPrimary
                  ? ElevatedButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        action.onPressed();
                      },
                      icon: action.icon != null
                          ? Icon(
                              action.icon,
                              size: ResponsiveUtils.scaledIconSize(context, 20),
                            )
                          : const SizedBox.shrink(),
                      label: Text(
                        action.label,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.scaledFontSize(context, 16),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: HvacSpacing.lg,
                          vertical: HvacSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(HvacSpacing.md),
                        ),
                      ),
                    )
                  : OutlinedButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        action.onPressed();
                      },
                      icon: action.icon != null
                          ? Icon(
                              action.icon,
                              size: ResponsiveUtils.scaledIconSize(context, 20),
                            )
                          : const SizedBox.shrink(),
                      label: Text(
                        action.label,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.scaledFontSize(context, 16),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: HvacSpacing.lg,
                          vertical: HvacSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(HvacSpacing.md),
                        ),
                      ),
                    ),
            ),
          ),
        );
      }
    }

    if (isLandscape) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: actions,
      );
    } else {
      return Column(
        children: actions,
      );
    }
  }

  IconData _getIconForType() {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off_rounded;
      case ErrorType.server:
        return Icons.cloud_off_rounded;
      case ErrorType.permission:
        return Icons.lock_outline_rounded;
      case ErrorType.notFound:
        return Icons.search_off_rounded;
      case ErrorType.timeout:
        return Icons.timer_off_rounded;
      case ErrorType.general:
        return Icons.error_outline_rounded;
    }
  }

  Color _getColorForType(ThemeData theme) {
    switch (type) {
      case ErrorType.network:
        return Colors.orange;
      case ErrorType.server:
        return theme.colorScheme.error;
      case ErrorType.permission:
        return Colors.amber;
      case ErrorType.notFound:
        return Colors.grey;
      case ErrorType.timeout:
        return Colors.deepOrange;
      case ErrorType.general:
        return theme.colorScheme.error;
    }
  }
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

/// Types of errors
enum ErrorType {
  general,
  network,
  server,
  permission,
  notFound,
  timeout,
}