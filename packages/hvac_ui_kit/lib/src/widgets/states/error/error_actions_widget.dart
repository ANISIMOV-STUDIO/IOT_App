/// Error actions widget component
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../generated/l10n/app_localizations.dart';
import 'error_types.dart';

class ErrorActionsWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final List<ErrorAction>? additionalActions;

  const ErrorActionsWidget({
    super.key,
    this.onRetry,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allActions = <ErrorAction>[];

    // Add retry action if available
    if (onRetry != null) {
      allActions.add(
        ErrorAction(
          label: l10n.retry,
          onPressed: onRetry!,
          icon: Icons.refresh_rounded,
          isPrimary: true,
        ),
      );
    }

    // Add additional actions
    if (additionalActions != null) {
      allActions.addAll(additionalActions!);
    }

    if (allActions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Separate primary and secondary actions
    final primaryActions = allActions.where((a) => a.isPrimary).toList();
    final secondaryActions = allActions.where((a) => !a.isPrimary).toList();

    return Column(
      children: [
        // Primary actions
        if (primaryActions.isNotEmpty)
          Wrap(
            spacing: HvacSpacing.md,
            runSpacing: HvacSpacing.sm,
            alignment: WrapAlignment.center,
            children: primaryActions.map((action) {
              return _buildPrimaryButton(context, action);
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
              return _buildSecondaryButton(context, action);
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context, ErrorAction action) {
    return ElevatedButton.icon(
      onPressed: action.onPressed,
      icon: action.icon != null
          ? Icon(action.icon, size: 20)
          : const SizedBox.shrink(),
      label: Text(action.label),
      style: ElevatedButton.styleFrom(
        backgroundColor: HvacColors.primaryOrange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: HvacSpacing.lg,
          vertical: HvacSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HvacRadius.md),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, ErrorAction action) {
    return TextButton.icon(
      onPressed: action.onPressed,
      icon: action.icon != null
          ? Icon(action.icon, size: 18)
          : const SizedBox.shrink(),
      label: Text(action.label),
      style: TextButton.styleFrom(
        foregroundColor: HvacColors.textSecondary,
        padding: const EdgeInsets.symmetric(
          horizontal: HvacSpacing.md,
          vertical: HvacSpacing.sm,
        ),
      ),
    );
  }
}
