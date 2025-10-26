/// Responsive Shell
///
/// Adaptive navigation with modern design and animations
library;

import 'package:flutter/material.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/theme/app_theme.dart';
import '../../core/di/injection_container.dart';
import '../../core/services/language_service.dart';
import '../../generated/l10n/app_localizations.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  List<_NavigationItem> _getDestinations(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      _NavigationItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        label: l10n.home,
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
      ),
      _NavigationItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
        label: l10n.settings,
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (_selectedIndex == index) return;

    _fadeController.reverse().then((_) {
      setState(() {
        _selectedIndex = index;
      });
      _fadeController.forward();
    });
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: sl<LanguageService>(),
      builder: (context, child) {
        final useBottomNav = ResponsiveHelper.shouldUseBottomNav(context);
        final isDark = Theme.of(context).brightness == Brightness.dark;

        if (useBottomNav) {
          // Mobile layout with modern BottomNavigationBar
          return Scaffold(
            body: FadeTransition(
              opacity: _fadeAnimation,
              child: _getSelectedPage(),
            ),
            bottomNavigationBar: _buildModernBottomNav(isDark),
          );
        } else {
          // Desktop layout with modern NavigationRail
          return Scaffold(
            body: Row(
              children: [
                _buildModernNavigationRail(isDark),
                Container(
                  width: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        (isDark ? AppTheme.darkBorder : AppTheme.lightBorder)
                            .withOpacity(0.1),
                        (isDark ? AppTheme.darkBorder : AppTheme.lightBorder)
                            .withOpacity(0.3),
                        (isDark ? AppTheme.darkBorder : AppTheme.lightBorder)
                            .withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _getSelectedPage(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildModernBottomNav(bool isDark) {
    final destinations = _getDestinations(context);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: destinations.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = _selectedIndex == index;

              return _ModernNavButton(
                item: item,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () => _onDestinationSelected(index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildModernNavigationRail(bool isDark) {
    final destinations = _getDestinations(context);
    return Container(
      width: 80,
      color: isDark ? AppTheme.darkSurface : Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Logo/Brand area
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.ac_unit_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 32),
          // Navigation items
          ...destinations.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = _selectedIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ModernRailButton(
                item: item,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () => _onDestinationSelected(index),
              ),
            );
          }),
          const Spacer(),
        ],
      ),
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final LinearGradient gradient;

  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.gradient,
  });
}

class _ModernNavButton extends StatefulWidget {
  final _NavigationItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _ModernNavButton({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_ModernNavButton> createState() => _ModernNavButtonState();
}

class _ModernNavButtonState extends State<_ModernNavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isSelected ? 20 : 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            gradient: widget.isSelected ? widget.item.gradient : null,
            color: widget.isSelected
                ? null
                : (widget.isDark
                    ? AppTheme.darkSurface
                    : AppTheme.lightSurface),
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: widget.item.gradient.colors[0].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isSelected ? widget.item.selectedIcon : widget.item.icon,
                color: widget.isSelected
                    ? Colors.white
                    : (widget.isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary),
                size: 24,
              ),
              if (widget.isSelected) ...[
                const SizedBox(width: 8),
                Text(
                  widget.item.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernRailButton extends StatefulWidget {
  final _NavigationItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _ModernRailButton({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_ModernRailButton> createState() => _ModernRailButtonState();
}

class _ModernRailButtonState extends State<_ModernRailButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: widget.isSelected ? widget.item.gradient : null,
            color: widget.isSelected
                ? null
                : (widget.isDark
                    ? AppTheme.darkSurface.withOpacity(0.5)
                    : AppTheme.lightSurface),
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: widget.item.gradient.colors[0].withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              widget.isSelected ? widget.item.selectedIcon : widget.item.icon,
              color: widget.isSelected
                  ? Colors.white
                  : (widget.isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
