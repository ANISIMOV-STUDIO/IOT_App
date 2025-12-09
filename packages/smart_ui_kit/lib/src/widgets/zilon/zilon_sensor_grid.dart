import 'package:flutter/material.dart';
import '../../theme/tokens/app_typography.dart';
import '../smart/smart_card.dart';

class ZilonSensorGrid extends StatelessWidget {
  final double temperature;
  final double? co2;
  final double? humidity;

  const ZilonSensorGrid({
    super.key,
    required this.temperature,
    this.co2,
    this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSensorRow(context, Icons.thermostat, 'Temperature', '${temperature.toStringAsFixed(1)}°C'),
        const SizedBox(height: 12),
        if (humidity != null) ...[
           _buildSensorRow(context, Icons.water_drop, 'Humidity', '${humidity!.toStringAsFixed(0)}%'),
           const SizedBox(height: 12),
        ],
        if (co2 != null)
           _buildSensorRow(context, Icons.cloud, 'CO2', '${co2!.toStringAsFixed(0)} ppm'),
      ],
    );
  }

  Widget _buildSensorRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return SmartCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Text(label, style: AppTypography.bodyMedium.copyWith(color: theme.colorScheme.onSurface)),
          const Spacer(),
          Text(value, style: AppTypography.bodyLarge.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
