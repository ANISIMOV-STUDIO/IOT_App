/// Diagnostics Cards
///
/// Card components for diagnostics tab
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';

/// System Health Card
class SystemHealthCard extends StatelessWidget {
  const SystemHealthCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.health_and_safety,
                  color: HvacColors.success, size: 20.0),
              const SizedBox(width: 12.0),
              Text(
                'Состояние системы',
                style: HvacTypography.titleLarge.copyWith(
                  fontSize: 16.0,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const _HealthItem(label: 'Приточный вентилятор', isOk: true),
          const _HealthItem(label: 'Вытяжной вентилятор', isOk: true),
          const _HealthItem(label: 'Нагреватель', isOk: true),
          const _HealthItem(label: 'Рекуператор', isOk: true),
          const _HealthItem(label: 'Датчики', isOk: true),
        ],
      ),
    );
  }
}

class _HealthItem extends StatelessWidget {
  final String label;
  final bool isOk;

  const _HealthItem({
    required this.label,
    required this.isOk,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 28.0,
            height: 28.0,
            decoration: BoxDecoration(
              color: (isOk ? HvacColors.success : HvacColors.error)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOk ? Icons.check_circle : Icons.error,
              color: isOk ? HvacColors.success : HvacColors.error,
              size: 16.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              label,
              style: HvacTypography.bodyMedium.copyWith(
                color: HvacColors.textPrimary,
                fontSize: 14.0,
              ),
            ),
          ),
          Text(
            isOk ? 'Работает' : 'Ошибка',
            style: HvacTypography.bodySmall.copyWith(
              color: isOk ? HvacColors.success : HvacColors.error,
              fontWeight: FontWeight.w500,
              fontSize: 13.0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sensor Readings Card
class SensorReadingsCard extends StatelessWidget {
  final HvacUnit unit;

  const SensorReadingsCard({
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sensors, color: HvacColors.info, size: 20.0),
              const SizedBox(width: 12.0),
              Text(
                'Показания датчиков',
                style: HvacTypography.titleLarge.copyWith(
                  fontSize: 16.0,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          _SensorItem(
            label: 'Температура притока',
            value:
                unit.supplyAirTemp != null ? '${unit.supplyAirTemp}°C' : '--',
            color: HvacColors.info,
          ),
          _SensorItem(
            label: 'Температура вытяжки',
            value: unit.roomTemp != null ? '${unit.roomTemp}°C' : '--',
            color: HvacColors.warning,
          ),
          const _SensorItem(
            label: 'CO₂',
            value: '-- ppm',
            color: HvacColors.success,
          ),
          const _SensorItem(
            label: 'VOC',
            value: '-- ppb',
            color: HvacColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _SensorItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SensorItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: HvacTypography.bodyMedium.copyWith(
              color: HvacColors.textSecondary,
              fontSize: 14.0,
            ),
          ),
          Text(
            value,
            style: HvacTypography.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Network Status Card
class NetworkStatusCard extends StatelessWidget {
  const NetworkStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wifi, color: HvacColors.success, size: 20.0),
              const SizedBox(width: 12.0),
              Text(
                'Сетевое подключение',
                style: HvacTypography.titleLarge.copyWith(
                  fontSize: 16.0,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const _NetworkItem(label: 'Статус', value: 'Подключено'),
          const _NetworkItem(label: 'Тип', value: 'Wi-Fi'),
          const _NetworkItem(label: 'Сигнал', value: 'Отлично'),
          const _NetworkItem(label: 'IP адрес', value: '192.168.1.100'),
        ],
      ),
    );
  }
}

class _NetworkItem extends StatelessWidget {
  final String label;
  final String value;

  const _NetworkItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: HvacTypography.bodyMedium.copyWith(
              color: HvacColors.textSecondary,
              fontSize: 14.0,
            ),
          ),
          Text(
            value,
            style: HvacTypography.bodyMedium.copyWith(
              color: HvacColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
