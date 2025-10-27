/// HVAC Detail Screen
///
/// iOS 26 Liquid Glass redesigned detail view
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart';
import '../bloc/hvac_detail/hvac_detail_bloc.dart';
import '../bloc/hvac_detail/hvac_detail_event.dart';
import 'liquid_glass_hvac_detail.dart';

class HvacDetailScreen extends StatelessWidget {
  final String unitId;

  const HvacDetailScreen({
    super.key,
    required this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HvacDetailBloc>(param1: unitId)
        ..add(const LoadUnitDetailEvent()),
      child: LiquidGlassHvacDetail(unitId: unitId),
    );
  }
}
