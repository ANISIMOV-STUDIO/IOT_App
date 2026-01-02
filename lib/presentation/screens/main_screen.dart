/// Main Screen - Navigation wrapper for all tabs
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_router.dart';
import '../bloc/dashboard/dashboard_bloc.dart';

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
  bool _dashboardStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Загружаем данные dashboard при первом входе на экран
    // didChangeDependencies вызывается после initState и имеет доступ к context
    if (!_dashboardStarted) {
      _dashboardStarted = true;
      context.read<DashboardBloc>().add(const DashboardStarted());
    }
  }

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
      bottomNavigationBar: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final unreadCount = state.unreadNotificationCount;
          return BreezNavigationBar(
            items: _navigationItems,
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            onNotificationsTap: () => context.push(AppRoutes.notifications),
            notificationsBadge: unreadCount > 0 ? '$unreadCount' : null,
          );
        },
      ),
    );
  }
}
