/// Device Search Widgets
///
/// Widget components for device search screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../bloc/hvac_list/hvac_list_bloc.dart';
import '../../bloc/hvac_list/hvac_list_event.dart';

/// Not found device card
class NotFoundDeviceCard extends StatelessWidget {
  final VoidCallback onTap;

  const NotFoundDeviceCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: HvacTheme.deviceCard(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: HvacColors.backgroundCardBorder,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
                size: 30,
                color: HvacColors.textTertiary,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Not found\ndevice?',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Select manually',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: HvacColors.primaryOrange,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Device operations helper
class DeviceOperations {
  /// Add selected devices to the system
  static void addSelectedDevices(
    BuildContext context,
    Set<int> selectedDevices,
    List<Map<String, dynamic>> discoveredDevices,
  ) {
    // Add each selected device
    for (final index in selectedDevices) {
      final device = discoveredDevices[index];
      context.read<HvacListBloc>().add(
            AddDeviceEvent(
              macAddress: device['macAddress'],
              name: device['name'],
              location: null,
            ),
          );
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${selectedDevices.length} ${selectedDevices.length == 1 ? 'device' : 'devices'} added',
        ),
        backgroundColor: HvacColors.success,
      ),
    );

    // Go back
    Navigator.of(context).pop();
  }
}
