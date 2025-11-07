/// Lazy List Controller
/// Manages pagination and loading state for lazy lists
library;

import 'package:flutter/material.dart';

/// Controller for managing lazy list state and pagination
class LazyListController<T> {
  final List<T> _items = [];
  final Set<int> _loadedPages = {};
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 0;

  // Performance monitoring
  final List<Duration> renderTimes = [];
  final Stopwatch frameStopwatch = Stopwatch();

  List<T> get items => List.unmodifiable(_items);
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreData => _hasMoreData;
  int get currentPage => _currentPage;
  Set<int> get loadedPages => Set.unmodifiable(_loadedPages);

  /// Initialize controller with initial items
  void initialize(List<T> initialItems, int pageSize) {
    _items.clear();
    _items.addAll(initialItems);
    _loadedPages.clear();

    if (_items.isNotEmpty) {
      _loadedPages.add(0);
      _currentPage = (_items.length / pageSize).ceil() - 1;
    }
  }

  /// Start loading more items
  void startLoading() {
    _isLoadingMore = true;
  }

  /// Stop loading
  void stopLoading() {
    _isLoadingMore = false;
  }

  /// Add new items from pagination
  void addItems(List<T> newItems, int pageNumber) {
    if (newItems.isEmpty) {
      _hasMoreData = false;
    } else {
      _items.addAll(newItems);
      _loadedPages.add(pageNumber);
      _currentPage = pageNumber;
    }
    _isLoadingMore = false;
  }

  /// Reset pagination state
  void reset(List<T> initialItems) {
    _items.clear();
    _items.addAll(initialItems);
    _loadedPages.clear();
    _loadedPages.add(0);
    _currentPage = 0;
    _hasMoreData = true;
    _isLoadingMore = false;
  }

  /// Check if page is already loaded
  bool isPageLoaded(int pageNumber) {
    return _loadedPages.contains(pageNumber);
  }

  /// Log performance metrics
  void logPerformanceMetrics() {
    if (renderTimes.isEmpty) return;

    final averageRenderTime =
        renderTimes.map((d) => d.inMicroseconds).reduce((a, b) => a + b) ~/
            renderTimes.length;

    debugPrint('📊 LazyList Performance Metrics:');
    debugPrint('  - Average render time: ${averageRenderTime / 1000}ms');
    debugPrint('  - Total items rendered: ${_items.length}');
    debugPrint('  - Pages loaded: ${_loadedPages.length}');
  }

  /// Dispose controller
  void dispose() {
    logPerformanceMetrics();
    renderTimes.clear();
  }
}
