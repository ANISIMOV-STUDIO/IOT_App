/// Onboarding Swipe Hint Widget
///
/// Animated swipe hint component for onboarding
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// An animated swipe hint widget
class OnboardingSwipeHint extends StatefulWidget {
  /// Whether to use compact sizing
  final bool isCompact;

  /// The hint text to display
  final String hintText;

  const OnboardingSwipeHint({
    super.key,
    required this.isCompact,
    required this.hintText,
  });

  @override
  State<OnboardingSwipeHint> createState() => _OnboardingSwipeHintState();
}

class _OnboardingSwipeHintState extends State<OnboardingSwipeHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Loop the animation
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: widget.isCompact ? 100 : 140,
      left: 0,
      right: 0,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SlideTransition(
          position: _animation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: HvacColors.primaryOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: HvacColors.primaryOrange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.swipe,
                      size: 20,
                      color: HvacColors.primaryOrange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.hintText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: HvacColors.primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: HvacColors.primaryOrange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
