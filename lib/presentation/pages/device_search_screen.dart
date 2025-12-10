/// Device Search/Add Screen
///
/// Screen for searching and adding new devices
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../generated/l10n/app_localizations.dart';
import 'device_search/device_search_widgets.dart';
import 'device_search/device_search_dialogs.dart';

class DeviceSearchScreen extends StatefulWidget {
  const DeviceSearchScreen({super.key});

  @override
  State<DeviceSearchScreen> createState() => _DeviceSearchScreenState();
}

class _DeviceSearchScreenState extends State<DeviceSearchScreen> {
  final List<Map<String, dynamic>> _discoveredDevices = [
    {'name': 'Bork V530', 'type': 'Vacuum cleaner', 'icon': Icons.cleaning_services, 'macAddress': 'AA:BB:CC:DD:EE:01'},
    {'name': 'LIFX LED Light', 'type': 'Smart bulb', 'icon': Icons.lightbulb, 'macAddress': 'AA:BB:CC:DD:EE:02'},
    {'name': 'Xiaomi DEM-F600', 'type': 'Humidifier', 'icon': Icons.water_drop, 'macAddress': 'AA:BB:CC:DD:EE:03'},
  ];

  final Set<int> _selectedDevices = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: HvacAppBar(
        title: 'Search',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: HvacSpacing.md),
            child: Center(child: Text('WiFi: bwH_413_7G', style: Theme.of(context).textTheme.bodySmall)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(HvacSpacing.xlR),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('${_discoveredDevices.length} new devices', style: Theme.of(context).textTheme.bodyMedium)],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.xlR),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.85,
                ),
                itemCount: _discoveredDevices.length + 1,
                itemBuilder: (context, index) {
                  if (index < _discoveredDevices.length) {
                    final device = _discoveredDevices[index];
                    final isSelected = _selectedDevices.contains(index);
                    return _DeviceCard(
                      name: device['name'],
                      subtitle: device['type'],
                      icon: device['icon'],
                      isSelected: isSelected,
                      onTap: () => setState(() => isSelected ? _selectedDevices.remove(index) : _selectedDevices.add(index)),
                    );
                  } else {
                    return NotFoundDeviceCard(onTap: () => ManualDeviceEntryDialog.show(context));
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(HvacSpacing.xlR),
            child: HvacPrimaryButton(
              label: l10n.addDevice,
              isExpanded: true,
              onPressed: _selectedDevices.isEmpty ? null : () => DeviceOperations.addSelectedDevices(context, _selectedDevices, _discoveredDevices),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeviceCard({required this.name, required this.subtitle, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).iconTheme.color),
            const SizedBox(height: 12),
            Text(name, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
