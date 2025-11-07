/// Example usage of HvacSwipeableCard
library;

import 'package:flutter/material.dart';
import '../hvac_swipeable_card.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class SwipeableCardExample extends StatelessWidget {
  const SwipeableCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundDark,
      appBar: AppBar(title: const Text('Swipeable Cards Example')),
      body: ListView(
        padding: EdgeInsets.all(HvacSpacing.md),
        children: [
          Text('Swipe left to turn off, right to turn on:',
               style: TextStyle(color: HvacColors.textSecondary)),
          SizedBox(height: HvacSpacing.md),

          HvacDeviceSwipeCard(
            deviceName: 'Living Room AC',
            status: 'Currently On - 24°C',
            onTurnOn: () => _showSnackbar(context, 'Device turned ON'),
            onTurnOff: () => _showSnackbar(context, 'Device turned OFF'),
            onSettings: () => _showSnackbar(context, 'Settings opened'),
          ),

          SizedBox(height: HvacSpacing.md),

          HvacDeviceSwipeCard(
            deviceName: 'Bedroom Heater',
            status: 'Currently Off',
            onTurnOn: () => _showSnackbar(context, 'Heater turned ON'),
            onTurnOff: () => _showSnackbar(context, 'Heater turned OFF'),
          ),

          SizedBox(height: HvacSpacing.lg),
          Text('Swipe to dismiss:', style: TextStyle(color: HvacColors.textSecondary)),
          SizedBox(height: HvacSpacing.md),

          HvacDismissibleCard(
            confirmMessage: 'Are you sure you want to remove this device?',
            onDismissed: () => _showSnackbar(context, 'Device removed'),
            child: Container(
              padding: EdgeInsets.all(HvacSpacing.md),
              decoration: BoxDecoration(
                color: HvacColors.backgroundCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.warning, color: HvacColors.warning),
                title: Text('Old Device'),
                subtitle: Text('Swipe to remove'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)),
    );
  }
}
