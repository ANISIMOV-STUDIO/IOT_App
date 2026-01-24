/// Main Screen - Navigation wrapper for all tabs
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hvac_control/core/theme/app_animations.dart';
import 'package:hvac_control/core/theme/breakpoints.dart';
import 'package:hvac_control/generated/l10n/app_localizations.dart';
import 'package:hvac_control/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:hvac_control/presentation/bloc/climate/climate_bloc.dart';
import 'package:hvac_control/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:hvac_control/presentation/bloc/devices/devices_bloc.dart';
import 'package:hvac_control/presentation/screens/analytics/analytics_screen.dart';
import 'package:hvac_control/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:hvac_control/presentation/screens/devices/devices_screen.dart';
import 'package:hvac_control/presentation/screens/profile/profile_screen.dart';
import 'package:hvac_control/presentation/widgets/breez/navigation_bar.dart';

/// Идентификаторы вкладок для корректного маппинга mobile/desktop
enum _TabId { home, analytics, devices, profile }

/// Main screen with bottom navigation
class MainScreen extends StatefulWidget {

  const MainScreen({super.key, this.initialTab});
  final int? initialTab;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  _TabId _currentTab = _TabId.home;
  bool _blocsStarted = false;
  PageController? _pageController;
  List<_TabId>? _lastTabs;

  @override
  void initState() {
    super.initState();
    // Конвертируем initialTab в _TabId
    if (widget.initialTab != null && widget.initialTab! < _TabId.values.length) {
      _currentTab = _TabId.values[widget.initialTab!];
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  /// Получает или создаёт PageController для текущего набора вкладок
  PageController _getPageController(List<_TabId> tabs, int selectedIndex) {
    // Если tabs изменились (mobile <-> desktop), пересоздаём контроллер
    if (_lastTabs == null || !_listEquals(_lastTabs!, tabs)) {
      _pageController?.dispose();
      _pageController = PageController(initialPage: selectedIndex);
      _lastTabs = tabs;
    }
    return _pageController!;
  }

  /// Сравнение списков
  bool _listEquals(List<_TabId> a, List<_TabId> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
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
      // NotificationsBloc — загружается через DashboardBlocListeners при выборе устройства
      // AnalyticsBloc — статистика и графики
      context.read<AnalyticsBloc>().add(const AnalyticsSubscriptionRequested());
      // ConnectivityBloc — мониторинг соединения
      context.read<ConnectivityBloc>().add(const ConnectivitySubscriptionRequested());
    }
  }

  // Маппинг вкладок на экраны
  static const _tabScreens = <_TabId, Widget>{
    _TabId.home: DashboardScreen(),
    _TabId.analytics: AnalyticsScreen(),
    _TabId.devices: DevicesScreen(),
    _TabId.profile: ProfileScreen(),
  };

  // Вкладки для mobile (все 4)
  static const _mobileTabs = [
    _TabId.home,
    _TabId.analytics,
    _TabId.devices,
    _TabId.profile,
  ];

  // Вкладки для desktop (без Analytics - уже на главной)
  static const _desktopTabs = [
    _TabId.home,
    _TabId.devices,
    _TabId.profile,
  ];

  List<NavigationItem> _getNavigationItems(
    AppLocalizations l10n,
    List<_TabId> tabs,
  ) => tabs.map((tab) => switch (tab) {
      _TabId.home => NavigationItem(
          icon: Icons.home_outlined,
          label: l10n.home,
        ),
      _TabId.analytics => NavigationItem(
          icon: Icons.bar_chart,
          label: l10n.analytics,
        ),
      _TabId.devices => NavigationItem(
          icon: Icons.devices,
          label: l10n.devices,
        ),
      _TabId.profile => NavigationItem(
          icon: Icons.person_outline,
          label: l10n.profile,
        ),
    }).toList();

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final tabs = isDesktop ? _desktopTabs : _mobileTabs;

    // Если текущая вкладка недоступна (Analytics на desktop), переключаемся на home
    final effectiveTab = tabs.contains(_currentTab) ? _currentTab : _TabId.home;
    final selectedIndex = tabs.indexOf(effectiveTab);

    // Синхронизируем _currentTab если он изменился из-за смены режима
    if (_currentTab != effectiveTab) {
      // Используем addPostFrameCallback чтобы избежать setState во время build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentTab = effectiveTab;
          });
        }
      });
    }

    final pageController = _getPageController(tabs, selectedIndex);

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _currentTab = tabs[index];
          });
        },
        // Оборачиваем каждую страницу в _KeepAlivePage для сохранения состояния
        children: tabs.map((tab) => _KeepAlivePage(child: _tabScreens[tab]!)).toList(),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return BreezNavigationBar(
            items: _getNavigationItems(l10n, tabs),
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              pageController.animateToPage(
                index,
                duration: AppDurations.medium,
                curve: AppCurves.emphasize,
              );
            },
          );
        },
      ),
    );
  }
}

// =============================================================================
// KEEP ALIVE WRAPPER
// =============================================================================

/// Обёртка для сохранения состояния страницы при свайпе в PageView
class _KeepAlivePage extends StatefulWidget {
  const _KeepAlivePage({required this.child});

  final Widget child;

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Обязательный вызов для AutomaticKeepAliveClientMixin
    return widget.child;
  }
}
