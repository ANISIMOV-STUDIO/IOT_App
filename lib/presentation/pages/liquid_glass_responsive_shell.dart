/// Responsive Shell - iOS 26 Liquid Glass Design
///
/// Modern navigation with glass effect tab bar
library;

import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/theme/liquid_glass_theme.dart';
import '../../generated/l10n/app_localizations.dart';
import '../widgets/liquid_glass_container.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class LiquidGlassResponsiveShell extends StatefulWidget {
  const LiquidGlassResponsiveShell({super.key});

  @override
  State<LiquidGlassResponsiveShell> createState() => _LiquidGlassResponsiveShellState();
}

class _LiquidGlassResponsiveShellState extends State<LiquidGlassResponsiveShell>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: const [
          HomeScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _LiquidGlassTabBar(
        selectedIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: [
          _TabItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
            label: l10n.home,
          ),
          _TabItem(
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings_rounded,
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _TabItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class _LiquidGlassTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<_TabItem> items;

  const _LiquidGlassTabBar({
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.15 : 0.05),
                  (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.1 : 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                items.length,
                (index) => _TabBarItem(
                  item: items[index],
                  isSelected: selectedIndex == index,
                  onTap: () => onTap(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabBarItem extends StatefulWidget {
  final _TabItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_TabBarItem> createState() => _TabBarItemState();
}

class _TabBarItemState extends State<_TabBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  height: double.infinity,
                  decoration: widget.isSelected
                      ? BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              LiquidGlassTheme.glassBlue,
                              LiquidGlassTheme.glassTeal,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        )
                      : null,
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.isSelected ? widget.item.selectedIcon : widget.item.icon,
                        size: 26,
                        color: widget.isSelected
                            ? Colors.white
                            : Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: widget.isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
