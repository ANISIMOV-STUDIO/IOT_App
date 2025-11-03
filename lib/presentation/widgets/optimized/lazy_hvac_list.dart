import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import 'optimized_hvac_card.dart';

/// Lazy-loaded HVAC list with pagination and performance optimizations
///
/// Key features:
/// - Lazy loading with pagination
/// - Item caching for smooth scrolling
/// - Skeleton loading states
/// - Pull-to-refresh
/// - Automatic memory management
/// - Virtual scrolling for large datasets
class LazyHvacList extends StatefulWidget {
  final List<HvacUnit> initialUnits;
  final Future<List<HvacUnit>> Function(int page, int pageSize) onLoadMore;
  final VoidCallback? onRefresh;
  final Function(HvacUnit unit)? onUnitTap;
  final Function(HvacUnit unit, bool power)? onPowerChanged;
  final String? selectedUnitId;
  final int pageSize;
  final double cacheExtent;

  const LazyHvacList({
    super.key,
    required this.initialUnits,
    required this.onLoadMore,
    this.onRefresh,
    this.onUnitTap,
    this.onPowerChanged,
    this.selectedUnitId,
    this.pageSize = 10,
    this.cacheExtent = 500.0,
  });

  @override
  State<LazyHvacList> createState() => _LazyHvacListState();
}

class _LazyHvacListState extends State<LazyHvacList> {
  late final ScrollController _scrollController;
  late final List<HvacUnit> _units;
  final Set<int> _loadedPages = {};
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 0;

  // Performance monitoring
  final _renderTimes = <Duration>[];
  late final Stopwatch _frameStopwatch;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _units = List.from(widget.initialUnits);
    _frameStopwatch = Stopwatch();

    // Mark initial page as loaded
    if (_units.isNotEmpty) {
      _loadedPages.add(0);
      _currentPage = (_units.length / widget.pageSize).ceil() - 1;
    }

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _logPerformanceMetrics();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      if (_loadedPages.contains(nextPage)) {
        setState(() {
          _isLoadingMore = false;
        });
        return;
      }

      final newUnits = await widget.onLoadMore(nextPage, widget.pageSize);

      if (mounted) {
        setState(() {
          if (newUnits.isEmpty) {
            _hasMoreData = false;
          } else {
            _units.addAll(newUnits);
            _loadedPages.add(nextPage);
            _currentPage = nextPage;
          }
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        _showErrorSnackbar('Failed to load more items: $e');
      }
    }
  }

  Future<void> _handleRefresh() async {
    if (widget.onRefresh != null) {
      widget.onRefresh!();
    }

    // Reset pagination state
    setState(() {
      _units.clear();
      _units.addAll(widget.initialUnits);
      _loadedPages.clear();
      _loadedPages.add(0);
      _currentPage = 0;
      _hasMoreData = true;
      _isLoadingMore = false;
    });
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _logPerformanceMetrics() {
    if (_renderTimes.isEmpty) return;

    final averageRenderTime = _renderTimes
            .map((d) => d.inMicroseconds)
            .reduce((a, b) => a + b) ~/
        _renderTimes.length;

    debugPrint('📊 LazyHvacList Performance Metrics:');
    debugPrint('  - Average render time: ${averageRenderTime / 1000}ms');
    debugPrint('  - Total items rendered: ${_units.length}');
    debugPrint('  - Pages loaded: ${_loadedPages.length}');
  }

  @override
  Widget build(BuildContext context) {
    _frameStopwatch
      ..reset()
      ..start();

    final result = RefreshIndicator(
      onRefresh: _handleRefresh,
      color: HvacColors.primaryBlue,
      backgroundColor: HvacColors.cardDark,
      child: CustomScrollView(
        controller: _scrollController,
        cacheExtent: widget.cacheExtent,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildUnitsList(),
          if (_isLoadingMore) _buildLoadingIndicator(),
          if (!_hasMoreData && _units.isNotEmpty) _buildEndIndicator(),
        ],
      ),
    );

    _frameStopwatch.stop();
    _renderTimes.add(_frameStopwatch.elapsed);

    return result;
  }

  Widget _buildUnitsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= _units.length) return null;

          final unit = _units[index];
          final isSelected = unit.id == widget.selectedUnitId;

          return _LazyListItem(
            key: ValueKey(unit.id),
            unit: unit,
            isSelected: isSelected,
            index: index,
            onTap: () => widget.onUnitTap?.call(unit),
            onPowerChanged: (power) =>
                widget.onPowerChanged?.call(unit, power),
          );
        },
        childCount: _units.length,
        // Use these callbacks for performance optimization
        findChildIndexCallback: (key) {
          if (key is ValueKey<String>) {
            final index = _units.indexWhere((unit) => unit.id == key.value);
            return index != -1 ? index : null;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: HvacSpacing.lg.h),
        child: Column(
          children: List.generate(
            3,
            (index) => _ShimmerLoadingCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildEndIndicator() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: HvacSpacing.xl.h),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48.sp,
                color: Colors.white30,
              ),
              SizedBox(height: HvacSpacing.md.h),
              Text(
                'All units loaded',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white54,
                ),
              ),
              SizedBox(height: HvacSpacing.xs.h),
              Text(
                '${_units.length} total units',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lazy list item with automatic visibility detection
class _LazyListItem extends StatefulWidget {
  final HvacUnit unit;
  final bool isSelected;
  final int index;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onPowerChanged;

  const _LazyListItem({
    super.key,
    required this.unit,
    required this.isSelected,
    required this.index,
    this.onTap,
    this.onPowerChanged,
  });

  @override
  State<_LazyListItem> createState() => _LazyListItemState();
}

class _LazyListItemState extends State<_LazyListItem>
    with AutomaticKeepAliveClientMixin {
  bool _isVisible = false;

  @override
  bool get wantKeepAlive => widget.isSelected || _isVisible;

  @override
  void initState() {
    super.initState();
    // Stagger the appearance animation
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isVisible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _isVisible ? Offset.zero : const Offset(0, 0.1),
        child: OptimizedHvacCard(
          unit: widget.unit,
          isSelected: widget.isSelected,
          onTap: widget.onTap,
          onPowerChanged: widget.onPowerChanged,
        ),
      ),
    );
  }
}

/// Shimmer loading card for skeleton UI
class _ShimmerLoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: HvacSpacing.md.w,
        vertical: HvacSpacing.sm.h,
      ),
      padding: EdgeInsets.all(HvacSpacing.lg.w),
      decoration: BoxDecoration(
        color: HvacColors.cardDark,
        borderRadius: BorderRadius.circular(HvacSpacing.lg.r),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.white24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(HvacSpacing.xs.r),
                      ),
                    ),
                    SizedBox(height: HvacSpacing.xs.h),
                    Container(
                      width: 100.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(HvacSpacing.xs.r),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 50.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: HvacSpacing.lg.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                3,
                (index) => Container(
                  width: 60.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(HvacSpacing.sm.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

  void updateVisibleIndices(Set<int> newIndices) {
    _visibleIndices
      ..clear()
      ..addAll(newIndices);
  }

  bool isIndexVisible(int index) => _visibleIndices.contains(index);

  void cacheWidget(int index, Widget widget) {
    _cachedWidgets[index] = widget;
  }

  Widget? getCachedWidget(int index) => _cachedWidgets[index];

  void dispose() {
    _visibleIndices.clear();
    _cachedWidgets.clear();
  }
}