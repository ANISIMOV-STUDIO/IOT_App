/// Diagnostics Tab Widget
///
/// System diagnostics, sensor readings, and network status
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import 'diagnostics_cards.dart';

class DiagnosticsTab extends StatelessWidget {
  final HvacUnit unit;

  const DiagnosticsTab({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System health
          const SystemHealthCard(),

          const SizedBox(height: 20.0),

          // Sensor readings
          SensorReadingsCard(unit: unit),

          const SizedBox(height: 20.0),

          // Network status
          const NetworkStatusCard(),

          const SizedBox(height: 20.0),

          // Run diagnostics button
          SizedBox(
            width: double.infinity,
            child: HvacPrimaryButton(
              label: 'Запустить диагностику',
              onPressed: () => _runDiagnostics(context),
              icon: Icons.play_arrow,
            ),
          ),
        ],
      ),
    );
  }







  void _runDiagnostics(BuildContext context) {
    HvacAlertDialog.show(
      context,
      title: 'Диагностика',
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: HvacColors.primaryOrange,
            strokeWidth: 3.0,
          ),
          const SizedBox(height: 16.0),
          Text(
            'Выполняется диагностика системы...',
            style: HvacTypography.bodyMedium.copyWith(
              fontSize: 14.0,
              color: HvacColors.textSecondary,
            ),
          ),
        ],
      ),
      actions: [], // No actions during loading
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
