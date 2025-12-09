import 'package:flutter/material.dart';
import '../../theme/tokens/app_typography.dart';
import '../smart/smart_card.dart';

class ZilonControlCard extends StatelessWidget {
  final double supplyAirflow;
  final double exhaustAirflow;
  final ValueChanged<double> onSupplyChanged;
  final ValueChanged<double> onExhaustChanged;

  const ZilonControlCard({
    super.key,
    required this.supplyAirflow,
    required this.exhaustAirflow,
    required this.onSupplyChanged,
    required this.onExhaustChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text('Airflow Control', style: AppTypography.displayMedium.copyWith(fontSize: 18, color: theme.colorScheme.onSurface)),
               Icon(Icons.tune, color: theme.colorScheme.primary),
            ],
          ),
          const SizedBox(height: 24),
          _buildSlider(context, 'Supply', supplyAirflow, onSupplyChanged),
          const SizedBox(height: 16),
          _buildSlider(context, 'Exhaust', exhaustAirflow, onExhaustChanged),
        ],
      ),
    );
  }

  Widget _buildSlider(BuildContext context, String label, double value, ValueChanged<double> onChanged) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodyMedium.copyWith(color: theme.colorScheme.onSurface)),
            Text('${value.round()}%', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor: theme.colorScheme.outline,
            thumbColor: theme.colorScheme.primary,
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
