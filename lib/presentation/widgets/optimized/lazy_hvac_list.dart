/// Lazy HVAC List Widget
/// Main lazy-loaded list with pagination
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';
import 'list/lazy_list_controller.dart';
import 'list/lazy_list_item.dart';
import 'list/shimmer_loading_card.dart';

// Export virtual scroll controller for advanced usage
export 'list/virtual_scroll_controller.dart';

/// Lazy-loaded HVAC list with pagination and performance optimizations
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
  late final LazyListController<HvacUnit> _controller;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = LazyListController<HvacUnit>();
    _controller.initialize(widget.initialUnits, widget.pageSize);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_controller.isLoadingMore || !_controller.hasMoreData) return;

    setState(() {
      _controller.startLoading();
    });

    try {
      final nextPage = _controller.currentPage + 1;
      if (_controller.isPageLoaded(nextPage)) {
        setState(() {
          _controller.stopLoading();
        });
        return;
      }

      final newUnits = await widget.onLoadMore(nextPage, widget.pageSize);

      if (mounted) {
        setState(() {
          _controller.addItems(newUnits, nextPage);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _controller.stopLoading();
        });
        _showErrorSnackbar('Failed to load more items: $e');
      }
    }
  }

  Future<void> _handleRefresh() async {
    if (widget.onRefresh != null) {
      widget.onRefresh!();
    }

    setState(() {
      _controller.reset(widget.initialUnits);
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

  @override
  Widget build(BuildContext context) {
    _controller.frameStopwatch
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
          if (_controller.isLoadingMore) _buildLoadingIndicator(),
          if (!_controller.hasMoreData && _controller.items.isNotEmpty)
            _buildEndIndicator(),
        ],
      ),
    );

    _controller.frameStopwatch.stop();
    _controller.renderTimes.add(_controller.frameStopwatch.elapsed);

    return result;
  }

  Widget _buildUnitsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= _controller.items.length) return null;

          final unit = _controller.items[index];
          final isSelected = unit.id == widget.selectedUnitId;

          return LazyListItem(
            key: ValueKey(unit.id),
            unit: unit,
            isSelected: isSelected,
            index: index,
            onTap: () => widget.onUnitTap?.call(unit),
            onPowerChanged: (power) => widget.onPowerChanged?.call(unit, power),
          );
        },
        childCount: _controller.items.length,
        findChildIndexCallback: (key) {
          if (key is ValueKey<String>) {
            final index =
                _controller.items.indexWhere((unit) => unit.id == key.value);
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
        padding: const EdgeInsets.symmetric(vertical: HvacSpacing.lg),
        child: Column(
          children: List.generate(
            3,
            (index) => const ShimmerLoadingCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildEndIndicator() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: HvacSpacing.xl),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 48.0,
                color: Colors.white30,
              ),
              const SizedBox(height: HvacSpacing.md),
              const Text(
                'All units loaded',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: HvacSpacing.xs),
              Text(
                '${_controller.items.length} total units',
                style: const TextStyle(
                  fontSize: 12.0,
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
