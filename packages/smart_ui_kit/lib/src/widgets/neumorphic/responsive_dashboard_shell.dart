import 'package:flutter/material.dart';
import 'neumorphic_theme_wrapper.dart';
import 'neumorphic_sidebar.dart';
import 'neumorphic_bottom_nav.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Layout mode for the dashboard shell
enum DashboardLayoutMode {
  mobile,      // <600px: Bottom nav + full screen content
  tablet,      // 600-1024px: Bottom nav + content (+ bottom sheet for controls)
  desktop,     // >1024px: Sidebar + content + right panel
}

/// Responsive Dashboard Shell - Automatically adapts layout based on screen size
///
/// - Mobile: Bottom navigation with compact content
/// - Tablet Portrait: Bottom navigation with bottom sheet for climate controls
/// - Desktop: Sidebar + Content + Right Panel
class ResponsiveDashboardShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NeumorphicNavItem> navItems;
  final List<Widget> pages;
  final Widget Function(BuildContext)? rightPanelBuilder;
  final Widget Function(BuildContext)? mobileHeaderBuilder;
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
    this.userName,
    this.userAvatarUrl,
    this.sidebarCollapsed = false,
    this.onToggleSidebar,
    this.logoWidget,
    this.appName = 'BREEZ',
  });

  /// Breakpoint constants
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;

  /// Get current layout mode based on screen width
  static DashboardLayoutMode getLayoutMode(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return DashboardLayoutMode.mobile;
    } else if (width < tabletBreakpoint) {
      return DashboardLayoutMode.tablet;
    }
    return DashboardLayoutMode.desktop;
  }

  /// Check if running in mobile layout
  static bool isMobile(BuildContext context) =>
      getLayoutMode(context) == DashboardLayoutMode.mobile;

  /// Check if running in tablet layout
  static bool isTablet(BuildContext context) =>
      getLayoutMode(context) == DashboardLayoutMode.tablet;

  /// Check if running in desktop layout
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

  /// Mobile layout: Bottom nav + full screen content
  Widget _buildMobileLayout(BuildContext context) {
    final theme = NeumorphicTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colors.surface,
      body: SafeArea(
        bottom: false, // Bottom nav handles its own safe area
        child: Column(
          children: [
            // Optional mobile header
            if (mobileHeaderBuilder != null)
              mobileHeaderBuilder!(context),
            // Content
            Expanded(
              child: IndexedStack(
                index: selectedIndex.clamp(0, pages.length - 1),
                children: pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NeumorphicBottomNav(
        selectedIndex: selectedIndex,
        onItemSelected: onIndexChanged,
        items: navItems,
      ),
    );
  }

  /// Tablet layout: Bottom nav + content with optional floating action for controls
  Widget _buildTabletLayout(BuildContext context) {
    final theme = NeumorphicTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (mobileHeaderBuilder != null)
              mobileHeaderBuilder!(context),
            Expanded(
              child: IndexedStack(
                index: selectedIndex.clamp(0, pages.length - 1),
                children: pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NeumorphicBottomNav(
        selectedIndex: selectedIndex,
        onItemSelected: onIndexChanged,
        items: navItems,
      ),
      // FAB for climate controls bottom sheet
      floatingActionButton: rightPanelBuilder != null
          ? _ClimateControlFAB(
              onPressed: () => _showClimateBottomSheet(context),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Desktop layout: Sidebar + Content + Right Panel
  Widget _buildDesktopLayout(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeDesktop = screenWidth >= 1440;

    return Scaffold(
      backgroundColor: theme.colors.surface,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxWidth),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar
              NeumorphicSidebar(
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
                    top: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Container(
                    width: isLargeDesktop ? rightPanelWidth : rightPanelWidth * 0.85,
                    decoration: BoxDecoration(
                      color: theme.colors.cardSurface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colors.shadowDark.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(-5, 0),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: rightPanelBuilder!(context),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClimateBottomSheet(BuildContext context) {
    if (rightPanelBuilder == null) return;

    final theme = NeumorphicTheme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: theme.colors.cardSurface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
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
    );
  }
}

/// Floating action button for climate controls
class _ClimateControlFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const _ClimateControlFAB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: theme.colors.cardSurface,
      foregroundColor: theme.colors.textPrimary,
      elevation: 4,
      child: const Icon(Icons.thermostat),
    );
  }
}

/// Main content area with header and scrollable content
class NeumorphicMainContent extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const NeumorphicMainContent({
    super.key,
    this.title,
    this.actions,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              NeumorphicSpacing.lg,
              NeumorphicSpacing.lg,
              NeumorphicSpacing.lg,
              NeumorphicSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title!, style: theme.typography.headlineLarge),
                if (actions != null) Row(children: actions!),
              ],
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: NeumorphicSpacing.lg,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

/// Right panel for climate controls
class NeumorphicRightPanel extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const NeumorphicRightPanel({
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
