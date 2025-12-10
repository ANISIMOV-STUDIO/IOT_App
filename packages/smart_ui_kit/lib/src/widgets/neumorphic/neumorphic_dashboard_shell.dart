import 'package:flutter/material.dart';
import '../../theme/neumorphic_theme.dart';
import '../../theme/tokens/neumorphic_spacing.dart';

/// Neumorphic Dashboard Shell - 3-column responsive layout
class NeumorphicDashboardShell extends StatelessWidget {
  final Widget sidebar;
  final Widget mainContent;
  final Widget? rightPanel;
  final bool showRightPanel;

  const NeumorphicDashboardShell({
    super.key,
    required this.sidebar,
    required this.mainContent,
    this.rightPanel,
    this.showRightPanel = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive breakpoints
    final isDesktop = screenWidth >= NeumorphicSpacing.breakpointDesktop;
    final isTablet = screenWidth >= NeumorphicSpacing.breakpointTablet;
    final showRight = showRightPanel && rightPanel != null && isTablet;

    return Scaffold(
      backgroundColor: theme.colors.surface,
      body: Row(
        children: [
          // Sidebar
          sidebar,
          
          // Main content area
          Expanded(
            child: Container(
              color: theme.colors.surface,
              child: mainContent,
            ),
          ),
          
          // Right panel (optional, responsive)
          if (showRight)
            Container(
              width: isDesktop 
                  ? NeumorphicSpacing.rightPanelWidth 
                  : NeumorphicSpacing.rightPanelWidth * 0.85,
              decoration: BoxDecoration(
                color: theme.colors.cardSurface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colors.shadowDark.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(-5, 0),
                  ),
                ],
              ),
              child: rightPanel,
            ),
        ],
      ),
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
        // Header
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(NeumorphicSpacing.screenPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: theme.typography.headlineLarge,
                ),
                if (actions != null)
                  Row(children: actions!),
              ],
            ),
          ),
        
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: NeumorphicSpacing.screenPadding,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

/// Right panel for climate controls and stats
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
      padding: padding ?? const EdgeInsets.all(NeumorphicSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
