/// Device Loading State Widget
///
/// Displayed while loading devices
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';

class DeviceLoadingState extends StatelessWidget {
  const DeviceLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.md),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: HvacSpacing.sm),
          child: HvacSkeletonLoader(
            isLoading: true,
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: HvacColors.backgroundCard,
                borderRadius: HvacRadius.lgRadius,
              ),
            ),
          ),
        );
      },
    );
  }
}