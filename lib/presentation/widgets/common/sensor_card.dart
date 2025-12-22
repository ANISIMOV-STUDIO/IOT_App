/// Sensor display card widget
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';

/// Compact sensor card for displaying temperature, humidity, CO2
class SensorCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;
  final String label;
  final Color color;
  final bool isCompact;

  const SensorCard({
    super.key,
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
    required this.color,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = NeumorphicTheme.of(context);

    if (isCompact) {
      return _buildCompact(t);
    }
    return _buildFull(t);
  }

  Widget _buildCompact(NeumorphicThemeData t) {
    return NeumorphicCard(
      padding: const EdgeInsets.symmetric(
        horizontal: NeumorphicSpacing.sm,
        vertical: NeumorphicSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            '$value$unit',
            style: t.typography.numericMedium.copyWith(color: color),
          ),
          Text(label, style: t.typography.labelSmall),
        ],
      ),
    );
  }

  Widget _buildFull(NeumorphicThemeData t) {
    return NeumorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: t.typography.numericLarge.copyWith(fontSize: 28),
              ),
              const SizedBox(width: 4),
              Text(unit, style: t.typography.bodySmall),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: t.typography.bodySmall.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
