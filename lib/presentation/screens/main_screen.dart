/// Main Screen - Navigation wrapper for all tabs
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generated/l10n/app_localizations.dart';
import '../bloc/devices/devices_bloc.dart';
import '../bloc/climate/climate_bloc.dart';
import '../bloc/notifications/notifications_bloc.dart';
import '../bloc/analytics/analytics_bloc.dart';
import '../bloc/connectivity/connectivity_bloc.dart';

import '../widgets/breez/navigation_bar.dart';
import 'dashboard/dashboard_screen.dart';
import 'analytics/analytics_screen.dart';
import 'devices/devices_screen.dart';
import 'profile/profile_screen.dart';

/// Main screen with bottom navigation
class MainScreen extends StatefulWidget {
  final int? initialTab;

  const MainScreen({super.key, this.initialTab});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  bool _blocsStarted = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab ?? 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Загружаем данные при первом входе на экран
    // didChangeDependencies вызывается после initState и имеет доступ к context
    if (!_blocsStarted) {
      _blocsStarted = true;
      // DevicesBloc — загрузка списка устройств
      context.read<DevicesBloc>().add(const DevicesSubscriptionRequested());
      // ClimateBloc — загрузка состояния климата
      context.read<ClimateBloc>().add(const ClimateSubscriptionRequested());
      // NotificationsBloc — загрузка уведомлений
      context.read<NotificationsBloc>().add(const NotificationsSubscriptionRequested());
      // AnalyticsBloc — статистика и графики
      context.read<AnalyticsBloc>().add(const AnalyticsSubscriptionRequested());
      // ConnectivityBloc — мониторинг соединения
      context.read<ConnectivityBloc>().add(const ConnectivitySubscriptionRequested());
    }
  }

  static const _screens = [
    DashboardScreen(),
    AnalyticsScreen(),
    DevicesScreen(),
    ProfileScreen(),
  ];

  List<NavigationItem> _getNavigationItems(AppLocalizations l10n) => [
    NavigationItem(
      icon: Icons.home_outlined,
      label: l10n.home,
    ),
    NavigationItem(
      icon: Icons.bar_chart,
      label: l10n.analytics,
    ),
    NavigationItem(
      icon: Icons.devices,
      label: l10n.devices,
    ),
    NavigationItem(
      icon: Icons.person_outline,
      label: l10n.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // BlocListener для синхронизации DevicesBloc → ClimateBloc
    // Когда выбрано устройство, обновляем ClimateBloc
    return BlocListener<DevicesBloc, DevicesState>(
      listenWhen: (previous, current) =>
          previous.selectedDeviceId != current.selectedDeviceId,
      listener: (context, state) {
        if (state.selectedDeviceId != null) {
          context.read<ClimateBloc>().add(
                ClimateDeviceChanged(state.selectedDeviceId!),
              );
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return BreezNavigationBar(
              items: _getNavigationItems(l10n),
              selectedIndex: _currentIndex,
              onItemSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
