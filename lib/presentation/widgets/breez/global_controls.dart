/// Global Controls with consistent styling
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'breez_card.dart';

/// Global controls card with master power off
class GlobalControls extends StatelessWidget {
  final VoidCallback? onMasterOff;

  const GlobalControls({
    super.key,
    this.onMasterOff,
  });

  @override
  Widget build(BuildContext context) {
    return BreezCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BreezLabel('Глобальное управление'),
          const SizedBox(height: 16),
          BreezButton(
            onTap: onMasterOff,
            padding: const EdgeInsets.all(16),
            hoverColor: AppColors.accentRed.withValues(alpha: 0.2),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, size: 24, color: AppColors.accentRed),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ОСТАНОВИТЬ ВСЁ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'МАСТЕР-ВЫКЛЮЧАТЕЛЬ СИСТЕМ',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: AppColors.darkTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Power control bar for a specific unit
class UnitPowerBar extends StatelessWidget {
  final String unitName;
  final bool isPowered;
  final VoidCallback? onPowerTap;
  final VoidCallback? onSettingsTap;

  const UnitPowerBar({
    super.key,
    required this.unitName,
    required this.isPowered,
    this.onPowerTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return BreezCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: BreezButton(
              onTap: onPowerTap,
              padding: const EdgeInsets.symmetric(vertical: 16),
              hoverColor: isPowered
                  ? AppColors.accentRed.withValues(alpha: 0.1)
                  : AppColors.accentGreen.withValues(alpha: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.power_settings_new,
                    size: 20,
                    color: isPowered ? AppColors.accentRed : AppColors.accentGreen,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isPowered ? 'ОСТАНОВИТЬ $unitName' : 'ЗАПУСТИТЬ $unitName',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          BreezIconButton(
            icon: Icons.settings_outlined,
            onTap: onSettingsTap,
            size: 20,
          ),
        ],
      ),
    );
  }
}
