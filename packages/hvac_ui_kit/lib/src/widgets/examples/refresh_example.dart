/// Example usage of HvacRefresh
library;

import 'package:flutter/material.dart';
import '../hvac_refresh.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

class RefreshExample extends StatefulWidget {
  const RefreshExample({super.key});

  @override
  State<RefreshExample> createState() => _RefreshExampleState();
}

class _RefreshExampleState extends State<RefreshExample> {
  List<String> _devices = [
    'Living Room AC',
    'Bedroom Heater',
    'Kitchen Fan',
    'Bathroom Ventilation',
  ];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _devices = [..._devices, 'New Device ${_devices.length + 1}'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Pull to Refresh'),
        backgroundColor: HvacColors.backgroundDark,
      ),
      body: HvacRefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
          padding: const EdgeInsets.all(HvacSpacing.md),
          itemCount: _devices.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const Padding(
                padding: EdgeInsets.only(bottom: HvacSpacing.md),
                child: Text(
                  'Pull down to refresh device list',
                  style: TextStyle(
                    color: HvacColors.textSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: HvacSpacing.sm),
              child: _buildDeviceCard(_devices[index - 1]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDeviceCard(String deviceName) {
    return Container(
      padding: const EdgeInsets.all(HvacSpacing.md),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.device_thermostat,
            color: HvacColors.primaryOrange,
            size: 32,
          ),
          const SizedBox(width: HvacSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: HvacColors.textPrimary,
                  ),
                ),
                const SizedBox(height: HvacSpacing.xxs),
                const Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 14,
                    color: HvacColors.success,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            '24°C',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: HvacColors.primaryOrange,
            ),
          ),
        ],
      ),
    );
  }
}

/// Example with Cupertino refresh
class CupertinoRefreshExample extends StatefulWidget {
  const CupertinoRefreshExample({super.key});

  @override
  State<CupertinoRefreshExample> createState() =>
      _CupertinoRefreshExampleState();
}

class _CupertinoRefreshExampleState extends State<CupertinoRefreshExample> {
  int _itemCount = 10;

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _itemCount += 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Cupertino Refresh'),
        backgroundColor: HvacColors.backgroundDark,
      ),
      body: HvacCupertinoRefresh(
        onRefresh: _handleRefresh,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  leading: const Icon(Icons.device_thermostat,
                      color: HvacColors.primaryOrange),
                  title: Text('Device ${index + 1}'),
                  subtitle: const Text('Status: Online'),
                  trailing: const Text('24°C'),
                );
              },
              childCount: _itemCount,
            ),
          ),
        ],
      ),
    );
  }
}
