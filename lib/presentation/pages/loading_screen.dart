import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _dotsController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Logo pulse animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _logoScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    // Text fade animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _textFadeAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    // Dots animation
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Progress animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dotsController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HvacColors.backgroundDark,
              HvacColors.primaryOrange.withValues(alpha: 0.1),
              HvacColors.backgroundDark,
              HvacColors.primaryOrangeDark.withValues(alpha: 0.15),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated logo with pulse effect
              _buildAnimatedLogo(),

              SizedBox(height: 48.h),

              // Loading text with fade animation and pulsing dot
              _buildLoadingText(),

              SizedBox(height: 32.h),

              // Animated progress bar
              _buildProgressBar(),

              SizedBox(height: 24.h),

              // Animated dots indicator
              _buildDotsIndicator(),

              SizedBox(height: 48.h),

              // Skeleton loader example (shimmer effect)
              _buildSkeletonLoader(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoOpacityAnimation.value,
          child: Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HvacColors.primaryOrange,
                    HvacColors.primaryOrangeDark,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: HvacColors.primaryOrange.withValues(alpha: 0.4),
                    blurRadius: 20 * _logoScaleAnimation.value,
                    spreadRadius: 5 * _logoScaleAnimation.value,
                  ),
                ],
              ),
              child: Icon(
                Icons.thermostat,
                size: 50.sp,
                color: HvacColors.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textFadeAnimation.value,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Loading BREEZ Home',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: HvacColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 12.w),
              const HvacPulsingDot(
                color: HvacColors.primaryOrange,
                size: 12,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80.w),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Container(
            width: 250.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: HvacColors.backgroundCard,
              borderRadius: BorderRadius.circular(3.h),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3.h),
              child: LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  HvacColors.primaryOrange,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDotsIndicator() {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.33;
            final animationValue = (_dotsController.value + delay) % 1.0;
            final opacity = (animationValue < 0.5)
                ? animationValue * 2
                : (1.0 - animationValue) * 2;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Container(
                width: 10.w,
                height: 10.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HvacColors.primaryOrange.withValues(alpha: opacity),
                  boxShadow: opacity > 0.5
                      ? [
                          BoxShadow(
                            color: HvacColors.primaryOrange
                                .withValues(alpha: opacity * 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: HvacSkeletonLoader(
        isLoading: true,
        child: Column(
          children: [
            Container(
              width: 200.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: HvacColors.backgroundCard,
                borderRadius: BorderRadius.circular(8.h),
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: 160.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: HvacColors.backgroundCard,
                borderRadius: BorderRadius.circular(8.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
