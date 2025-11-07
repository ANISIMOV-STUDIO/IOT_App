import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../buttons/hvac_primary_button.dart';
import '../buttons/hvac_text_button.dart';

/// Size variant for error state
enum ErrorStateSize {
  compact, // For small containers
  medium, // Default
  large, // For full screen
}

/// Re-export for compatibility
typedef EmptyStateSize = ErrorStateSize;

/// Error state component
///
/// Usage:
/// ```dart
/// HvacErrorState(
///   title: 'Connection Failed',
///   message: 'Could not connect to server',
///   onRetry: () => _retry(),
///   errorDetails: 'Error: Connection timeout',
/// )
/// ```
class HvacErrorState extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Title text (optional)
  final String? title;

  /// Error message
  final String message;

  /// Retry callback
  final VoidCallback? onRetry;

  /// Retry button label
  final String retryLabel;

  /// Error details (optional, for debug)
  final String? errorDetails;

  /// Show error details toggle
  final bool showDetailsToggle;

  /// Display as full screen (with Scaffold)
  final bool isFullScreen;

  /// Size variant
  final ErrorStateSize size;

  const HvacErrorState({
    super.key,
    this.icon = Icons.error_outline,
    this.title,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.errorDetails,
    this.showDetailsToggle = false,
    this.isFullScreen = false,
    this.size = ErrorStateSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final content = _ErrorStateContent(
      icon: icon,
      title: title,
      message: message,
      onRetry: onRetry,
      retryLabel: retryLabel,
      errorDetails: errorDetails,
      showDetailsToggle: showDetailsToggle,
      size: size,
    );

    if (isFullScreen) {
      return Scaffold(
        backgroundColor: HvacColors.backgroundDark,
        body: Center(child: content),
      );
    }

    return Center(child: content);
  }
}

class _ErrorStateContent extends StatefulWidget {
  final IconData icon;
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final String? errorDetails;
  final bool showDetailsToggle;
  final EmptyStateSize size;

  const _ErrorStateContent({
    required this.icon,
    required this.title,
    required this.message,
    required this.onRetry,
    required this.retryLabel,
    required this.errorDetails,
    required this.showDetailsToggle,
    required this.size,
  });

  @override
  State<_ErrorStateContent> createState() => _ErrorStateContentState();
}

class _ErrorStateContentState extends State<_ErrorStateContent> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final iconSize = _getIconSize();
    final spacing = _getSpacing();

    return Padding(
      padding: EdgeInsets.all(spacing.padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            widget.icon,
            size: iconSize,
            color: HvacColors.error,
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

          // Error details (expandable)
          if (widget.errorDetails != null && widget.showDetailsToggle) ...[
            SizedBox(height: spacing.messageGap),
            HvacTextButton(
              label: _showDetails ? 'Hide Details' : 'Show Details',
              onPressed: () => setState(() => _showDetails = !_showDetails),
              size: HvacButtonSize.small,
            ),
            if (_showDetails) ...[
              SizedBox(height: spacing.messageGap),
              Container(
                padding: const EdgeInsets.all(HvacSpacing.md),
                decoration: BoxDecoration(
                  color: HvacColors.backgroundCard,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: HvacColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  widget.errorDetails!,
                  style: HvacTypography.bodySmall.copyWith(
                    fontFamily: 'monospace',
                    color: HvacColors.textSecondary,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ],

          // Retry button
          if (widget.onRetry != null) ...[
            SizedBox(height: spacing.buttonGap),
            HvacPrimaryButton(
              label: widget.retryLabel,
              onPressed: widget.onRetry,
              icon: Icons.refresh,
              size: widget.size == ErrorStateSize.compact
                  ? HvacButtonSize.small
                  : HvacButtonSize.medium,
            ),
          ],
        ],
      ),
    );
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

/// Compact error card widget
///
/// Usage:
/// ```dart
/// HvacErrorCard(
///   message: 'Failed to load',
///   onRetry: () => _retry(),
/// )
/// ```
class HvacErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const HvacErrorCard({
    super.key,
    required this.message,
    this.onRetry,
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
              label: 'Retry',
              onPressed: onRetry,
              icon: Icons.refresh,
            ),
          ],
        ],
      ),
    );
  }
}
