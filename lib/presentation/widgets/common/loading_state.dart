/// Loading State Widget
/// Displays loading indicator with optional message
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/spacing.dart';

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
        SizedBox(
          width: 48.w,
          height: 48.h,
          child: const CircularProgressIndicator(
            color: AppTheme.primaryOrange,
            strokeWidth: 3,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.lg),
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
      backgroundColor: AppTheme.backgroundDark,
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
            color: AppTheme.backgroundDark.withValues(alpha: 0.8),
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
