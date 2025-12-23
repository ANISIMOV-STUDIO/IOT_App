import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/glass_theme.dart';

/// Bento Grid sizes for cards
enum BentoSize {
  /// 1x1 - small square
  square,

  /// 2x1 - wide horizontal
  wide,

  /// 1x2 - tall vertical
  tall,

  /// 2x2 - large square
  large,
}

/// Bento Grid item wrapper
class BentoItem {
  final BentoSize size;
  final Widget child;
  final int? order;

  const BentoItem({
    required this.size,
    required this.child,
    this.order,
  });

  int get columnSpan => switch (size) {
        BentoSize.square => 1,
        BentoSize.wide => 2,
        BentoSize.tall => 1,
        BentoSize.large => 2,
      };

  int get rowSpan => switch (size) {
        BentoSize.square => 1,
        BentoSize.wide => 1,
        BentoSize.tall => 2,
        BentoSize.large => 2,
      };
}

/// Responsive Bento Grid layout widget
/// Creates Apple-style mosaic layout with different sized cards
/// Automatically adjusts columns based on available width
class BentoGrid extends StatelessWidget {
  final List<BentoItem> items;

  /// Number of columns. If null, auto-calculated from minCellWidth.
  final int? columns;

  /// Gap between cells
  final double gap;

  /// Cell height
  final double cellHeight;

  /// Minimum cell width for auto-column calculation
  final double minCellWidth;

  /// Maximum columns allowed
  final int maxColumns;

  const BentoGrid({
    super.key,
    required this.items,
    this.columns,
    this.gap = 16,
    this.cellHeight = 160,
    this.minCellWidth = 280,
    this.maxColumns = 4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // Auto-calculate columns based on available width
        final effectiveColumns = columns ??
            _calculateColumns(availableWidth, minCellWidth, gap, maxColumns);

        // Ensure at least 1 column
        final cols = effectiveColumns.clamp(1, maxColumns);

        final cellWidth = (availableWidth - (gap * (cols - 1))) / cols;

        // Build grid using a simple flow algorithm
        final List<_PlacedItem> placedItems = _placeItems(cols);

        // Calculate number of rows
        final maxRow = placedItems.fold<int>(
            0,
            (max, item) => item.row + item.bentoItem.rowSpan > max
                ? item.row + item.bentoItem.rowSpan
                : max);

        final totalHeight = maxRow * cellHeight + (maxRow - 1) * gap;

        return SizedBox(
          height: totalHeight,
          child: Stack(
            children: placedItems.map((placed) {
              // Clamp column span to available columns
              final effectiveColSpan =
                  placed.bentoItem.columnSpan.clamp(1, cols);

              final width =
                  effectiveColSpan * cellWidth + (effectiveColSpan - 1) * gap;
              final height = placed.bentoItem.rowSpan * cellHeight +
                  (placed.bentoItem.rowSpan - 1) * gap;
              final left = placed.col * (cellWidth + gap);
              final top = placed.row * (cellHeight + gap);

              return Positioned(
                left: left,
                top: top,
                width: width,
                height: height,
                child: placed.bentoItem.child,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// Calculate optimal number of columns based on available width
  static int _calculateColumns(
      double availableWidth, double minCellWidth, double gap, int maxColumns) {
    // Start with max columns and reduce until cells fit
    for (int cols = maxColumns; cols >= 1; cols--) {
      final cellWidth = (availableWidth - (gap * (cols - 1))) / cols;
      if (cellWidth >= minCellWidth) {
        return cols;
      }
    }
    return 1;
  }

  List<_PlacedItem> _placeItems(int cols) {
    // Grid occupancy tracker
    final grid = <int, Set<int>>{}; // row -> occupied columns
    final placed = <_PlacedItem>[];

    for (final item in items) {
      // Clamp column span to available columns
      final effectiveColSpan = item.columnSpan.clamp(1, cols);
      final adjustedItem = effectiveColSpan != item.columnSpan
          ? _AdjustedBentoItem(item, effectiveColSpan)
          : item;

      final position = _findPosition(grid, adjustedItem, cols);
      placed.add(_PlacedItem(item, position.$1, position.$2));

      // Mark cells as occupied
      for (int r = position.$1; r < position.$1 + item.rowSpan; r++) {
        grid.putIfAbsent(r, () => <int>{});
        for (int c = position.$2;
            c < position.$2 + effectiveColSpan.clamp(1, cols);
            c++) {
          grid[r]!.add(c);
        }
      }
    }

    return placed;
  }

  (int row, int col) _findPosition(
      Map<int, Set<int>> grid, BentoItem item, int cols) {
    final effectiveColSpan = item.columnSpan.clamp(1, cols);

    int row = 0;
    while (true) {
      for (int col = 0; col <= cols - effectiveColSpan; col++) {
        if (_canPlace(grid, row, col, item.rowSpan, effectiveColSpan, cols)) {
          return (row, col);
        }
      }
      row++;
      if (row > 100) break; // Safety limit
    }
    return (0, 0);
  }

  bool _canPlace(Map<int, Set<int>> grid, int row, int col, int rowSpan,
      int colSpan, int cols) {
    for (int r = row; r < row + rowSpan; r++) {
      for (int c = col; c < col + colSpan; c++) {
        if (c >= cols) return false;
        if (grid[r]?.contains(c) ?? false) return false;
      }
    }
    return true;
  }
}

/// Helper class for adjusted column span
class _AdjustedBentoItem extends BentoItem {
  final int _adjustedColSpan;

  _AdjustedBentoItem(BentoItem original, this._adjustedColSpan)
      : super(size: original.size, child: original.child, order: original.order);

  @override
  int get columnSpan => _adjustedColSpan;
}

class _PlacedItem {
  final BentoItem bentoItem;
  final int row;
  final int col;

  _PlacedItem(this.bentoItem, this.row, this.col);
}

/// Bento Card wrapper with glass styling
class BentoCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const BentoCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = GlassTheme.of(context);

    final bgColor = backgroundColor ??
        (theme.isDark ? const Color(0x1AFFFFFF) : const Color(0xB3FFFFFF));

    final borderColor =
        theme.isDark ? const Color(0x33FFFFFF) : const Color(0x66FFFFFF);

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                bgColor,
                bgColor.withValues(alpha: bgColor.a * 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withValues(alpha: theme.isDark ? 0.3 : 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
            ],
          ),
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: card,
        ),
      );
    }

    return card;
  }
}
