/// Widget Rebuild Optimization
///
/// Tools to prevent unnecessary widget rebuilds
library;

import 'package:flutter/material.dart';

/// Build and rebuild optimization utilities
class RebuildOptimization {
  /// Defer heavy widget building until needed
  ///
  /// Uses FutureBuilder to delay rendering of expensive widgets
  static Widget deferBuild({
    required Widget Function() builder,
    Widget? placeholder,
    Duration delay = const Duration(milliseconds: 50),
  }) {
    return FutureBuilder(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return builder();
        }
        return placeholder ?? const SizedBox.shrink();
      },
    );
  }

  /// Batch multiple setState calls to reduce rebuilds
  static void batchedSetState(
    State state,
    List<VoidCallback> updates,
  ) {
    if (updates.isEmpty) return;

    // ignore: invalid_use_of_protected_member
    state.setState(() {
      for (final update in updates) {
        update();
      }
    });
  }
}

/// Widget rebuild optimizer
///
/// Prevents unnecessary rebuilds by comparing old and new data
class RebuildOptimizer<T> extends StatefulWidget {
  final T data;
  final Widget Function(BuildContext, T) builder;
  final bool Function(T oldData, T newData)? shouldRebuild;

  const RebuildOptimizer({
    super.key,
    required this.data,
    required this.builder,
    this.shouldRebuild,
  });

  @override
  State<RebuildOptimizer<T>> createState() => _RebuildOptimizerState<T>();
}

class _RebuildOptimizerState<T> extends State<RebuildOptimizer<T>> {
  late T _cachedData;
  late Widget _cachedWidget;

  @override
  void initState() {
    super.initState();
    _cachedData = widget.data;
    _cachedWidget = widget.builder(context, _cachedData);
  }

  @override
  void didUpdateWidget(RebuildOptimizer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final shouldRebuild = widget.shouldRebuild?.call(
      _cachedData,
      widget.data,
    ) ?? (_cachedData != widget.data);

    if (shouldRebuild) {
      _cachedData = widget.data;
      _cachedWidget = widget.builder(context, _cachedData);
    }
  }

  @override
  Widget build(BuildContext context) => _cachedWidget;
}
