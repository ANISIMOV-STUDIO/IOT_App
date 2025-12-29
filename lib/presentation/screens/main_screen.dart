/// Main Screen - Navigation wrapper for all tabs
library;

import 'package:flutter/material.dart';

import '../widgets/breez/navigation_bar.dart';
import '../widgets/breez/sidebar.dart';
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
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isDesktop = width > 900;
    final isLandscape = width > height;

    // Desktop landscape: sidebar + IndexedStack (no bottom bar)
    // Desktop portrait / Mobile / Tablet: IndexedStack + bottom bar
    final showSidebar = isDesktop && isLandscape;

    return Scaffold(
      body: showSidebar
          ? Row(
              children: [
                // Sidebar for desktop landscape
                Sidebar(
                  selectedIndex: _currentIndex,
                  onItemSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  onLogoutTap: () {
                    // TODO: Implement logout
                  },
                ),
                // Main content
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _screens,
                  ),
                ),
              ],
            )
          : IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
      bottomNavigationBar: showSidebar
          ? null
          : BreezNavigationBar(
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
