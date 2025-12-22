import 'dart:ui';
import 'package:flutter/material.dart';
import 'glass_sidebar.dart';
import 'glass_bottom_nav.dart';
import '../../theme/glass_colors.dart';
import '../../theme/glass_theme.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Layout mode for the dashboard shell
enum DashboardLayoutMode {
  mobile,
  tablet,
  desktop,
}

/// Responsive Dashboard Shell with glassmorphism
class ResponsiveDashboardShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<GlassNavItem> navItems;
  final List<Widget> pages;
  final Widget Function(BuildContext)? rightPanelBuilder;
  final Widget Function(BuildContext)? mobileHeaderBuilder;
  final Widget Function(BuildContext)? footerBuilder;
  final List<Widget>? headerActions;
  final String? userName;
  final String? userAvatarUrl;
  final bool sidebarCollapsed;
  final VoidCallback? onToggleSidebar;
  final Widget? logoWidget;
  final String appName;

  static const double maxWidth = 1920.0;
  static const double rightPanelWidth = 360.0;

  const ResponsiveDashboardShell({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.navItems,
    required this.pages,
    this.rightPanelBuilder,
    this.mobileHeaderBuilder,
    this.footerBuilder,
    this.headerActions,
    this.userName,
    this.userAvatarUrl,
    this.sidebarCollapsed = false,
    this.onToggleSidebar,
    this.logoWidget,
    this.appName = 'BREEZ',
  });

  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;

  static DashboardLayoutMode getLayoutMode(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return DashboardLayoutMode.mobile;
    } else if (width < tabletBreakpoint) {
      return DashboardLayoutMode.tablet;
    }
    return DashboardLayoutMode.desktop;
  }

  static bool isMobile(BuildContext context) =>
      getLayoutMode(context) == DashboardLayoutMode.mobile;

  static bool isTablet(BuildContext context) =>
      getLayoutMode(context) == DashboardLayoutMode.tablet;

  static bool isDesktop(BuildContext context) =>
      getLayoutMode(context) == DashboardLayoutMode.desktop;

  @override
  Widget build(BuildContext context) {
    final layoutMode = getLayoutMode(context);

    switch (layoutMode) {
      case DashboardLayoutMode.mobile:
        return _buildMobileLayout(context);
      case DashboardLayoutMode.tablet:
        return _buildTabletLayout(context);
      case DashboardLayoutMode.desktop:
        return _buildDesktopLayout(context);
    }
  }

  Widget _buildMobileLayout(BuildContext context) {
    final theme = GlassTheme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.colors.backgroundGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              if (mobileHeaderBuilder != null) mobileHeaderBuilder!(context),
              Expanded(
                child: IndexedStack(
                  index: selectedIndex.clamp(0, pages.length - 1),
                  children: pages,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        selectedIndex: selectedIndex,
        onItemSelected: onIndexChanged,
        items: navItems,
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    final theme = GlassTheme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.colors.backgroundGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              if (mobileHeaderBuilder != null) mobileHeaderBuilder!(context),
              Expanded(
                child: IndexedStack(
                  index: selectedIndex.clamp(0, pages.length - 1),
                  children: pages,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        selectedIndex: selectedIndex,
        onItemSelected: onIndexChanged,
        items: navItems,
      ),
      floatingActionButton: rightPanelBuilder != null
          ? _GlassClimateControlFAB(
              onPressed: () => _showClimateBottomSheet(context),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final theme = GlassTheme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeDesktop = screenWidth >= 1440;

    const headerHeight = 56.0 + NeumorphicSpacing.sm;
    final panelWidth = isLargeDesktop ? rightPanelWidth : rightPanelWidth * 0.85;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.colors.backgroundGradient,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.all(NeumorphicSpacing.md),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Sidebar
                            GlassSidebar(
                              selectedIndex: selectedIndex,
                              onItemSelected: onIndexChanged,
                              items: navItems,
                              userName: userName,
                              userAvatarUrl: userAvatarUrl,
                              isCollapsed: sidebarCollapsed,
                              onToggleSidebar: onToggleSidebar,
                              logoWidget: logoWidget,
                              appName: appName,
                            ),
                            // Main content
                            Expanded(
                              child: IndexedStack(
                                index: selectedIndex.clamp(0, pages.length - 1),
                                children: pages,
                              ),
                            ),
                            // Right panel
                            if (rightPanelBuilder != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: NeumorphicSpacing.md,
                                  top: headerHeight,
                                ),
                                child: SizedBox(
                                  width: panelWidth,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: theme.isDark
                                                ? [
                                                    const Color(0x1AFFFFFF),
                                                    const Color(0x0DFFFFFF),
                                                  ]
                                                : [
                                                    const Color(0xB3FFFFFF),
                                                    const Color(0x80FFFFFF),
                                                  ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: theme.isDark
                                                ? const Color(0x33FFFFFF)
                                                : const Color(0x66FFFFFF),
                                            width: 1,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(
                                            NeumorphicSpacing.md),
                                        child: rightPanelBuilder!(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        // Header actions
                        if (headerActions != null && headerActions!.isNotEmpty)
                          Positioned(
                            top: 0,
                            right: rightPanelBuilder != null
                                ? panelWidth / 2 - 60
                                : 0,
                            child: SizedBox(
                              height: 56,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (int i = 0; i < headerActions!.length; i++) ...[
                                    if (i > 0)
                                      const SizedBox(width: NeumorphicSpacing.sm),
                                    headerActions![i],
                                  ],
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Footer
                  if (footerBuilder != null)
                    Padding(
                      padding: const EdgeInsets.only(top: NeumorphicSpacing.md),
                      child: footerBuilder!(context),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showClimateBottomSheet(BuildContext context) {
    if (rightPanelBuilder == null) return;

    final theme = GlassTheme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: theme.isDark
                    ? [
                        const Color(0xE61E293B),
                        const Color(0xFF1E293B),
                      ]
                    : [
                        const Color(0xF0FFFFFF),
                        const Color(0xFFFFFFFF),
                      ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(
                color: theme.isDark
                    ? const Color(0x33FFFFFF)
                    : const Color(0x1A000000),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colors.textTertiary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(NeumorphicSpacing.md),
                    child: rightPanelBuilder!(context),
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

class _GlassClimateControlFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const _GlassClimateControlFAB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: GlassColors.accentPrimary,
      foregroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.thermostat),
    );
  }
}

/// Glass Main Content wrapper
class GlassMainContent extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;

  const GlassMainContent({
    super.key,
    this.title,
    this.actions,
    required this.child,
    this.padding,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);
    final contentPadding = padding ??
        const EdgeInsets.symmetric(horizontal: NeumorphicSpacing.lg);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        SizedBox(
          height: 56,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: NeumorphicSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (title != null)
                  Text(title!, style: theme.typography.headlineLarge),
                if (actions != null) Row(children: actions!),
              ],
            ),
          ),
        ),
        const SizedBox(height: NeumorphicSpacing.sm),
        Expanded(
          child: scrollable
              ? SingleChildScrollView(
                  padding: contentPadding,
                  child: child,
                )
              : Padding(
                  padding: contentPadding,
                  child: child,
                ),
        ),
      ],
    );
  }
}

// Backwards compatibility alias
typedef NeumorphicMainContent = GlassMainContent;

/// Glass Right Panel
class GlassRightPanel extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const GlassRightPanel({
    super.key,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding ?? const EdgeInsets.all(NeumorphicSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

// Backwards compatibility alias
typedef NeumorphicRightPanel = GlassRightPanel;
