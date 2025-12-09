import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_ui_kit/smart_ui_kit.dart';
import '../../core/navigation/app_router.dart';

class ZilonShell extends StatefulWidget {
  final Widget child;

  const ZilonShell({
    super.key,
    required this.child,
  });

  @override
  State<ZilonShell> createState() => _ZilonShellState();
}

class _ZilonShellState extends State<ZilonShell> {
  @override
  Widget build(BuildContext context) {
    // Responsive Breakpoints
    final width = MediaQuery.of(context).size.width;
    final showSidebar = width >= 700; // Lowered from 900 to support Tablets/Split view
    
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          // Persistent Sidebar (Desktop & Tablet)
          if (showSidebar)
            ZilonSidebar(
              selectedIndex: _calculateSelectedIndex(context),
              onItemSelected: (index) => _onItemTapped(index, context),
            ),
          
          // Main Content Area
          Expanded(
            child: widget.child,
          ),
        ],
      ),
      // Bottom Nav for Mobile
      bottomNavigationBar: !showSidebar
          ? BottomNavigationBar(
              currentIndex: _calculateSelectedIndex(context),
              onTap: (index) => _onItemTapped(index, context),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: theme.colorScheme.primary,
              unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.5),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.tune_rounded), label: 'Controls'),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Schedule'),
                BottomNavigationBarItem(icon: Icon(Icons.show_chart_rounded), label: 'Stats'),
                BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
              ],
            )
          : null,
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.controls)) return 1;
    if (location.startsWith(AppRoutes.schedule)) return 2;
    if (location.startsWith(AppRoutes.statistics)) return 3;
    if (location.startsWith(AppRoutes.settings)) return 4;
    // Check home last or explicit match
    if (location == AppRoutes.home) return 0;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.controls);
        break;
      case 2:
        context.go(AppRoutes.schedule);
        break;
      case 3:
        context.go(AppRoutes.statistics);
        break;
      case 4:
        context.go(AppRoutes.settings);
        break;
    }
  }
}
