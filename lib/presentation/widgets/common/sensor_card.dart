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
    final t = GlassTheme.of(context);

    if (isCompact) {
      return _buildCompact(t);
    }
    return _buildFull(t);
  }

  Widget _buildCompact(GlassThemeData t) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: GlassSpacing.sm,
        vertical: GlassSpacing.sm,
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

  Widget _buildFull(GlassThemeData t) {
    return GlassCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxHeight < 120;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(isSmall ? 6 : 10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: isSmall ? 18 : 24),
              ),
              SizedBox(height: isSmall ? 6 : 12),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: t.typography.numericLarge.copyWith(
                        fontSize: isSmall ? 20 : 28,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(unit, style: t.typography.labelSmall),
                  ],
                ),
              ),
              SizedBox(height: isSmall ? 2 : 4),
              Text(
                label,
                style: t.typography.labelSmall.copyWith(
                  color: t.colors.textSecondary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
