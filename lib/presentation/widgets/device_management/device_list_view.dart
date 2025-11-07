/// Device List View Widget
///
/// Main list view for displaying devices with refresh capability
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import 'device_list_item.dart';
import 'device_edit_dialog.dart';
import 'device_remove_dialog.dart';

class DeviceListView extends StatelessWidget {
  final List<dynamic> units;
  final Future<void> Function() onRefresh;
  final VoidCallback onItemTap;

  const DeviceListView({
    super.key,
    required this.units,
    required this.onRefresh,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return HvacRefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.md),
        itemCount: units.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final unit = units[index];
          const isOnline = true; // You can add online status logic here

          return DeviceListItem(
            unit: unit,
            isOnline: isOnline,
            onTap: () {
              // Navigate to device details
              Navigator.of(context).pop();
            },
            onEdit: () => _showEditDialog(context, unit),
            onDelete: () => _confirmRemoveDevice(context, unit),
          );
        },
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, dynamic unit) async {
    await showDialog(
      context: context,
      builder: (context) => DeviceEditDialog(unit: unit),
    );
  }

  Future<void> _confirmRemoveDevice(BuildContext context, dynamic unit) async {
    await showDialog<bool>(
      context: context,
      builder: (context) => DeviceRemoveDialog(
        unitId: unit.id,
        name: unit.name,
        macAddress: unit.macAddress,
      ),
    );
  }
}
