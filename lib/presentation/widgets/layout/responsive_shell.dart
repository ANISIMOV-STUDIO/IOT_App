import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Navigation item for the shell
class NavItem {
  final IconData icon;
  final String label;
  final String? badge;

  const NavItem({
    required this.icon,
    required this.label,
    this.badge,
  });
}

/// Material 3 Window Size Classes
class WindowSizeClass {
  static const double compact = 600;
  static const double medium = 840;
  static const double expanded = 1200;
}

/// Layout mode
enum LayoutMode { compact, medium, expanded, large }

/// Responsive dashboard shell using shadcn_ui components
class ResponsiveShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<NavItem> navItems;
  final List<Widget> pages;
  final Widget Function(BuildContext)? rightPanelBuilder;
  final Widget Function(BuildContext)? footerBuilder;
  final List<Widget>? headerActions;
  final String? userName;
  final Widget? logoWidget;
  final double maxContentWidth;

  static const double sidebarWidth = 240.0;
  static const double rightPanelWidth = 340.0;

  const ResponsiveShell({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.navItems,
    required this.pages,
    this.rightPanelBuilder,
    this.footerBuilder,
    this.headerActions,
    this.userName,
    this.logoWidget,
    this.maxContentWidth = 1600,
  });

  static LayoutMode getLayoutMode(double width) {
    if (width < WindowSizeClass.compact) return LayoutMode.compact;
    if (width < WindowSizeClass.medium) return LayoutMode.medium;
    if (width < WindowSizeClass.expanded) return LayoutMode.expanded;
    return LayoutMode.large;
  }

  static bool usesBottomNav(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mode = getLayoutMode(width);
    return mode == LayoutMode.compact || mode == LayoutMode.medium;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mode = getLayoutMode(constraints.maxWidth);

        return switch (mode) {
          LayoutMode.compact || LayoutMode.medium => _buildCompactLayout(context),
          LayoutMode.expanded => _buildExpandedLayout(context, constraints),
          LayoutMode.large => _buildLargeLayout(context, constraints),
        };
      },
    );
  }

  Widget _buildCompactLayout(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            _buildHeader(context),
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
      bottomNavigationBar: _buildBottomNav(context),
      floatingActionButton: rightPanelBuilder != null
          ? FloatingActionButton(
              onPressed: () => _showRightPanelSheet(context),
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.thermostat, color: theme.colorScheme.primaryForeground),
            )
          : null,
    );
  }

  Widget _buildExpandedLayout(BuildContext context, BoxConstraints constraints) {
    final theme = ShadTheme.of(context);
    final showRightPanel = constraints.maxWidth >= 1400 && rightPanelBuilder != null;

    Widget content = Column(
      children: [
        // Header spans full width
        _buildHeader(context),
        // Main row with sidebar, content, right panel
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSidebar(context),
              const SizedBox(width: _barSpacing),
              Expanded(
                child: IndexedStack(
                  index: selectedIndex.clamp(0, pages.length - 1),
                  children: pages,
                ),
              ),
              if (showRightPanel) ...[
                const SizedBox(width: _barSpacing),
                _buildRightPanel(context),
              ],
            ],
          ),
        ),
        // Footer spans full width
        if (footerBuilder != null) _wrapFooter(footerBuilder!(context)),
      ],
    );

    // Apply max width
    content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: content,
      ),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16),
        child: content,
      )),
      floatingActionButton: rightPanelBuilder != null && !showRightPanel
          ? FloatingActionButton(
              onPressed: () => _showRightPanelSheet(context),
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.thermostat, color: theme.colorScheme.primaryForeground),
            )
          : null,
    );
  }

  Widget _buildLargeLayout(BuildContext context, BoxConstraints constraints) {
    final theme = ShadTheme.of(context);

    Widget content = Column(
      children: [
        // Header spans full width
        _buildHeader(context),
        // Main row with sidebar, content, right panel
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSidebar(context),
              const SizedBox(width: _barSpacing),
              Expanded(
                child: IndexedStack(
                  index: selectedIndex.clamp(0, pages.length - 1),
                  children: pages,
                ),
              ),
              if (rightPanelBuilder != null) ...[
                const SizedBox(width: _barSpacing),
                _buildRightPanel(context),
              ],
            ],
          ),
        ),
        // Footer spans full width
        if (footerBuilder != null) _wrapFooter(footerBuilder!(context)),
      ],
    );

    content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: content,
      ),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(24),
        child: content,
      )),
    );
  }

  static const double _barHeight = 40.0;
  static const double _barSpacing = 16.0;

  Widget _buildHeader(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: _barSpacing),
      child: SizedBox(
        height: _barHeight,
        child: Row(
          children: [
            if (logoWidget != null) ...[
              SizedBox(width: 32, height: 32, child: logoWidget),
              const SizedBox(width: 10),
            ],
            Text(
              'BREEZ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.foreground,
              ),
            ),
            const Spacer(),
            if (headerActions != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: headerActions!
                    .map((a) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: a,
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _wrapFooter(Widget footer) {
    return Padding(
      padding: const EdgeInsets.only(top: _barSpacing),
      child: SizedBox(
        height: _barHeight,
        child: footer,
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      width: sidebarWidth,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User profile
          if (userName != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withValues(alpha: 0.7),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      userName![0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                        color: theme.colorScheme.primaryForeground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      userName!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.foreground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          if (userName != null) const SizedBox(height: 8),
          // Nav items
          ...navItems.asMap().entries.map((e) {
            final index = e.key;
            final item = e.value;
            final isSelected = index == selectedIndex;

            return _buildNavItem(
              context,
              item: item,
              isSelected: isSelected,
              onTap: () => onIndexChanged(index),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required NavItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          hoverColor: theme.colorScheme.muted.withValues(alpha: 0.3),
          child: Container(
            decoration: isSelected
                ? BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 3,
                      ),
                    ),
                  )
                : null,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.mutedForeground,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? theme.colorScheme.foreground
                          : theme.colorScheme.mutedForeground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.badge != null)
                  ShadBadge(
                    child: Text(item.badge!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        border: Border(
          top: BorderSide(color: theme.colorScheme.border),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems.asMap().entries.map((e) {
              final index = e.key;
              final item = e.value;
              final isSelected = index == selectedIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => onIndexChanged(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            item.icon,
                            size: 24,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.mutedForeground,
                          ),
                          if (item.badge != null)
                            Positioned(
                              right: -8,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.destructive,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  item.badge!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: theme.colorScheme.destructiveForeground,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.mutedForeground,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ShadCard(
        width: rightPanelWidth,
        padding: const EdgeInsets.all(16),
        child: rightPanelBuilder!(context),
      ),
    );
  }

  void _showRightPanelSheet(BuildContext context) {
    if (rightPanelBuilder == null) return;

    showShadSheet(
      context: context,
      side: ShadSheetSide.bottom,
      builder: (context) => ShadSheet(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: rightPanelBuilder!(context),
        ),
      ),
    );
  }
}
