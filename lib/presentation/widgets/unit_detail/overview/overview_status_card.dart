/// Status Card Widget
///
/// Displays unit status with power indicator and device information
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../domain/entities/hvac_unit.dart';
import '../../../../domain/entities/ventilation_mode.dart';

class OverviewStatusCard extends StatelessWidget {
  final HvacUnit unit;

  const OverviewStatusCard({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Row(
        children: [
          // Status indicator with pulsing dot
          Stack(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: unit.power
                      ? HvacColors.success.withValues(alpha: 0.2)
                      : HvacColors.error.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  unit.power ? Icons.check_circle : Icons.power_off,
                  color: unit.power ? HvacColors.success : HvacColors.error,
                  size: 40.0,
                ),
              ),
              if (unit.power)
                const Positioned(
                  top: 0,
                  right: 0,
                  child: HvacPulsingDot(
                    color: HvacColors.success,
                    size: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20.0),

          // Status text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      unit.power ? 'Работает' : 'Выключено',
                      style: HvacTypography.displaySmall.copyWith(
                        fontSize: 24.0,
                        color:
                            unit.power ? HvacColors.success : HvacColors.error,
                      ),
                    ),
                    if (unit.power) ...[
                      const SizedBox(width: 8.0),
                      Text(
                        'ONLINE',
                        style: HvacTypography.bodySmall.copyWith(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          color: HvacColors.success,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Режим: ${unit.ventMode != null ? _getModeDisplayName(unit.ventMode!) : "Не установлен"}',
                  style: HvacTypography.bodyMedium.copyWith(
                    fontSize: 14.0,
                    color: HvacColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  'ID устройства: ${unit.id}',
                  style: HvacTypography.bodyMedium.copyWith(
                    fontSize: 14.0,
                    color: HvacColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getModeDisplayName(VentilationMode mode) {
    return switch (mode) {
      VentilationMode.basic => 'Базовый',
      VentilationMode.intensive => 'Интенсивный',
      VentilationMode.economic => 'Экономичный',
      VentilationMode.maximum => 'Максимальный',
      VentilationMode.kitchen => 'Кухня',
      VentilationMode.fireplace => 'Камин',
      VentilationMode.vacation => 'Отпуск',
      VentilationMode.custom => 'Пользовательский',
    };
  }
}
