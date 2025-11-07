/// HVAC UI Kit - Liquid Swipe Navigation
///
/// Smooth wave-based page navigation
library;

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
export 'package:liquid_swipe/liquid_swipe.dart' show LiquidController, WaveType;
import '../theme/colors.dart';

/// Liquid swipe navigation wrapper with HVAC styling
class HvacLiquidSwipe extends StatelessWidget {
  final List<Widget> pages;
  final bool enableLoop;
  final WaveType waveType;
  final LiquidController? controller;
  final Function(int)? onPageChangeCallback;
  final double slideIconsSize;
  final bool showSlideIcon;
  final bool positionSlideIcon;

  const HvacLiquidSwipe({
    super.key,
    required this.pages,
    this.enableLoop = true,
    this.waveType = WaveType.liquidReveal,
    this.controller,
    this.onPageChangeCallback,
    this.slideIconsSize = 20.0,
    this.showSlideIcon = true,
    this.positionSlideIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidSwipe(
      pages: pages,
      enableLoop: enableLoop,
      waveType: waveType,
      liquidController: controller,
      onPageChangeCallback: onPageChangeCallback,
      slideIconWidget: showSlideIcon
          ? Icon(
              Icons.arrow_back_ios,
              size: slideIconsSize,
              color: HvacColors.textSecondary,
            )
          : null,
      positionSlideIcon: positionSlideIcon ? 0.5 : 0.8,
      fullTransitionValue: 300,
    );
  }
}

/// Pre-built HVAC liquid page template
class HvacLiquidPage extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color backgroundColor;
  final Color? textColor;
  final Widget? customContent;
  final List<Widget>? actions;

  const HvacLiquidPage({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.backgroundColor = const Color(0xFF0A0E27),
    this.textColor,
    this.customContent,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? HvacColors.textPrimary;

    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 100, color: color.withOpacity(0.8)),
                const SizedBox(height: 40),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 20),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 18,
                    color: color.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (customContent != null) ...[
                const SizedBox(height: 40),
                customContent!,
              ],
              if (actions != null) ...[
                const SizedBox(height: 40),
                ...actions!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
