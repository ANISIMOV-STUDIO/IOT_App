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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Temperature circle
            Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect
                if (isActive)
                  Container(
                    width: 200,
                    height: 200,
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
                  width: 180,
                  height: 180,
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
                            style: const TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.w100,
                              color: Colors.white,
                              height: 1,
                              letterSpacing: -4,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              '°',
                              style: TextStyle(
                                fontSize: 32,
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

            const SizedBox(width: 16),

            // +/- Buttons
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BreezCircleButton(
                  icon: Icons.keyboard_arrow_up,
                  onTap: () => onIncrease?.call(temperature + 1),
                ),
                const SizedBox(height: 12),
                BreezCircleButton(
                  icon: Icons.keyboard_arrow_down,
                  onTap: () => onDecrease?.call(temperature - 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
