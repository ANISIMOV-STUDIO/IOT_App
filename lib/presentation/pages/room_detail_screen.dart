/// Room Detail Screen
/// Detailed control screen for a room/device with background image
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../bloc/hvac_detail/hvac_detail_bloc.dart';
import '../bloc/hvac_detail/hvac_detail_state.dart';
import 'room_detail/room_detail_header.dart';
import 'room_detail/room_detail_content.dart';

/// Main room detail screen
class RoomDetailScreen extends StatelessWidget {
  final String unitId;

  const RoomDetailScreen({
    super.key,
    required this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      body: BlocBuilder<HvacDetailBloc, HvacDetailState>(
        builder: (context, state) {
          if (state is HvacDetailLoading) {
            return _buildLoading();
          }

          if (state is HvacDetailError) {
            return _buildError(context, state.message);
          }

          if (state is HvacDetailLoaded) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        color: HvacColors.primaryOrange,
        strokeWidth: 3.r,
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: HvacColors.error,
            ),
            SizedBox(height: 24.h),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 24.sp,
                  ),
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HvacDetailLoaded state) {
    return CustomScrollView(
      slivers: [
        // Header with background image
        RoomDetailHeader(unit: state.unit),

        // Content with controls
        RoomDetailContent(state: state),
      ],
    );
  }
}