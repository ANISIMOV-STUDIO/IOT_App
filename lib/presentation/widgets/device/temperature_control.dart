/// Temperature Control Widget
///
/// Responsive temperature control for air conditioners
library;

import 'package:smart_ui_kit/smart_ui_kit.dart';

class TemperatureControl extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;

  const TemperatureControl({
    super.key,
    required this.value,
    this.min = 15,
    this.max = 29,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: GlassSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            min.toInt().toString(),
            style: const TextStyle(
              fontSize: 14.0,
              color: GlassColors.lightTextTertiary,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: GlassSpacing.md),
              child: Column(
                children: [
                  Text(
                    '${value.toInt()}°',
                    style: const TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: GlassColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: GlassSpacing.xs),
                  Slider(
                    value: value,
                    min: min,
                    max: max,
                    label: '${value.toInt()}°',
                    onChanged: onChanged,
                  ),
                ],
              ),
            ),
          ),
          Text(
            max.toInt().toString(),
            style: const TextStyle(
              fontSize: 14.0,
              color: GlassColors.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
