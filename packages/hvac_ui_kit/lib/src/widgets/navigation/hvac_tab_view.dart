/// HVAC Tab View - Tab content container
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Tab view wrapper for tab content
///
/// Features:
/// - Syncs with TabController
/// - Swipeable tabs (optional)
/// - Custom physics
///
/// Usage:
/// ```dart
/// HvacTabView(
///   controller: _tabController,
///   children: [
///     HomeTab(),
///     SettingsTab(),
///   ],
/// )
/// ```
class HvacTabView extends StatelessWidget {
  /// Tab controller
  final TabController? controller;

  /// Tab content widgets
  final List<Widget> children;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Drag start behavior
  final DragStartBehavior? dragStartBehavior;

  /// View port fraction
  final double viewportFraction;

  const HvacTabView({
    super.key,
    this.controller,
    required this.children,
    this.physics,
    this.dragStartBehavior,
    this.viewportFraction = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      physics: physics,
      dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
      viewportFraction: viewportFraction,
      children: children,
    );
  }
}

/// Non-swipeable tab view
///
/// Usage:
/// ```dart
/// HvacStaticTabView(
///   controller: _tabController,
///   children: [
///     HomeTab(),
///     SettingsTab(),
///   ],
/// )
/// ```
class HvacStaticTabView extends StatelessWidget {
  final TabController? controller;
  final List<Widget> children;

  const HvacStaticTabView({
    super.key,
    this.controller,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return HvacTabView(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

/// Tab scaffold with built-in TabBar + TabBarView
///
/// Usage:
/// ```dart
/// HvacTabScaffold(
///   tabs: ['Home', 'Settings'],
///   tabViews: [
///     HomeTab(),
///     SettingsTab(),
///   ],
/// )
/// ```
class HvacTabScaffold extends StatefulWidget {
  /// Tab labels
  final List<String> tabs;

  /// Tab content widgets
  final List<Widget> tabViews;

  /// Initial tab index
  final int initialIndex;

  /// Tab bar at bottom (default top)
  final bool tabBarAtBottom;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// App bar title
  final String? title;

  /// Actions for app bar
  final List<Widget>? actions;

  const HvacTabScaffold({
    super.key,
    required this.tabs,
    required this.tabViews,
    this.initialIndex = 0,
    this.tabBarAtBottom = false,
    this.isScrollable = false,
    this.title,
    this.actions,
  }) : assert(tabs.length == tabViews.length);

  @override
  State<HvacTabScaffold> createState() => _HvacTabScaffoldState();
}

class _HvacTabScaffoldState extends State<HvacTabScaffold>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title != null
          ? AppBar(
              title: Text(widget.title!),
              actions: widget.actions,
              bottom: !widget.tabBarAtBottom
                  ? TabBar(
                      controller: _tabController,
                      tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
                      isScrollable: widget.isScrollable,
                    )
                  : null,
            )
          : null,
      body: Column(
        children: [
          if (widget.tabBarAtBottom && widget.title == null)
            TabBar(
              controller: _tabController,
              tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
              isScrollable: widget.isScrollable,
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.tabViews,
            ),
          ),
        ],
      ),
    );
  }
}
