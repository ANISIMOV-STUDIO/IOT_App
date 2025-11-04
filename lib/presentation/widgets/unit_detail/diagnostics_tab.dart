/// Diagnostics Tab Widget
///
/// System diagnostics, sensor readings, and network status
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';

class DiagnosticsTab extends StatelessWidget {
  final HvacUnit unit;

  const DiagnosticsTab({
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
          // System health
          _buildSystemHealthCard(),

          SizedBox(height: 20.h),

          // Sensor readings
          _buildSensorReadingsCard(),

          SizedBox(height: 20.h),

          // Network status
          _buildNetworkStatusCard(),

          SizedBox(height: 20.h),

          // Run diagnostics button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _runDiagnostics(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: HvacColors.primaryOrange,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: HvacRadius.mdRadius,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, color: HvacColors.textPrimary, size: 24.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Запустить диагностику',
                    style: HvacTypography.buttonMedium.copyWith(
                      color: HvacColors.textPrimary,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemHealthCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
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
              Icon(Icons.health_and_safety, color: HvacColors.success, size: 20.sp),
              SizedBox(width: 12.w),
              Text(
                'Состояние системы',
                style: HvacTypography.titleLarge.copyWith(
                  fontSize: 16.sp,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          _buildHealthItem('Приточный вентилятор', true),
          _buildHealthItem('Вытяжной вентилятор', true),
          _buildHealthItem('Нагреватель', true),
          _buildHealthItem('Рекуператор', true),
          _buildHealthItem('Датчики', true),
        ],
      ),
    );
  }

  Widget _buildHealthItem(String label, bool isOk) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: HvacTypography.bodySmall.copyWith(
              fontSize: 13.sp,
              color: HvacColors.textSecondary,
            ),
          ),
          Row(
            children: [
              Icon(
                isOk ? Icons.check_circle : Icons.error,
                color: isOk ? HvacColors.success : HvacColors.error,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                isOk ? 'Норма' : 'Ошибка',
                style: HvacTypography.bodySmall.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isOk ? HvacColors.success : HvacColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorReadingsCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
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
              Icon(Icons.sensors, color: HvacColors.info, size: 20.sp),
              SizedBox(width: 12.w),
              Text(
                'Показания датчиков',
                style: HvacTypography.titleLarge.copyWith(
                  fontSize: 16.sp,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          _buildSensorItem(
            'Температура притока',
            '${unit.supplyAirTemp?.toInt() ?? 0}°C',
            HvacColors.primaryOrange,
          ),
          _buildSensorItem(
            'Температура улицы',
            '${unit.outdoorTemp?.toInt() ?? 0}°C',
            HvacColors.info,
          ),
          _buildSensorItem(
            'Влажность',
            '${unit.humidity.toInt()}%',
            HvacColors.success,
          ),
          _buildSensorItem(
            'Давление',
            '1013 Па',
            HvacColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildSensorItem(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
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
            style: HvacTypography.titleMedium.copyWith(
              fontSize: 14.sp,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkStatusCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
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
              Icon(
                unit.wifiStatus?.isConnected == true ? Icons.wifi : Icons.wifi_off,
                color: unit.wifiStatus?.isConnected == true
                    ? HvacColors.success
                    : HvacColors.error,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Сетевое подключение',
                style: HvacTypography.titleLarge.copyWith(
                  fontSize: 16.sp,
                  color: HvacColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          _buildNetworkItem('Статус', unit.wifiStatus?.isConnected == true ? 'Подключено' : 'Отключено'),
          _buildNetworkItem('Сеть', unit.wifiStatus?.connectedSSID ?? 'Не подключено'),
          _buildNetworkItem('Сигнал', '${unit.wifiStatus?.signalQuality ?? 0}%'),
          _buildNetworkItem('IP адрес', unit.wifiStatus?.ipAddress ?? 'Не назначен'),
        ],
      ),
    );
  }

  Widget _buildNetworkItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
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
      ),
    );
  }

  void _runDiagnostics(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: HvacColors.backgroundCard,
        title: Text(
          'Диагностика',
          style: HvacTypography.titleLarge.copyWith(
            color: HvacColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: HvacColors.primaryOrange,
              strokeWidth: 3.w,
            ),
            SizedBox(height: 16.h),
            Text(
              'Выполняется диагностика системы...',
              style: HvacTypography.bodyMedium.copyWith(
                fontSize: 14.sp,
                color: HvacColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );

    // Simulate diagnostics
    Future.delayed(const Duration(seconds: 2), () {
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Диагностика завершена. Система в норме.'),
          backgroundColor: HvacColors.success,
          duration: Duration(seconds: 3),
        ),
      );
    });
  }
}
