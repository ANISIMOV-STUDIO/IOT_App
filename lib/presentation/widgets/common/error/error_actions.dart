/// Error Actions Component
///
/// Handles action buttons for error states
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../generated/l10n/app_localizations.dart';
import 'error_types.dart';

/// Error actions widget
class ErrorActions extends StatelessWidget {
  final VoidCallback? onRetry;
  final List<ErrorAction>? additionalActions;

  const ErrorActions({
    super.key,
    this.onRetry,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (onRetry == null && (additionalActions == null || additionalActions!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      alignment: WrapAlignment.center,
      children: [
        if (onRetry != null)
          _buildRetryButton(context, l10n),
        if (additionalActions != null)
          ...additionalActions!.map((action) => _buildActionButton(context, action)),
      ],
    );
  }

  Widget _buildRetryButton(BuildContext context, AppLocalizations l10n) {
    return HvacPrimaryButton(
      onPressed: onRetry!,
      label: l10n.retry,
      icon: Icons.refresh_rounded,
      minWidth: 140.w,
    );
  }

  Widget _buildActionButton(BuildContext context, ErrorAction action) {
    if (action.isPrimary) {
      return HvacPrimaryButton(
        onPressed: action.onPressed,
        label: action.label,
        icon: action.icon,
        minWidth: 140.w,
      );
    }

    return HvacOutlineButton(
      onPressed: action.onPressed,
      label: action.label,
      icon: action.icon,
      minWidth: 140.w,
    );
  }
}