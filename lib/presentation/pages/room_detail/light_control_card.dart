/// Light Control Card Component
/// Light control with slider
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

/// Light control card widget
class LightControlCard extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const LightControlCard({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: HvacTheme.deviceCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 8.0),
            _buildSlider(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16.0,
              ),
        ),
        const Icon(
          Icons.lightbulb_outline,
          size: 20.0,
          color: HvacColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4.0,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8.0,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: kIsWeb ? 16.0 : 20.0,
        ),
      ),
      child: Slider(
        value: value,
        onChanged: (newValue) {
          if (!kIsWeb) {
            HapticFeedback.selectionClick();
          }
          onChanged(newValue);
        },
        activeColor: HvacColors.primaryOrange,
        inactiveColor: HvacColors.backgroundCardBorder,
      ),
    );
  }
}
