/// Example usage of HvacLiquidSwipe
library;

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import '../hvac_liquid_swipe.dart';
import '../../theme/colors.dart';

class LiquidSwipeExample extends StatefulWidget {
  const LiquidSwipeExample({super.key});

  @override
  State<LiquidSwipeExample> createState() => _LiquidSwipeExampleState();
}

class _LiquidSwipeExampleState extends State<LiquidSwipeExample> {
  final LiquidController _controller = LiquidController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HvacLiquidSwipe(
            pages: [
              // Dashboard page
              HvacLiquidPage(
                title: 'Dashboard',
                subtitle: 'Monitor all your HVAC devices',
                icon: Icons.dashboard,
                backgroundColor: HvacColors.backgroundDark,
                customContent: _buildDashboardStats(),
              ),

              // Devices page
              HvacLiquidPage(
                title: 'Devices',
                subtitle: 'Control your HVAC systems',
                icon: Icons.devices,
                backgroundColor: const Color(0xFF1A1D2E),
                customContent: _buildDeviceList(),
              ),

              // Analytics page
              HvacLiquidPage(
                title: 'Analytics',
                subtitle: 'View energy consumption',
                icon: Icons.analytics,
                backgroundColor: const Color(0xFF16213E),
              ),

              // Settings page
              HvacLiquidPage(
                title: 'Settings',
                subtitle: 'Configure your preferences',
                icon: Icons.settings,
                backgroundColor: const Color(0xFF0F3460),
              ),
            ],
            controller: _controller,
            onPageChangeCallback: (index) {
              setState(() => _currentPage = index);
            },
          ),

          // Page indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? HvacColors.primaryOrange
                        : HvacColors.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard('24°C', 'Temperature'),
        _buildStatCard('65%', 'Humidity'),
        _buildStatCard('45', 'AQI'),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: HvacColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceList() {
    return Column(
      children: [
        _buildDeviceItem('Living Room AC', 'Online'),
        const SizedBox(height: 12),
        _buildDeviceItem('Bedroom Heater', 'Online'),
        const SizedBox(height: 12),
        _buildDeviceItem('Kitchen Fan', 'Offline'),
      ],
    );
  }

  Widget _buildDeviceItem(String name, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.device_thermostat, color: HvacColors.primaryOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 14,
              color: status == 'Online'
                  ? HvacColors.success
                  : HvacColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
