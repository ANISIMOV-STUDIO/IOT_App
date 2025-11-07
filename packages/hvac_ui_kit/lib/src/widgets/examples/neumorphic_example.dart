/// Example usage of HvacNeumorphic widgets
library;

import 'package:flutter/material.dart';
import '../hvac_neumorphic.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class NeumorphicExample extends StatefulWidget {
  const NeumorphicExample({super.key});

  @override
  State<NeumorphicExample> createState() => _NeumorphicExampleState();
}

class _NeumorphicExampleState extends State<NeumorphicExample> {
  bool _isToggled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HvacColors.backgroundCard,
      appBar: AppBar(
        title: const Text('Neumorphism Design'),
        backgroundColor: HvacColors.backgroundCard,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(HvacSpacing.lg),
        children: [
          Text(
            'Soft 3D Buttons:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HvacColors.textPrimary,
            ),
          ),
          SizedBox(height: HvacSpacing.md),

          // Regular buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HvacNeumorphicButton(
                onPressed: () => _showMessage('Button 1 pressed'),
                width: 100,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.power_settings_new, size: 32),
                    SizedBox(height: HvacSpacing.xs),
                    Text('Power'),
                  ],
                ),
              ),
              HvacNeumorphicButton(
                onPressed: () => _showMessage('Button 2 pressed'),
                width: 100,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.ac_unit, size: 32),
                    SizedBox(height: HvacSpacing.xs),
                    Text('Cool'),
                  ],
                ),
              ),
              HvacNeumorphicButton(
                onPressed: () => _showMessage('Button 3 pressed'),
                width: 100,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wb_sunny, size: 32),
                    SizedBox(height: HvacSpacing.xs),
                    Text('Heat'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: HvacSpacing.xl),

          Text(
            'Icon Buttons:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HvacColors.textPrimary,
            ),
          ),
          SizedBox(height: HvacSpacing.md),

          // Icon buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HvacNeumorphicIconButton(
                icon: Icons.arrow_upward,
                onPressed: () => _showMessage('Up pressed'),
              ),
              HvacNeumorphicIconButton(
                icon: Icons.settings,
                onPressed: () => _showMessage('Settings pressed'),
                iconColor: HvacColors.primaryOrange,
              ),
              HvacNeumorphicIconButton(
                icon: Icons.arrow_downward,
                onPressed: () => _showMessage('Down pressed'),
              ),
            ],
          ),
          SizedBox(height: HvacSpacing.xl),

          Text(
            'Toggle Button:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HvacColors.textPrimary,
            ),
          ),
          SizedBox(height: HvacSpacing.md),

          Center(
            child: HvacNeumorphicToggle(
              value: _isToggled,
              onChanged: (val) => setState(() => _isToggled = val),
            ),
          ),
          SizedBox(height: HvacSpacing.xl),

          Text(
            'Neumorphic Card:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: HvacColors.textPrimary,
            ),
          ),
          SizedBox(height: HvacSpacing.md),

          HvacNeumorphicCard(
            onTap: () => _showMessage('Card tapped'),
            child: Column(
              children: [
                Icon(Icons.thermostat, size: 48, color: HvacColors.primaryOrange),
                SizedBox(height: HvacSpacing.md),
                Text(
                  'Living Room',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: HvacSpacing.xs),
                Text(
                  '24°C',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: HvacColors.primaryOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)),
    );
  }
}
