/// Main Screen - Navigation wrapper for all tabs
library;

import 'package:flutter/material.dart';

import '../widgets/breez/navigation_bar.dart';
import 'dashboard/dashboard_screen.dart';
import 'analytics/analytics_screen.dart';
import 'devices/devices_screen.dart';
import 'profile/profile_screen.dart';

/// Main screen with bottom navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static const _screens = [
    DashboardScreen(),
    AnalyticsScreen(),
    DevicesScreen(),
    ProfileScreen(),
  ];

  static const _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      label: 'Главная',
    ),
    NavigationItem(
      icon: Icons.bar_chart,
      label: 'Аналитика',
    ),
    NavigationItem(
      icon: Icons.devices,
      label: 'Устройства',
    ),
    NavigationItem(
      icon: Icons.person_outline,
      label: 'Профиль',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BreezNavigationBar(
        items: _navigationItems,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
