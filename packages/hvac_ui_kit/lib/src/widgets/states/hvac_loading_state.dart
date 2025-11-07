import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

/// Loading style variant
enum LoadingStyle {
  spinner, // Circular progress indicator
  linear, // Linear progress bar
  dots, // Animated dots
}

/// Size variant for loading state
enum LoadingStateSize {
  small, // 24px
  medium, // 48px
  large, // 64px
}

/// Loading state component
///
/// Usage:
/// ```dart
/// HvacLoadingState(
///   message: 'Loading devices...',
///   style: LoadingStyle.spinner,
/// )
/// ```
class HvacLoadingState extends StatelessWidget {
  /// Loading message (optional)
  final String? message;

  /// Loading style
  final LoadingStyle style;

  /// Size variant
  final LoadingStateSize size;

  /// Display as full screen (with Scaffold)
  final bool isFullScreen;

  /// Custom color
  final Color? color;

  const HvacLoadingState({
    super.key,
    this.message,
    this.style = LoadingStyle.spinner,
    this.size = LoadingStateSize.medium,
    this.isFullScreen = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final content = _buildContent();

    if (isFullScreen) {
      return Scaffold(
        backgroundColor: HvacColors.backgroundDark,
        body: Center(child: content),
      );
    }

    return Center(child: content);
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(HvacSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Loading indicator
          _buildLoadingIndicator(),

          // Message
          if (message != null) ...[
            const SizedBox(height: HvacSpacing.lg),
            Text(
              message!,
              style: _getMessageStyle(),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    final effectiveColor = color ?? HvacColors.accent;
    final indicatorSize = _getIndicatorSize();

    switch (style) {
      case LoadingStyle.spinner:
        return SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: size == LoadingStateSize.small ? 2 : 3,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          ),
        );

      case LoadingStyle.linear:
        return SizedBox(
          width: indicatorSize * 3,
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
            backgroundColor: effectiveColor.withValues(alpha: 0.2),
          ),
        );

      case LoadingStyle.dots:
        return _AnimatedDots(
          color: effectiveColor,
          size: indicatorSize / 6,
        );
    }
  }

  double _getIndicatorSize() {
    switch (size) {
      case LoadingStateSize.small:
        return 24.0;
      case LoadingStateSize.medium:
        return 48.0;
      case LoadingStateSize.large:
        return 64.0;
    }
  }

  TextStyle _getMessageStyle() {
    switch (size) {
      case LoadingStateSize.small:
        return HvacTypography.bodySmall
            .copyWith(color: HvacColors.textSecondary);
      case LoadingStateSize.medium:
        return HvacTypography.bodyMedium
            .copyWith(color: HvacColors.textSecondary);
      case LoadingStateSize.large:
        return HvacTypography.bodyLarge
            .copyWith(color: HvacColors.textSecondary);
    }
  }
}

/// Animated dots loading indicator
class _AnimatedDots extends StatefulWidget {
  final Color color;
  final double size;

  const _AnimatedDots({
    required this.color,
    required this.size,
  });

  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final progress = (_controller.value - delay) % 1.0;
            final scale = progress < 0.5
                ? 1.0 + (progress * 0.4)
                : 1.2 - ((progress - 0.5) * 0.4);
            final opacity =
                progress < 0.5 ? 1.0 : 1.0 - ((progress - 0.5) * 0.8);

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.size / 2),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Compact loading widget for inline use
///
/// Usage:
/// ```dart
/// HvacLoadingWidget(
///   size: LoadingStateSize.small,
/// )
/// ```
class HvacLoadingWidget extends StatelessWidget {
  final LoadingStateSize size;
  final Color? color;

  const HvacLoadingWidget({
    super.key,
    this.size = LoadingStateSize.small,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? HvacColors.accent;
    final indicatorSize = _getSize();

    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: size == LoadingStateSize.small ? 2 : 3,
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
      ),
    );
  }

  double _getSize() {
    switch (size) {
      case LoadingStateSize.small:
        return 24.0;
      case LoadingStateSize.medium:
        return 48.0;
      case LoadingStateSize.large:
        return 64.0;
    }
  }
}

/// Overlay loading with backdrop
///
/// Usage:
/// ```dart
/// HvacLoadingOverlay(
///   isLoading: _isLoading,
///   message: 'Saving...',
///   child: YourContent(),
/// )
/// ```
class HvacLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String? message;
  final Widget child;

  const HvacLoadingOverlay({
    super.key,
    required this.isLoading,
    this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: HvacColors.backgroundDark.withValues(alpha: 0.8),
              child: HvacLoadingState(
                message: message,
                style: LoadingStyle.spinner,
              ),
            ),
          ),
      ],
    );
  }
}
