/// Unit Detail Tablet Sidebar
///
/// Navigation sidebar for tablet layout
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';

class UnitDetailTabletSidebar extends StatelessWidget {
  final HvacUnit unit;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const UnitDetailTabletSidebar({
    super.key,
    required this.unit,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.0,
      decoration: const BoxDecoration(
        color: HvacColors.backgroundCard,
        border: Border(
          right: BorderSide(
            color: HvacColors.backgroundCardBorder,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: HvacSpacing.lgV),
          _buildSidebarItem(
            index: 0,
            icon: Icons.dashboard,
            label: 'Обзор',
            isSelected: selectedIndex == 0,
          ),
          _buildSidebarItem(
            index: 1,
            icon: Icons.air,
            label: 'Качество воздуха',
            isSelected: selectedIndex == 1,
          ),
          _buildSidebarItem(
            index: 2,
            icon: Icons.warning,
            label: 'История аварий',
            isSelected: selectedIndex == 2,
          ),
          _buildSidebarItem(
            index: 3,
            icon: Icons.build,
            label: 'Диагностика',
            isSelected: selectedIndex == 3,
          ),
          const Spacer(),
          _buildDeviceInfo(),
          const SizedBox(height: HvacSpacing.lgV),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Material(
      color: isSelected
          ? HvacColors.primaryOrange.withValues(alpha: 0.1)
          : Colors.transparent,
      child: InkWell(
        onTap: () => onItemSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.lgR,
            vertical: HvacSpacing.mdV,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20.0,
                color: isSelected
                    ? HvacColors.primaryOrange
                    : HvacColors.textSecondary,
              ),
              const SizedBox(width: HvacSpacing.mdR),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? HvacColors.primaryOrange
                        : HvacColors.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 3.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: HvacColors.primaryOrange,
                    borderRadius: HvacRadius.xsRadius,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceInfo() {
    return Padding(
      padding: const EdgeInsets.all(HvacSpacing.lgR),
      child: Column(
        children: [
          _buildInfoRow('Тип:', unit.deviceType.name),
          const SizedBox(height: HvacSpacing.smV),
          _buildInfoRow('MAC:', unit.macAddress ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            color: HvacColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: HvacColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}