import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../core/theme/spacing.dart';

/// Loading snackbar for ongoing operations
class LoadingSnackBar {
  LoadingSnackBar._();

  /// Show loading snackbar
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
    bool indefinite = true,
    Duration? maxDuration,
    Color? backgroundColor,
    bool showProgress = false,
    double? progress,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Get responsive values
    final screenWidth = MediaQuery.of(context).size.width;
    final snackbarWidth = screenWidth < 600
        ? null
        : (screenWidth < 1024 ? 500.0 : (screenWidth < 1440 ? 450.0 : 480.0));
    final snackbarMargin = EdgeInsets.all(AppSpacing.snackbarMargin(context));

    final snackBar = SnackBar(
      content: _LoadingContent(
        message: message,
        showProgress: showProgress,
        progress: progress,
      ),
      duration: indefinite
        ? const Duration(days: 365) // Effectively indefinite
        : maxDuration ?? const Duration(seconds: 30),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor ?? (isDarkMode
        ? HvacColors.neutral400
        : HvacColors.neutral300),
      margin: snackbarMargin,
      width: snackbarWidth,
      shape: RoundedRectangleBorder(
        borderRadius: HvacRadius.smRadius,
      ),
      dismissDirection: DismissDirection.none, // Can't be dismissed by swiping
    );

    // Clear any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Show operation in progress
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showOperation(
    BuildContext context, {
    required String operation,
    String? details,
  }) {
    final message = details != null
      ? '$operation: $details'
      : '$operation in progress...';

    return show(context, message: message);
  }

  /// Show sync in progress
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSyncing(
    BuildContext context, {
    String? itemName,
  }) {
    return show(
      context,
      message: itemName != null
        ? 'Syncing $itemName...'
        : 'Syncing data...',
    );
  }

  /// Show saving in progress
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSaving(
    BuildContext context, {
    String? itemName,
  }) {
    return show(
      context,
      message: itemName != null
        ? 'Saving $itemName...'
        : 'Saving changes...',
    );
  }

  /// Show loading data
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showLoadingData(
    BuildContext context, {
    String? dataType,
  }) {
    return show(
      context,
      message: dataType != null
        ? 'Loading $dataType...'
        : 'Loading data...',
    );
  }

  /// Show processing
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showProcessing(
    BuildContext context, {
    String? itemName,
  }) {
    return show(
      context,
      message: itemName != null
        ? 'Processing $itemName...'
        : 'Processing...',
    );
  }

  /// Show uploading with progress
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showUploading(
    BuildContext context, {
    String? fileName,
    double? progress,
  }) {
    return show(
      context,
      message: fileName != null
        ? 'Uploading $fileName'
        : 'Uploading...',
      showProgress: true,
      progress: progress,
    );
  }

  /// Show downloading with progress
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showDownloading(
    BuildContext context, {
    String? fileName,
    double? progress,
  }) {
    return show(
      context,
      message: fileName != null
        ? 'Downloading $fileName'
        : 'Downloading...',
      showProgress: true,
      progress: progress,
    );
  }

  /// Hide loading snackbar
  static void hide(ScaffoldFeatureController<SnackBar, SnackBarClosedReason> controller) {
    controller.close();
  }
}

/// Loading content widget
class _LoadingContent extends StatelessWidget {
  final String message;
  final bool showProgress;
  final double? progress;

  const _LoadingContent({
    required this.message,
    this.showProgress = false,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final messageFontSize = screenWidth >= 1024 ? 14.0 : (screenWidth >= 600 ? 13.5 : 13.0);
    final percentFontSize = screenWidth >= 1024 ? 12.0 : (screenWidth >= 600 ? 11.5 : 11.0);

    return Row(
      children: [
        if (!showProgress || progress == null)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.onPrimary,
              ),
            ),
          )
        else
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: progress,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.onPrimary,
              ),
            ),
          ),
        SizedBox(width: isDesktop ? 16 : 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontSize: messageFontSize,
                ),
              ),
              if (showProgress && progress != null) ...[
                const SizedBox(height: 8.0),
                ClipRRect(
                  borderRadius: HvacRadius.xsRadius,
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${(progress! * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                    fontSize: percentFontSize,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}