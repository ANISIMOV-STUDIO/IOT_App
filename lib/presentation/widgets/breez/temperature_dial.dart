import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';

/// Circular temperature dial with glow effect
class TemperatureDial extends StatelessWidget {
  final int temperature;
  final ValueChanged<int>? onIncrease;
  final ValueChanged<int>? onDecrease;
  final bool isActive;

  const TemperatureDial({
    super.key,
    required this.temperature,
    this.onIncrease,
    this.onDecrease,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: isActive ? 1.0 : 0.2,
      child: IgnorePointer(
        ignoring: !isActive,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adaptive sizing based on available space
            final availableSize = constraints.biggest.shortestSide;
            final dialSize = (availableSize * 0.7).clamp(120.0, 180.0);
            final glowSize = dialSize + 20;
            final fontSize = (dialSize * 0.4).clamp(48.0, 72.0);
            final degreeSize = fontSize * 0.45;
            final buttonSpacing = (dialSize * 0.08).clamp(8.0, 16.0);

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Temperature circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow effect
                    if (isActive)
                      Container(
                        width: glowSize,
                        height: glowSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.2),
                              blurRadius: 60,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),

                    // Main dial
                    Container(
                      width: dialSize,
                      height: dialSize,
                      decoration: BoxDecoration(
                        color: AppColors.darkCardLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.darkBorder),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const BreezLabel('ЦЕЛЬ', fontSize: 8),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$temperature',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.white,
                                  height: 1,
                                  letterSpacing: -4,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: fontSize * 0.15),
                                child: Text(
                                  '°',
                                  style: TextStyle(
                                    fontSize: degreeSize,
                                    fontWeight: FontWeight.w200,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(width: buttonSpacing),

                // +/- Buttons
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BreezCircleButton(
                      icon: Icons.keyboard_arrow_up,
                      onTap: () => onIncrease?.call(temperature + 1),
                    ),
                    SizedBox(height: buttonSpacing * 0.75),
                    BreezCircleButton(
                      icon: Icons.keyboard_arrow_down,
                      onTap: () => onDecrease?.call(temperature - 1),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
