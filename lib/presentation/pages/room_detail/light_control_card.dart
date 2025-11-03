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
        padding: EdgeInsets.all(16.w),
        decoration: HvacTheme.deviceCard(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 8.h),
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
                fontSize: 16.sp,
              ),
        ),
        Icon(
          Icons.lightbulb_outline,
          size: 20.sp,
          color: HvacColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4.h,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 8.r,
        ),
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: kIsWeb ? 16.r : 20.r,
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