/// Home App Bar Widget
///
/// Top navigation bar with logo, unit tabs, and user profile
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../bloc/hvac_list/hvac_list_bloc.dart';
import '../../bloc/hvac_list/hvac_list_state.dart';
import '../../../domain/entities/hvac_unit.dart';

class HomeAppBar extends StatelessWidget {
  final String? selectedUnit;
  final ValueChanged<String> onUnitSelected;
  final VoidCallback onSettingsPressed;
  final VoidCallback? onAddUnitPressed;

  const HomeAppBar({
    super.key,
    this.selectedUnit,
    required this.onUnitSelected,
    required this.onSettingsPressed,
    this.onAddUnitPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: isMobile ? _buildMobileLayout() : _buildTabletLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Top row: Logo and User section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            SvgPicture.asset(
              'assets/images/zilon-logo.svg',
              height: 40.h,
              colorFilter: const ColorFilter.mode(
                Color(0xFFFF9D5C),
                BlendMode.srcIn,
              ),
            ),
            // User profile and Settings
            _buildUserSection(),
          ],
        ),
        SizedBox(height: 12.h),
        // Bottom row: Unit tabs
        BlocBuilder<HvacListBloc, HvacListState>(
          builder: (context, state) {
            if (state is HvacListLoaded) {
              return _buildUnitTabs(state.units);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        SvgPicture.asset(
          'assets/images/zilon-logo.svg',
          height: 48.h,
          colorFilter: const ColorFilter.mode(
            Color(0xFFFF9D5C),
            BlendMode.srcIn,
          ),
        ),

        // Center - HVAC Unit tabs
        Expanded(
          child: BlocBuilder<HvacListBloc, HvacListState>(
            builder: (context, state) {
              if (state is HvacListLoaded) {
                return _buildUnitTabs(state.units);
              }
              return const SizedBox.shrink();
            },
          ),
        ),

        // User profile and Settings
        _buildUserSection(),
      ],
    );
  }

  Widget _buildUnitTabs(List<HvacUnit> units) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...units.map((unit) {
            final label = unit.name;
            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: _buildUnitTab(label, selectedUnit == label),
            );
          }),
          // Add new unit button
          _buildAddUnitButton(),
        ],
      ),
    );
  }

  Widget _buildUnitTab(String label, bool isSelected) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onUnitSelected(label),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? HvacColors.backgroundCard : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? HvacColors.backgroundCardBorder : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: isSelected ? HvacColors.textPrimary : HvacColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddUnitButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onAddUnitPressed,
        child: Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: HvacColors.backgroundCard,
            shape: BoxShape.circle,
            border: Border.all(
              color: HvacColors.backgroundCardBorder,
            ),
          ),
          child: Icon(
            Icons.add,
            size: 20.sp,
            color: HvacColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildUserSection() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: HvacColors.textSecondary,
            size: 24.sp,
          ),
          onPressed: onSettingsPressed,
        ),
        SizedBox(width: 8.w),
        CircleAvatar(
          radius: 18.r,
          backgroundColor: HvacColors.backgroundCard,
          child: Icon(
            Icons.person_outline,
            size: 20.sp,
            color: HvacColors.textSecondary,
          ),
        ),
        SizedBox(width: 8.w),
        Icon(
          Icons.keyboard_arrow_down,
          color: HvacColors.textSecondary,
          size: 20.sp,
        ),
      ],
    );
  }
}
