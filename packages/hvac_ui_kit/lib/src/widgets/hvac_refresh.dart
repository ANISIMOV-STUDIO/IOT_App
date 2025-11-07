/// HVAC UI Kit - Custom Pull-to-Refresh
///
/// Branded refresh indicators with animations
library;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme/colors.dart';

/// Custom refresh indicator with HVAC styling
class HvacRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;

  const HvacRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? HvacColors.primaryOrange,
      backgroundColor: HvacColors.backgroundCard,
      child: child,
    );
  }
}

/// Cupertino-style refresh with HVAC animation
class HvacCupertinoRefresh extends StatelessWidget {
  final List<Widget> slivers;
  final Future<void> Function() onRefresh;

  const HvacCupertinoRefresh({
    super.key,
    required this.slivers,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: onRefresh,
          builder: (context, refreshState, pulledExtent,
              refreshTriggerPullDistance, refreshIndicatorExtent) {
            return _buildRefreshAnimation(
              context,
              refreshState,
              pulledExtent,
              refreshTriggerPullDistance,
              refreshIndicatorExtent,
            );
          },
        ),
        ...slivers,
      ],
    );
  }

  Widget _buildRefreshAnimation(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {
    final progress =
        (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0);

    return Container(
      height: pulledExtent,
      alignment: Alignment.center,
      child: refreshState == RefreshIndicatorMode.refresh
          ? _buildLoadingAnimation()
          : _buildPullAnimation(progress),
    );
  }

  Widget _buildLoadingAnimation() {
    return const SizedBox(
      width: 32,
      height: 32,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(HvacColors.primaryOrange),
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildPullAnimation(double progress) {
    return Transform.scale(
      scale: progress,
      child: Opacity(
        opacity: progress,
        child: const Icon(
          Icons.refresh,
          color: HvacColors.primaryOrange,
          size: 32,
        ),
      ),
    );
  }
}

/// Animated HVAC logo refresh indicator
class HvacLogoRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const HvacLogoRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<HvacLogoRefresh> createState() => _HvacLogoRefreshState();
}

class _HvacLogoRefreshState extends State<HvacLogoRefresh>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    _controller.repeat();
    try {
      await widget.onRefresh();
    } finally {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: HvacColors.primaryOrange,
      backgroundColor: HvacColors.backgroundCard,
      child: widget.child,
      // Custom builder could be added here for logo animation
    );
  }
}

/// Simple pull-down indicator
class HvacPullDownIndicator extends StatelessWidget {
  final double progress;
  final Color? color;

  const HvacPullDownIndicator({
    super.key,
    required this.progress,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: progress * 3.14159, // Rotate 180 degrees
        child: Icon(
          Icons.arrow_downward,
          color: color ?? HvacColors.primaryOrange,
          size: 32 * progress,
        ),
      ),
    );
  }
}
