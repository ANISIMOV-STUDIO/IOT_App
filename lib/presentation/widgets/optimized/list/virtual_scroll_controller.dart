/// Virtual Scrolling Controller
/// Manages virtual scrolling for large datasets
library;

import 'package:flutter/material.dart';

/// Virtual scrolling controller for extremely large datasets
class VirtualScrollController {
  final int itemCount;
  final double itemHeight;
  final int bufferSize;

  final _visibleIndices = <int>{};
  final _cachedWidgets = <int, Widget>{};

  VirtualScrollController({
    required this.itemCount,
    required this.itemHeight,
    this.bufferSize = 5,
  });

  /// Calculate visible indices based on scroll position
  Set<int> calculateVisibleIndices(ScrollPosition position) {
    final viewportHeight = position.viewportDimension;
    final scrollOffset = position.pixels;

    final firstVisibleIndex = (scrollOffset / itemHeight).floor();
    final lastVisibleIndex =
        ((scrollOffset + viewportHeight) / itemHeight).ceil();

    final indices = <int>{};
    for (int i = firstVisibleIndex - bufferSize;
        i <= lastVisibleIndex + bufferSize;
        i++) {
      if (i >= 0 && i < itemCount) {
        indices.add(i);
      }
    }

    // Clean up cached widgets that are far from viewport
    _cachedWidgets.removeWhere((index, _) {
      return index < firstVisibleIndex - bufferSize * 2 ||
          index > lastVisibleIndex + bufferSize * 2;
    });

    return indices;
  }

  /// Update visible indices
  void updateVisibleIndices(Set<int> newIndices) {
    _visibleIndices
      ..clear()
      ..addAll(newIndices);
  }

  /// Check if index is visible
  bool isIndexVisible(int index) => _visibleIndices.contains(index);

  /// Cache a widget
  void cacheWidget(int index, Widget widget) {
    _cachedWidgets[index] = widget;
  }

  /// Get cached widget
  Widget? getCachedWidget(int index) => _cachedWidgets[index];

  /// Dispose controller
  void dispose() {
    _visibleIndices.clear();
    _cachedWidgets.clear();
  }
}
