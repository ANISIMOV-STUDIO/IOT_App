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
import '../../../core/utils/accessibility_helpers.dart';

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
      padding: const EdgeInsets.all(20.0),
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
            AccessibilityHelpers.semanticImage(
              image: SvgPicture.asset(
                'assets/images/zilon-logo.svg',
                height: 40.0,
                colorFilter: const ColorFilter.mode(
                  HvacColors.primaryOrange,
                  BlendMode.srcIn,
                ),
              ),
              label: 'BREEZ Home Logo',
            ),
            // User profile and Settings
            _buildUserSection(),
          ],
        ),
        const SizedBox(height: 12.0),
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
    return BlocBuilder<HvacListBloc, HvacListState>(
      builder: (context, state) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth >= 1024;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            SvgPicture.asset(
              'assets/images/zilon-logo.svg',
              height: 48.0,
              colorFilter: const ColorFilter.mode(
                HvacColors.primaryOrange,
                BlendMode.srcIn,
              ),
            ),

            // Center - HVAC Unit tabs
            Expanded(
              child: state is HvacListLoaded
                  ? _buildUnitTabs(state.units, isDesktop)
                  : const SizedBox.shrink(),
            ),

            // User profile and Settings
            _buildUserSection(),
          ],
        );
      },
    );
  }

  Widget _buildUnitTabs(List<HvacUnit> units, [bool isDesktop = false]) {
    final tabsContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...units.map((unit) {
          final label = unit.name;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: _buildUnitTab(label, selectedUnit == label),
          );
        }),
        // Add new unit button
        _buildAddUnitButton(),
      ],
    );

    if (isDesktop) {
      // Desktop: center the tabs horizontally
      return Center(
        child: tabsContent,
      );
    } else {
      // Tablet/Mobile: scrollable tabs
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: tabsContent,
      );
    }
  }

  Widget _buildUnitTab(String label, bool isSelected) {
    return Semantics(
      label: 'Select $label unit',
      hint: isSelected ? 'Currently selected' : AccessibilityHelpers.tapToOpen,
      button: true,
      selected: isSelected,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onUnitSelected(label),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color:
                  isSelected ? HvacColors.backgroundCard : Colors.transparent,
              borderRadius: HvacRadius.smRadius,
              border: Border.all(
                color: isSelected
                    ? HvacColors.backgroundCardBorder
                    : Colors.transparent,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
                color: isSelected
                    ? HvacColors.textPrimary
                    : HvacColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddUnitButton() {
    return Semantics(
      label: 'Add new unit',
      hint: AccessibilityHelpers.tapToOpen,
      button: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onAddUnitPressed,
          child: Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: HvacColors.backgroundCard,
              shape: BoxShape.circle,
              border: Border.all(
                color: HvacColors.backgroundCardBorder,
              ),
            ),
            child: const Icon(
              Icons.add,
              size: 20.0,
              color: HvacColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserSection() {
    return Row(
      children: [
        AccessibilityHelpers.createSemanticIconButton(
          icon: Icons.settings_outlined,
          onPressed: onSettingsPressed,
          label: 'Settings',
          hint: 'Open application settings',
          color: HvacColors.textSecondary,
          iconSize: 24.0,
        ),
        const SizedBox(width: 8.0),
        Semantics(
          label: 'User profile',
          hint: 'Double tap to open user menu',
          button: true,
          child: const CircleAvatar(
            radius: 18.0,
            backgroundColor: HvacColors.backgroundCard,
            child: Icon(
              Icons.person_outline,
              size: 20.0,
              color: HvacColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        ExcludeSemantics(
          child: const Icon(
            Icons.keyboard_arrow_down,
            color: HvacColors.textSecondary,
            size: 20.0,
          ),
        ),
      ],
    );
  }
}
