/// HVAC Unit Card
///
/// Modern card widget with gradients, glassmorphism, and animations
library;

import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/hvac_unit.dart';

class HvacUnitCard extends StatefulWidget {
  final HvacUnit unit;
  final VoidCallback onTap;

  const HvacUnitCard({
    super.key,
    required this.unit,
    required this.onTap,
  });

  @override
  State<HvacUnitCard> createState() => _HvacUnitCardState();
}

class _HvacUnitCardState extends State<HvacUnitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final modeGradient = AppTheme.getModeGradient(widget.unit.mode, isDark: isDark);
    final modeIcon = AppTheme.getModeIcon(widget.unit.mode);
    final modeColor = AppTheme.getModeColor(widget.unit.mode);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: widget.unit.power
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            modeColor.withOpacity(0.15),
                            modeColor.withOpacity(0.05),
                          ]
                        : [
                            modeColor.withOpacity(0.1),
                            modeColor.withOpacity(0.03),
                          ],
                  )
                : null,
            color: !widget.unit.power
                ? (isDark ? AppTheme.darkCard : AppTheme.lightCard)
                : null,
            border: Border.all(
              color: widget.unit.power
                  ? modeColor.withOpacity(isDark ? 0.3 : 0.2)
                  : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder)
                      .withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.unit.power
                    ? modeColor.withOpacity(isDark ? 0.2 : 0.15)
                    : Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: isDark ? 10 : 0,
                sigmaY: isDark ? 10 : 0,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Header: Name and Power Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.unit.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: widget.unit.power
                                ? LinearGradient(
                                    colors: [
                                      AppTheme.successColor,
                                      AppTheme.successColor.withOpacity(0.8),
                                    ],
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.grey.shade600,
                                      Colors.grey.shade700,
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: widget.unit.power
                                ? [
                                    BoxShadow(
                                      color: AppTheme.successColor.withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            widget.unit.power ? 'ON' : 'OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Mode Indicator with Icon
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: widget.unit.power ? modeGradient : null,
                        color: !widget.unit.power
                            ? (isDark ? Colors.grey.shade800 : Colors.grey.shade200)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            modeIcon,
                            color: widget.unit.power
                                ? Colors.white
                                : (isDark ? Colors.grey.shade600 : Colors.grey.shade500),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.unit.mode.toUpperCase(),
                            style: TextStyle(
                              color: widget.unit.power
                                  ? Colors.white
                                  : (isDark ? Colors.grey.shade600 : Colors.grey.shade500),
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Temperature Display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Current Temperature
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDark
                                          ? AppTheme.darkTextHint
                                          : AppTheme.lightTextHint,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        widget.unit.power
                                            ? modeGradient.createShader(bounds)
                                            : LinearGradient(
                                                colors: [
                                                  isDark
                                                      ? AppTheme.darkTextSecondary
                                                      : AppTheme.lightTextSecondary,
                                                  isDark
                                                      ? AppTheme.darkTextSecondary
                                                      : AppTheme.lightTextSecondary,
                                                ],
                                              ).createShader(bounds),
                                    child: Text(
                                      widget.unit.currentTemp.toStringAsFixed(1),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                            color: Colors.white,
                                            letterSpacing: -1.5,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: ShaderMask(
                                      shaderCallback: (bounds) =>
                                          widget.unit.power
                                              ? modeGradient.createShader(bounds)
                                              : LinearGradient(
                                                  colors: [
                                                    isDark
                                                        ? AppTheme.darkTextSecondary
                                                        : AppTheme.lightTextSecondary,
                                                    isDark
                                                        ? AppTheme.darkTextSecondary
                                                        : AppTheme.lightTextSecondary,
                                                  ],
                                                ).createShader(bounds),
                                      child: Text(
                                        '°C',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Target Temperature with Arrow
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Target',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppTheme.darkTextHint
                                        : AppTheme.lightTextHint,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.darkSurface
                                    : AppTheme.lightSurface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? AppTheme.darkBorder.withOpacity(0.5)
                                      : AppTheme.lightBorder.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.unit.targetTemp.toStringAsFixed(0),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.5,
                                        ),
                                  ),
                                  Text(
                                    '°C',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Fan Speed Indicator (if applicable)
                    if (widget.unit.power) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.air_rounded,
                            size: 14,
                            color: isDark
                                ? AppTheme.darkTextHint
                                : AppTheme.lightTextHint,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Fan: ${widget.unit.fanSpeed.toUpperCase()}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppTheme.darkTextHint
                                      : AppTheme.lightTextHint,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
