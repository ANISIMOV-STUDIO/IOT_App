import 'dart:ui';
import 'package:flutter/material.dart';
import 'glass_sidebar.dart';
import 'glass_bottom_nav.dart';
import '../../theme/glass_colors.dart';
import '../../theme/glass_theme.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Material 3 Window Size Classes
/// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
class WindowSizeClass {
  /// Compact: 0-599dp (phones in portrait)
  static const double compact = 600;

  /// Medium: 600-839dp (tablets in portrait, foldables)
  static const double medium = 840;

  /// Expanded: 840-1199dp (tablets in landscape, small desktops)
  static const double expanded = 1200;

  /// Large: 1200-1599dp (desktop)
  static const double large = 1600;

  /// Extra-large: 1600+dp (large desktop, ultrawide)
  static const double extraLarge = 1600;
}

/// Layout mode for the dashboard shell
enum DashboardLayoutMode {
  /// Bottom navigation, single column
  compact,

  /// Bottom navigation, multi-column grid
  medium,

  /// Sidebar + content
  expanded,

  /// Sidebar + content + right panel inline
  large,
}

/// Responsive Dashboard Shell following Material 3 guidelines
/// Adapts layout based on available width, not device type
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

  /// Maximum width for the entire dashboard content.
  /// Beyond this width, content will be centered.
  /// Set to null for no limit.
  final double? maxContentWidth;

  /// Width needed to show right panel inline (sidebar + content + panel)
  static const double rightPanelInlineThreshold = 1400.0;

  /// Sidebar width when expanded
  static const double sidebarExpandedWidth = 220.0;

  /// Sidebar width when collapsed
  static const double sidebarCollapsedWidth = 72.0;

  /// Right panel width
  static const double rightPanelWidth = 340.0;

  /// Default max content width (common for dashboards)
  static const double defaultMaxContentWidth = 1600.0;

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
    this.maxContentWidth = defaultMaxContentWidth,
  });

  /// Get layout mode based on available width
  static DashboardLayoutMode getLayoutMode(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return getLayoutModeForWidth(width);
  }

  /// Get layout mode for a specific width
  static DashboardLayoutMode getLayoutModeForWidth(double width) {
    if (width < WindowSizeClass.compact) {
      return DashboardLayoutMode.compact;
    } else if (width < WindowSizeClass.medium) {
      return DashboardLayoutMode.medium;
    } else if (width < WindowSizeClass.expanded) {
      return DashboardLayoutMode.expanded;
    } else {
      return DashboardLayoutMode.large;
    }
  }

  static bool isCompact(BuildContext context) =>
      getLayoutMode(context) == DashboardLayoutMode.compact;

  static bool isMedium(BuildContext context) =>
      getLayoutMode(context) == DashboardLayoutMode.medium;

  static bool isExpanded(BuildContext context) =>
      getLayoutMode(context) == DashboardLayoutMode.expanded;

  static bool isLarge(BuildContext context) =>
      getLayoutMode(context) == DashboardLayoutMode.large;

  /// Returns true if layout uses bottom navigation
  static bool usesBottomNav(BuildContext context) {
    final mode = getLayoutMode(context);
    return mode == DashboardLayoutMode.compact ||
        mode == DashboardLayoutMode.medium;
  }

  /// Returns true if layout shows sidebar
  static bool showsSidebar(BuildContext context) {
    final mode = getLayoutMode(context);
    return mode == DashboardLayoutMode.expanded ||
        mode == DashboardLayoutMode.large;
  }

  // Legacy compatibility
  static bool isMobile(BuildContext context) => isCompact(context);
  static bool isTablet(BuildContext context) => isMedium(context);
  static bool isDesktop(BuildContext context) =>
      isExpanded(context) || isLarge(context);

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder for responsive layout based on actual available space
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final layoutMode = getLayoutModeForWidth(width);

        switch (layoutMode) {
          case DashboardLayoutMode.compact:
          case DashboardLayoutMode.medium:
            return _buildCompactMediumLayout(context, layoutMode);
          case DashboardLayoutMode.expanded:
            return _buildExpandedLayout(context, constraints);
          case DashboardLayoutMode.large:
            return _buildLargeLayout(context, constraints);
        }
      },
    );
  }

  /// Compact/Medium: Bottom navigation + full-width content
  Widget _buildCompactMediumLayout(
      BuildContext context, DashboardLayoutMode mode) {
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

  /// Expanded: Sidebar + content, right panel as FAB/bottom sheet
  Widget _buildExpandedLayout(
      BuildContext context, BoxConstraints constraints) {
    final theme = GlassTheme.of(context);
    final showRightPanelInline =
        constraints.maxWidth >= rightPanelInlineThreshold &&
            rightPanelBuilder != null;

    Widget content = Padding(
      padding: const EdgeInsets.all(NeumorphicSpacing.md),
      child: Column(
        children: [
          Expanded(
            child: Row(
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
                const SizedBox(width: NeumorphicSpacing.md),
                // Main content - takes remaining space
                Expanded(
                  child: Column(
                    children: [
                      // Header actions row
                      if (headerActions != null && headerActions!.isNotEmpty)
                        SizedBox(
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (int i = 0;
                                  i < headerActions!.length;
                                  i++) ...[
                                if (i > 0)
                                  const SizedBox(width: NeumorphicSpacing.sm),
                                headerActions![i],
                              ],
                            ],
                          ),
                        ),
                      // Page content
                      Expanded(
                        child: IndexedStack(
                          index: selectedIndex.clamp(0, pages.length - 1),
                          children: pages,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right panel inline (only on large enough screens)
                if (showRightPanelInline) ...[
                  const SizedBox(width: NeumorphicSpacing.md),
                  SizedBox(
                    width: rightPanelWidth,
                    child: _buildRightPanelContainer(context),
                  ),
                ],
              ],
            ),
          ),
          // Footer
          if (footerBuilder != null) ...[
            const SizedBox(height: NeumorphicSpacing.md),
            footerBuilder!(context),
          ],
        ],
      ),
    );

    // Apply max width constraint if set
    if (maxContentWidth != null) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth!),
          child: content,
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.colors.backgroundGradient,
        ),
        child: SafeArea(child: content),
      ),
      // FAB for right panel if not shown inline
      floatingActionButton: rightPanelBuilder != null && !showRightPanelInline
          ? _GlassClimateControlFAB(
              onPressed: () => _showClimateBottomSheet(context),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Large: Sidebar + content + right panel always inline
  Widget _buildLargeLayout(BuildContext context, BoxConstraints constraints) {
    final theme = GlassTheme.of(context);

    Widget content = Padding(
      padding: const EdgeInsets.all(NeumorphicSpacing.lg),
      child: Column(
        children: [
          Expanded(
            child: Row(
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
                const SizedBox(width: NeumorphicSpacing.lg),
                // Main content - takes remaining space
                Expanded(
                  child: Column(
                    children: [
                      // Header actions row
                      if (headerActions != null && headerActions!.isNotEmpty)
                        SizedBox(
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (int i = 0;
                                  i < headerActions!.length;
                                  i++) ...[
                                if (i > 0)
                                  const SizedBox(width: NeumorphicSpacing.sm),
                                headerActions![i],
                              ],
                            ],
                          ),
                        ),
                      // Page content
                      Expanded(
                        child: IndexedStack(
                          index: selectedIndex.clamp(0, pages.length - 1),
                          children: pages,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right panel always shown on large screens
                if (rightPanelBuilder != null) ...[
                  const SizedBox(width: NeumorphicSpacing.lg),
                  SizedBox(
                    width: rightPanelWidth,
                    child: _buildRightPanelContainer(context),
                  ),
                ],
              ],
            ),
          ),
          // Footer
          if (footerBuilder != null) ...[
            const SizedBox(height: NeumorphicSpacing.md),
            footerBuilder!(context),
          ],
        ],
      ),
    );

    // Apply max width constraint if set
    if (maxContentWidth != null) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth!),
          child: content,
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.colors.backgroundGradient,
        ),
        child: SafeArea(child: content),
      ),
    );
  }

  /// Build the right panel container with glass effect
  Widget _buildRightPanelContainer(BuildContext context) {
    final theme = GlassTheme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.isDark
                  ? const Color(0x33FFFFFF)
                  : const Color(0x66FFFFFF),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(NeumorphicSpacing.md),
          child: rightPanelBuilder!(context),
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
