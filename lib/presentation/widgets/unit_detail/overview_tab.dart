/// Overview Tab Widget
///
/// Overview tab for unit detail screen showing status, stats, fans, and maintenance
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../../domain/entities/ventilation_mode.dart';
import 'unit_stat_card.dart';

class OverviewTab extends StatelessWidget {
  final HvacUnit unit;

  const OverviewTab({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          _buildStatusCard(),
          SizedBox(height: 20.h),

          // Quick stats
          Row(
            children: [
              const Expanded(
                child: UnitStatCard(
                  label: 'Время работы',
                  value: '2ч 15м',
                  icon: Icons.access_time,
                  color: HvacColors.info,
                ),
              ),
              SizedBox(width: 16.w),
              const Expanded(
                child: UnitStatCard(
                  label: 'Энергия',
                  value: '350 Вт',
                  icon: Icons.bolt,
                  color: HvacColors.warning,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Row(
            children: [
              Expanded(
                child: UnitStatCard(
                  label: 'Температура притока',
                  value: '${unit.supplyAirTemp?.toInt() ?? 0}°C',
                  icon: Icons.thermostat,
                  color: HvacColors.success,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: UnitStatCard(
                  label: 'Влажность',
                  value: '${unit.humidity.toInt()}%',
                  icon: Icons.water_drop,
                  color: HvacColors.info,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Fan speeds card
          _buildFanSpeedsCard(),
          SizedBox(height: 20.h),

          // Maintenance card
          _buildMaintenanceCard(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: unit.power
                  ? HvacColors.success.withValues(alpha: 0.2)
                  : HvacColors.error.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              unit.power ? Icons.check_circle : Icons.power_off,
              color: unit.power ? HvacColors.success : HvacColors.error,
              size: 40.sp,
            ),
          ),
          SizedBox(width: 20.w),

          // Status text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.power ? 'Работает' : 'Выключено',
                  style: HvacTypography.displaySmall.copyWith(
                    fontSize: 24.sp,
                    color: unit.power ? HvacColors.success : HvacColors.error,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Режим: ${unit.ventMode != null ? _getModeDisplayName(unit.ventMode!) : "Не установлен"}',
                  style: HvacTypography.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    color: HvacColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'ID устройства: ${unit.id}',
                  style: HvacTypography.bodyMedium.copyWith(
                    fontSize: 14.sp,
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

  Widget _buildFanSpeedsCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Скорости вентиляторов',
            style: HvacTypography.titleLarge.copyWith(
              fontSize: 16.sp,
              color: HvacColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),

          // Supply fan
          _buildFanRow(
            'Приточный',
            unit.supplyFanSpeed ?? 0,
            HvacColors.primaryOrange,
          ),
          SizedBox(height: 12.h),

          // Exhaust fan
          _buildFanRow(
            'Вытяжной',
            unit.exhaustFanSpeed ?? 0,
            HvacColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildFanRow(String label, int speed, Color color) {
    return Row(
      children: [
        Icon(Icons.air, color: color, size: 20.sp),
        SizedBox(width: 12.w),
        Text(
          label,
          style: HvacTypography.bodyMedium.copyWith(
            fontSize: 14.sp,
            color: HvacColors.textSecondary,
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            '$speed%',
            style: HvacTypography.titleLarge.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaintenanceCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: HvacColors.backgroundCardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.build, color: HvacColors.warning, size: 20.sp),
              SizedBox(width: 12.w),
              Text(
                'Обслуживание',
                style: HvacTypography.titleLarge.copyWith(
                  fontSize: 16.sp,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          _buildMaintenanceItem('Последнее обслуживание', '15 дней назад'),
          SizedBox(height: 8.h),
          _buildMaintenanceItem('Фильтр приточный', '70% ресурса'),
          SizedBox(height: 8.h),
          _buildMaintenanceItem('Фильтр вытяжной', '85% ресурса'),
          SizedBox(height: 8.h),
          _buildMaintenanceItem('Следующее ТО', 'через 45 дней'),
        ],
      ),
    );
  }

  Widget _buildMaintenanceItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: HvacTypography.bodySmall.copyWith(
            fontSize: 13.sp,
            color: HvacColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: HvacTypography.bodySmall.copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: HvacColors.textPrimary,
          ),
        ),
      ],
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
