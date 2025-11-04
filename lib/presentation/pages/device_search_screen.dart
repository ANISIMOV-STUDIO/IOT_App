/// Device Search/Add Screen
///
/// Screen for searching and adding new devices
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../generated/l10n/app_localizations.dart';
import '../bloc/hvac_list/hvac_list_bloc.dart';
import '../bloc/hvac_list/hvac_list_event.dart';
import '../widgets/device_card.dart';
import '../widgets/orange_button.dart';

class DeviceSearchScreen extends StatefulWidget {
  const DeviceSearchScreen({super.key});

  @override
  State<DeviceSearchScreen> createState() => _DeviceSearchScreenState();
}

class _DeviceSearchScreenState extends State<DeviceSearchScreen> {
  final List<Map<String, dynamic>> _discoveredDevices = [
    {
      'name': 'Bork V530',
      'type': 'Vacuum cleaner',
      'icon': Icons.cleaning_services,
      'macAddress': 'AA:BB:CC:DD:EE:01',
    },
    {
      'name': 'LIFX LED Light',
      'type': 'Smart bulb',
      'icon': Icons.lightbulb,
      'macAddress': 'AA:BB:CC:DD:EE:02',
    },
    {
      'name': 'Xiaomi DEM-F600',
      'type': 'Humidifier',
      'icon': Icons.water_drop,
      'macAddress': 'AA:BB:CC:DD:EE:03',
    },
  ];

  final Set<int> _selectedDevices = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          // WiFi indicator
          Padding(
            padding: const EdgeInsets.only(right: HvacSpacing.md),
            child: Center(
              child: Text(
                'WiFi: bwH_413_7G',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(HvacSpacing.xlR),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_discoveredDevices.length} new devices',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          // Device Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.xlR),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: _discoveredDevices.length + 1, // +1 for "Not found" card
                itemBuilder: (context, index) {
                  if (index < _discoveredDevices.length) {
                    final device = _discoveredDevices[index];
                    final isSelected = _selectedDevices.contains(index);

                    return DeviceCard(
                      name: device['name'],
                      subtitle: device['type'],
                      icon: device['icon'],
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedDevices.remove(index);
                          } else {
                            _selectedDevices.add(index);
                          }
                        });
                      },
                    );
                  } else {
                    // "Not found device?" card
                    return _buildNotFoundCard(context);
                  }
                },
              ),
            ),
          ),

          // Add Device Button
          Padding(
            padding: const EdgeInsets.all(HvacSpacing.xlR),
            child: OrangeButton(
              text: l10n.addDevice,
              width: double.infinity,
              onPressed: _selectedDevices.isEmpty
                  ? null
                  : () => _addSelectedDevices(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showManualEntryDialog(context),
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
            SizedBox(height: 12.h),
            Text(
              'Not found\ndevice?',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
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

  void _addSelectedDevices(BuildContext context) {
    // Add each selected device
    for (final index in _selectedDevices) {
      final device = _discoveredDevices[index];
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
          '${_selectedDevices.length} ${_selectedDevices.length == 1 ? 'device' : 'devices'} added',
        ),
        backgroundColor: HvacColors.success,
      ),
    );

    // Go back
    Navigator.of(context).pop();
  }

  void _showManualEntryDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final macController = TextEditingController();
    final nameController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.addDevice),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: macController,
                decoration: InputDecoration(
                  labelText: l10n.macAddress,
                  hintText: 'XX:XX:XX:XX:XX:XX',
                  prefixIcon: const Icon(Icons.router),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.deviceName,
                  hintText: l10n.livingRoom,
                  prefixIcon: const Icon(Icons.label),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: l10n.location,
                  hintText: l10n.optional,
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final mac = macController.text.trim();
              final name = nameController.text.trim();

              if (mac.isEmpty || name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.fillRequiredFields),
                    backgroundColor: HvacColors.error,
                  ),
                );
                return;
              }

              context.read<HvacListBloc>().add(
                AddDeviceEvent(
                  macAddress: mac,
                  name: name,
                  location: locationController.text.isEmpty
                      ? null
                      : locationController.text.trim(),
                ),
              );

              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.deviceAdded),
                  backgroundColor: HvacColors.success,
                ),
              );
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }
}
