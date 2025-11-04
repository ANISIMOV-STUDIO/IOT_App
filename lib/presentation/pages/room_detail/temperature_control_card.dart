/// Temperature Control Card Component
/// Temperature control with current and target display
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import '../../bloc/hvac_detail/hvac_detail_bloc.dart';
import '../../bloc/hvac_detail/hvac_detail_event.dart';

/// Temperature control card widget
class TemperatureControlCard extends StatelessWidget {
  final HvacUnit unit;

  const TemperatureControlCard({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: HvacTheme.deviceCard(),
      child: Column(
        children: [
          _buildTemperatureDisplay(context),
          SizedBox(height: 20.h),
          _buildTemperatureSlider(context),
        ],
      ),
    );
  }

  Widget _buildTemperatureDisplay(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTemperatureInfo(
          context,
          label: 'Current',
          value: '${unit.currentTemp.toInt()}°',
          isTarget: false,
        ),
        _buildTemperatureInfo(
          context,
          label: 'Target',
          value: '${unit.targetTemp.toInt()}°',
          isTarget: true,
        ),
      ],
    );
  }

  Widget _buildTemperatureInfo(
    BuildContext context, {
    required String label,
    required String value,
    required bool isTarget,
  }) {
    return Column(
      crossAxisAlignment:
          isTarget ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: isTarget ? HvacColors.primaryOrange : null,
              ),
        ),
      ],
    );
  }

  Widget _buildTemperatureSlider(BuildContext context) {
    return MouseRegion(
      cursor: kIsWeb ? SystemMouseCursors.grab : MouseCursor.defer,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 6.h,
          thumbShape: RoundSliderThumbShape(
            enabledThumbRadius: 10.r,
          ),
          overlayShape: RoundSliderOverlayShape(
            overlayRadius: kIsWeb ? 20.r : 24.r,
          ),
          valueIndicatorTextStyle: HvacTypography.bodyMedium.copyWith(
            fontSize: 14.sp,
          ),
        ),
        child: Slider(
          value: unit.targetTemp,
          min: 16,
          max: 30,
          divisions: 28,
          label: '${unit.targetTemp.toInt()}°',
          onChanged: (value) {
            context.read<HvacDetailBloc>().add(
                  UpdateTargetTempEvent(value),
                );
          },
          activeColor: HvacColors.primaryOrange,
          inactiveColor: HvacColors.backgroundCardBorder,
        ),
      ),
    );
  }
}