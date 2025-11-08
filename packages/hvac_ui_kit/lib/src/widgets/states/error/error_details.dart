/// Error Details Component
///
/// Displays error code and technical details
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../generated/l10n/app_localizations.dart';

/// Error details widget
class ErrorDetails extends StatelessWidget {
  final String? errorCode;
  final String? technicalDetails;
  final bool showTechnicalDetails;

  const ErrorDetails({
    super.key,
    this.errorCode,
    this.technicalDetails,
    this.showTechnicalDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    if (errorCode == null && technicalDetails == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (errorCode != null) ...[
          SizedBox(height: HvacSpacing.md.h),
          _ErrorCodeWidget(errorCode: errorCode!),
        ],
        if (showTechnicalDetails && technicalDetails != null) ...[
          SizedBox(height: HvacSpacing.md.h),
          _TechnicalDetailsWidget(details: technicalDetails!),
        ],
      ],
    );
  }
}

/// Error code display widget
class _ErrorCodeWidget extends StatelessWidget {
  final String errorCode;

  const _ErrorCodeWidget({required this.errorCode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _copyToClipboard(context, errorCode),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: HvacSpacing.md.w,
          vertical: HvacSpacing.xs.h,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(HvacRadius.xs),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline,
              size: 16.w,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            SizedBox(width: HvacSpacing.xs.w),
            Text(
              'Error Code: $errorCode',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                fontFamily: 'monospace',
              ),
            ),
            SizedBox(width: HvacSpacing.xs.w),
            Icon(
              Icons.copy,
              size: 14.w,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error code copied'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

/// Technical details expandable widget
class _TechnicalDetailsWidget extends StatelessWidget {
  final String details;

  const _TechnicalDetailsWidget({required this.details});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ExpansionTile(
      title: Text(
        l10n.technicalDetails,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 12.sp,
        ),
      ),
      children: [
        Container(
          padding: EdgeInsets.all(HvacSpacing.md.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(HvacRadius.xs),
          ),
          child: SelectableText(
            details,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11.sp,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}
