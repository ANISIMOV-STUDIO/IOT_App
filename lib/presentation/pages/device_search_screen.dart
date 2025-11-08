/// Device Search/Add Screen
///
/// Screen for searching and adding new devices
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../generated/l10n/app_localizations.dart';
import '../widgets/device_card.dart';
import 'device_search/device_search_widgets.dart';
import 'device_search/device_search_dialogs.dart';

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
                itemCount:
                    _discoveredDevices.length + 1, // +1 for "Not found" card
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
                    return NotFoundDeviceCard(
                      onTap: () => ManualDeviceEntryDialog.show(context),
                    );
                  }
                },
              ),
            ),
          ),

          // Add Device Button
          Padding(
            padding: const EdgeInsets.all(HvacSpacing.xlR),
            child: HvacPrimaryButton(
              label: l10n.addDevice,
              isExpanded: true,
              onPressed: _selectedDevices.isEmpty
                  ? null
                  : () => DeviceOperations.addSelectedDevices(
                        context,
                        _selectedDevices,
                        _discoveredDevices,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
