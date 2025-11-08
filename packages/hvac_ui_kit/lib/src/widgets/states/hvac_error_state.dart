import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../buttons/hvac_primary_button.dart';
import '../buttons/hvac_text_button.dart';

/// Types of errors for visual styling
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

/// Size variant for error state
enum ErrorStateSize {
  compact, // For small containers
  medium, // Default
  large, // For full screen
}

/// Action button configuration for error states
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

/// Comprehensive error state component with multiple variants
///
/// Features:
/// - Multiple error types with appropriate icons and colors
/// - Size variants (compact, medium, large)
/// - Optional error code display with copy functionality
/// - Expandable technical details
/// - Multiple action buttons support
/// - Accessibility support
///
/// Usage:
/// ```dart
/// // Simple error
/// HvacErrorState(
///   message: 'Connection failed',
///   onRetry: () => retry(),
/// )
///
/// // Advanced error with type and details
/// HvacErrorState(
///   title: 'Server Error',
///   message: 'Unable to process your request',
///   errorType: ErrorType.server,
///   errorCode: 'ERR_500',
///   technicalDetails: 'Internal server error...',
///   showTechnicalDetails: true,
///   onRetry: () => retry(),
///   additionalActions: [
///     ErrorAction(
///       label: 'Contact Support',
///       onPressed: () => contactSupport(),
///       icon: Icons.support_agent,
///     ),
///   ],
/// )
/// ```
class HvacErrorState extends StatelessWidget {
  /// Error type for icon and color selection
  final ErrorType errorType;

  /// Custom icon (overrides errorType icon)
  final IconData? customIcon;

  /// Title text (optional)
  final String? title;

  /// Error message (required)
  final String message;

  /// Primary retry callback
  final VoidCallback? onRetry;

  /// Retry button label
  final String retryLabel;

  /// Additional action buttons
  final List<ErrorAction>? additionalActions;

  /// Error code (optional, can be copied)
  final String? errorCode;

  /// Label for error code section
  final String errorCodeLabel;

  /// Technical details (optional, expandable)
  final String? technicalDetails;

  /// Label for technical details toggle
  final String technicalDetailsLabel;

  /// Show/hide toggle label for expanded details
  final String showDetailsLabel;

  /// Hide details toggle label
  final String hideDetailsLabel;

  /// Show technical details toggle
  final bool showTechnicalDetails;

  /// Display as full screen (with Scaffold)
  final bool isFullScreen;

  /// Size variant
  final ErrorStateSize size;

  /// Accessibility label
  final String? semanticLabel;

  /// Accessibility hint
  final String? semanticHint;

  /// Success message for when error code is copied
  final String errorCodeCopiedMessage;

  const HvacErrorState({
    super.key,
    this.errorType = ErrorType.general,
    this.customIcon,
    this.title,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.additionalActions,
    this.errorCode,
    this.errorCodeLabel = 'Error Code',
    this.technicalDetails,
    this.technicalDetailsLabel = 'Technical Details',
    this.showDetailsLabel = 'Show Details',
    this.hideDetailsLabel = 'Hide Details',
    this.showTechnicalDetails = false,
    this.isFullScreen = false,
    this.size = ErrorStateSize.medium,
    this.semanticLabel,
    this.semanticHint,
    this.errorCodeCopiedMessage = 'Error code copied to clipboard',
  });

  /// Factory constructor for network errors
  factory HvacErrorState.network({
    required String message,
    String? title,
    VoidCallback? onRetry,
    String retryLabel = 'Retry',
    ErrorStateSize size = ErrorStateSize.medium,
  }) {
    return HvacErrorState(
      title: title ?? 'Connection Error',
      message: message,
      errorType: ErrorType.network,
      onRetry: onRetry,
      retryLabel: retryLabel,
      size: size,
    );
  }

  /// Factory constructor for server errors
  factory HvacErrorState.server({
    required String message,
    String? title,
    VoidCallback? onRetry,
    String? errorCode,
    String? technicalDetails,
    String retryLabel = 'Retry',
    ErrorStateSize size = ErrorStateSize.medium,
  }) {
    return HvacErrorState(
      title: title ?? 'Server Error',
      message: message,
      errorType: ErrorType.server,
      onRetry: onRetry,
      errorCode: errorCode,
      technicalDetails: technicalDetails,
      showTechnicalDetails: technicalDetails != null,
      retryLabel: retryLabel,
      size: size,
    );
  }

  /// Factory constructor for permission errors
  factory HvacErrorState.permission({
    required String message,
    String? title,
    VoidCallback? onRetry,
    List<ErrorAction>? actions,
    String retryLabel = 'Grant Permission',
    ErrorStateSize size = ErrorStateSize.medium,
  }) {
    return HvacErrorState(
      title: title ?? 'Permission Required',
      message: message,
      errorType: ErrorType.permission,
      onRetry: onRetry,
      additionalActions: actions,
      retryLabel: retryLabel,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _ErrorStateContent(
      errorType: errorType,
      customIcon: customIcon,
      title: title,
      message: message,
      onRetry: onRetry,
      retryLabel: retryLabel,
      additionalActions: additionalActions,
      errorCode: errorCode,
      errorCodeLabel: errorCodeLabel,
      technicalDetails: technicalDetails,
      technicalDetailsLabel: technicalDetailsLabel,
      showDetailsLabel: showDetailsLabel,
      hideDetailsLabel: hideDetailsLabel,
      showTechnicalDetails: showTechnicalDetails,
      size: size,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
      errorCodeCopiedMessage: errorCodeCopiedMessage,
    );

    if (isFullScreen) {
      return Scaffold(
        backgroundColor: HvacColors.backgroundDark,
        body: SafeArea(child: Center(child: content)),
      );
    }

    return Center(child: content);
  }
}

class _ErrorStateContent extends StatefulWidget {
  final ErrorType errorType;
  final IconData? customIcon;
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final List<ErrorAction>? additionalActions;
  final String? errorCode;
  final String errorCodeLabel;
  final String? technicalDetails;
  final String technicalDetailsLabel;
  final String showDetailsLabel;
  final String hideDetailsLabel;
  final bool showTechnicalDetails;
  final ErrorStateSize size;
  final String? semanticLabel;
  final String? semanticHint;
  final String errorCodeCopiedMessage;

  const _ErrorStateContent({
    required this.errorType,
    required this.customIcon,
    required this.title,
    required this.message,
    required this.onRetry,
    required this.retryLabel,
    required this.additionalActions,
    required this.errorCode,
    required this.errorCodeLabel,
    required this.technicalDetails,
    required this.technicalDetailsLabel,
    required this.showDetailsLabel,
    required this.hideDetailsLabel,
    required this.showTechnicalDetails,
    required this.size,
    required this.semanticLabel,
    required this.semanticHint,
    required this.errorCodeCopiedMessage,
  });

  @override
  State<_ErrorStateContent> createState() => _ErrorStateContentState();
}

class _ErrorStateContentState extends State<_ErrorStateContent> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final iconData = widget.customIcon ?? _getIconForType();
    final iconColor = _getColorForType();
    final iconSize = _getIconSize();
    final spacing = _getSpacing();

    return Semantics(
      label: widget.semanticLabel ?? '${widget.title ?? 'Error'}: ${widget.message}',
      hint: widget.semanticHint ?? (widget.onRetry != null ? 'Double tap to retry' : null),
      button: widget.onRetry != null,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon with background circle
            Container(
              width: iconSize * 1.5,
              height: iconSize * 1.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: 0.1),
              ),
              child: Icon(
                iconData,
                size: iconSize,
                color: iconColor,
              ),
            ),
            SizedBox(height: spacing.titleGap),

            // Title (optional)
            if (widget.title != null) ...[
              Text(
                widget.title!,
                style: _getTitleStyle(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.messageGap),
            ],

            // Message
            Text(
              widget.message,
              style: _getMessageStyle(),
              textAlign: TextAlign.center,
              maxLines: widget.size == ErrorStateSize.compact ? 3 : null,
              overflow: widget.size == ErrorStateSize.compact
                  ? TextOverflow.ellipsis
                  : null,
            ),

            // Error code (with copy functionality)
            if (widget.errorCode != null) ...[
              SizedBox(height: spacing.messageGap),
              _ErrorCodeWidget(
                errorCode: widget.errorCode!,
                label: widget.errorCodeLabel,
                copiedMessage: widget.errorCodeCopiedMessage,
              ),
            ],

            // Technical details (expandable)
            if (widget.technicalDetails != null && widget.showTechnicalDetails) ...[
              SizedBox(height: spacing.messageGap),
              HvacTextButton(
                label: _showDetails ? widget.hideDetailsLabel : widget.showDetailsLabel,
                onPressed: () => setState(() => _showDetails = !_showDetails),
                size: HvacButtonSize.small,
                icon: _showDetails ? Icons.expand_less : Icons.expand_more,
              ),
              if (_showDetails) ...[
                SizedBox(height: spacing.messageGap),
                Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(HvacSpacing.md),
                  decoration: BoxDecoration(
                    color: HvacColors.backgroundCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: SelectableText(
                    widget.technicalDetails!,
                    style: HvacTypography.bodySmall.copyWith(
                      fontFamily: 'monospace',
                      color: HvacColors.textSecondary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ],

            // Action buttons
            SizedBox(height: spacing.buttonGap),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    final actions = <ErrorAction>[];

    // Add retry action if available
    if (widget.onRetry != null) {
      actions.add(
        ErrorAction(
          label: widget.retryLabel,
          onPressed: widget.onRetry!,
          icon: Icons.refresh,
          isPrimary: true,
        ),
      );
    }

    // Add additional actions
    if (widget.additionalActions != null) {
      actions.addAll(widget.additionalActions!);
    }

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Separate primary and secondary actions
    final primaryActions = actions.where((a) => a.isPrimary).toList();
    final secondaryActions = actions.where((a) => !a.isPrimary).toList();

    return Column(
      children: [
        // Primary actions
        if (primaryActions.isNotEmpty)
          Wrap(
            spacing: HvacSpacing.md,
            runSpacing: HvacSpacing.sm,
            alignment: WrapAlignment.center,
            children: primaryActions.map((action) {
              return HvacPrimaryButton(
                label: action.label,
                onPressed: action.onPressed,
                icon: action.icon,
                size: widget.size == ErrorStateSize.compact
                    ? HvacButtonSize.small
                    : HvacButtonSize.medium,
              );
            }).toList(),
          ),

        // Secondary actions
        if (secondaryActions.isNotEmpty) ...[
          const SizedBox(height: HvacSpacing.md),
          Wrap(
            spacing: HvacSpacing.sm,
            runSpacing: HvacSpacing.xs,
            alignment: WrapAlignment.center,
            children: secondaryActions.map((action) {
              return HvacTextButton(
                label: action.label,
                onPressed: action.onPressed,
                icon: action.icon,
                size: HvacButtonSize.small,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  IconData _getIconForType() {
    switch (widget.errorType) {
      case ErrorType.network:
        return Icons.wifi_off_rounded;
      case ErrorType.server:
        return Icons.cloud_off_rounded;
      case ErrorType.permission:
        return Icons.lock_outline_rounded;
      case ErrorType.validation:
        return Icons.warning_amber_rounded;
      case ErrorType.authentication:
        return Icons.person_off_rounded;
      case ErrorType.timeout:
        return Icons.hourglass_empty_rounded;
      case ErrorType.notFound:
        return Icons.search_off_rounded;
      case ErrorType.offline:
        return Icons.signal_wifi_off_rounded;
      case ErrorType.general:
        return Icons.error_outline_rounded;
    }
  }

  Color _getColorForType() {
    switch (widget.errorType) {
      case ErrorType.network:
      case ErrorType.offline:
        return HvacColors.warning;
      case ErrorType.server:
      case ErrorType.timeout:
        return HvacColors.error;
      case ErrorType.permission:
      case ErrorType.authentication:
        return HvacColors.info;
      case ErrorType.validation:
        return HvacColors.warning;
      case ErrorType.notFound:
        return HvacColors.textSecondary;
      case ErrorType.general:
        return HvacColors.error;
    }
  }

  _SizeConfig _getSpacing() {
    switch (widget.size) {
      case ErrorStateSize.compact:
        return _SizeConfig(
          padding: HvacSpacing.md,
          titleGap: HvacSpacing.sm,
          messageGap: HvacSpacing.xs,
          buttonGap: HvacSpacing.md,
        );
      case ErrorStateSize.medium:
        return _SizeConfig(
          padding: HvacSpacing.xl,
          titleGap: HvacSpacing.md,
          messageGap: HvacSpacing.sm,
          buttonGap: HvacSpacing.xl,
        );
      case ErrorStateSize.large:
        return _SizeConfig(
          padding: HvacSpacing.xxl,
          titleGap: HvacSpacing.lg,
          messageGap: HvacSpacing.md,
          buttonGap: HvacSpacing.xxl,
        );
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ErrorStateSize.compact:
        return 48.0;
      case ErrorStateSize.medium:
        return 64.0;
      case ErrorStateSize.large:
        return 80.0;
    }
  }

  TextStyle _getTitleStyle() {
    switch (widget.size) {
      case ErrorStateSize.compact:
        return HvacTypography.h4.copyWith(color: HvacColors.textPrimary);
      case ErrorStateSize.medium:
        return HvacTypography.h3.copyWith(color: HvacColors.textPrimary);
      case ErrorStateSize.large:
        return HvacTypography.h2.copyWith(color: HvacColors.textPrimary);
    }
  }

  TextStyle _getMessageStyle() {
    switch (widget.size) {
      case ErrorStateSize.compact:
        return HvacTypography.bodySmall
            .copyWith(color: HvacColors.textSecondary);
      case ErrorStateSize.medium:
        return HvacTypography.bodyMedium
            .copyWith(color: HvacColors.textSecondary);
      case ErrorStateSize.large:
        return HvacTypography.bodyLarge
            .copyWith(color: HvacColors.textSecondary);
    }
  }
}

class _SizeConfig {
  final double padding;
  final double titleGap;
  final double messageGap;
  final double buttonGap;

  _SizeConfig({
    required this.padding,
    required this.titleGap,
    required this.messageGap,
    required this.buttonGap,
  });
}

/// Error code widget with copy functionality
class _ErrorCodeWidget extends StatelessWidget {
  final String errorCode;
  final String label;
  final String copiedMessage;

  const _ErrorCodeWidget({
    required this.errorCode,
    required this.label,
    required this.copiedMessage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: errorCode));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(copiedMessage),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: HvacSpacing.md,
          vertical: HvacSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: HvacColors.backgroundCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: HvacColors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.copy_rounded,
              size: 16,
              color: HvacColors.textSecondary,
            ),
            const SizedBox(width: HvacSpacing.xs),
            Text(
              '$label: $errorCode',
              style: HvacTypography.bodySmall.copyWith(
                fontFamily: 'monospace',
                color: HvacColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact error card widget for inline error display
///
/// Usage:
/// ```dart
/// HvacErrorCard(
///   message: 'Failed to load data',
///   onRetry: () => reload(),
/// )
/// ```
class HvacErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  const HvacErrorCard({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.lg),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: HvacColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48.0,
            color: HvacColors.error,
          ),
          const SizedBox(height: HvacSpacing.md),
          Text(
            message,
            style: HvacTypography.bodyMedium.copyWith(
              color: HvacColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: HvacSpacing.md),
            HvacTextButton(
              label: retryLabel,
              onPressed: onRetry,
              icon: Icons.refresh,
            ),
          ],
        ],
      ),
    );
  }
}
