/// Loading State Widget
/// Displays loading indicator with optional message
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class LoadingState extends StatelessWidget {
  final String? message;
  final bool isFullScreen;

  const LoadingState({
    super.key,
    this.message,
    this.isFullScreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 48.0,
          height: 48.0,
          child: CircularProgressIndicator(
            color: HvacColors.primaryOrange,
            strokeWidth: 3,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: HvacSpacing.lg),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (!isFullScreen) {
      return Center(child: content);
    }

    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      body: Center(child: content),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: HvacColors.backgroundDark.withValues(alpha: 0.8),
            child: Center(
              child: LoadingState(
                message: message,
                isFullScreen: false,
              ),
            ),
          ),
      ],
    );
  }
}
