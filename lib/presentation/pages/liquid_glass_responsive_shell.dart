/// Responsive Shell - iOS 26 Liquid Glass Design
///
/// Modern navigation with glass effect tab bar
library;

import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/theme/liquid_glass_theme.dart';
import '../../generated/l10n/app_localizations.dart';
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
  late AnimationController _tabAnimationController;
  late Animation<double> _tabAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Stronger tab animation
    _tabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _tabAnimation = CurvedAnimation(
      parent: _tabAnimationController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabAnimationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _tabAnimationController.forward(from: 0);
  }

  void _onTabTapped(int index) {
    if (_selectedIndex == index) return;

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );

    _tabAnimationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return Scaffold(
      extendBody: true,
      body: isWeb
          ? Row(
              children: [
                // Web side navigation
                _WebSideNav(
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
                // Content with max width
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        physics: const BouncingScrollPhysics(),
                        children: const [
                          HomeScreen(),
                          SettingsScreen(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const BouncingScrollPhysics(),
              children: const [
                HomeScreen(),
                SettingsScreen(),
              ],
            ),
      bottomNavigationBar: isWeb
          ? null
          : AnimatedBuilder(
              animation: _tabAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 - (_tabAnimation.value * 0.03),
                  child: child,
                );
              },
              child: _LiquidGlassTabBar(
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
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),  // Reduced blur for performance
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.08 : 0.05),
                  (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.05 : 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.12),
                width: 0.5,
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
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
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

/// Web Side Navigation
class _WebSideNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<_TabItem> items;

  const _WebSideNav({
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 280,
      margin: const EdgeInsets.all(20),
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
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.08 : 0.05),
                  (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.05 : 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.12),
                width: 0.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Logo/Title
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              LiquidGlassTheme.glassBlue,
                              LiquidGlassTheme.glassTeal,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.air,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'HVAC Control',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Navigation items
                ...List.generate(
                  items.length,
                  (index) => _WebNavItem(
                    item: items[index],
                    isSelected: selectedIndex == index,
                    onTap: () => onTap(index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Web Navigation Item
class _WebNavItem extends StatefulWidget {
  final _TabItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _WebNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_WebNavItem> createState() => _WebNavItemState();
}

class _WebNavItemState extends State<_WebNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: widget.isSelected
                  ? const LinearGradient(
                      colors: [
                        LiquidGlassTheme.glassBlue,
                        LiquidGlassTheme.glassTeal,
                      ],
                    )
                  : null,
              color: _isHovered && !widget.isSelected
                  ? Theme.of(context).iconTheme.color?.withValues(alpha: 0.05)
                  : null,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  widget.isSelected ? widget.item.selectedIcon : widget.item.icon,
                  size: 24,
                  color: widget.isSelected
                      ? Colors.white
                      : Theme.of(context).iconTheme.color,
                ),
                const SizedBox(width: 16),
                Text(
                  widget.item.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: widget.isSelected
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
