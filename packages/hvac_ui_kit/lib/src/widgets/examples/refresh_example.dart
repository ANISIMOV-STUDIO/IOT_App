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
          padding: EdgeInsets.all(HvacSpacing.md),
          itemCount: _devices.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
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
              padding: EdgeInsets.only(bottom: HvacSpacing.sm),
              child: _buildDeviceCard(_devices[index - 1]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDeviceCard(String deviceName) {
    return Container(
      padding: EdgeInsets.all(HvacSpacing.md),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.mdRadius,
        border: Border.all(color: HvacColors.backgroundCardBorder),
      ),
      child: Row(
        children: [
          Icon(
            Icons.device_thermostat,
            color: HvacColors.primaryOrange,
            size: 32,
          ),
          SizedBox(width: HvacSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: HvacColors.textPrimary,
                  ),
                ),
                SizedBox(height: HvacSpacing.xxs),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 14,
                    color: HvacColors.success,
                  ),
                ),
              ],
            ),
          ),
          Text(
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
  State<CupertinoRefreshExample> createState() => _CupertinoRefreshExampleState();
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
                  leading: Icon(Icons.device_thermostat, color: HvacColors.primaryOrange),
                  title: Text('Device ${index + 1}'),
                  subtitle: Text('Status: Online'),
                  trailing: Text('24°C'),
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
