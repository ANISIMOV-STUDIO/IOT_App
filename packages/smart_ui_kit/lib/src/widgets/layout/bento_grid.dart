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

/// Bento Grid layout widget
/// Creates Apple-style mosaic layout with different sized cards
class BentoGrid extends StatelessWidget {
  final List<BentoItem> items;
  final int columns;
  final double gap;

  /// Cell height. If null, auto-calculates to fill available height.
  final double? cellHeight;

  const BentoGrid({
    super.key,
    required this.items,
    this.columns = 4,
    this.gap = 16,
    this.cellHeight = 140,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        final cellWidth = (availableWidth - (gap * (columns - 1))) / columns;

        // Build grid using a simple flow algorithm
        final List<_PlacedItem> placedItems = _placeItems(cellWidth);

        // Calculate number of rows
        final maxRow = placedItems.fold<int>(0, (max, item) =>
          item.row + item.bentoItem.rowSpan > max ? item.row + item.bentoItem.rowSpan : max);

        // Auto-calculate cell height if not specified and we have bounded height
        final effectiveCellHeight = cellHeight ??
            (availableHeight.isFinite && maxRow > 0
                ? (availableHeight - (maxRow - 1) * gap) / maxRow
                : 140);

        final totalHeight = maxRow * effectiveCellHeight + (maxRow - 1) * gap;

        return SizedBox(
          height: totalHeight,
          child: Stack(
            children: placedItems.map((placed) {
              final width = placed.bentoItem.columnSpan * cellWidth +
                (placed.bentoItem.columnSpan - 1) * gap;
              final height = placed.bentoItem.rowSpan * effectiveCellHeight +
                (placed.bentoItem.rowSpan - 1) * gap;
              final left = placed.col * (cellWidth + gap);
              final top = placed.row * (effectiveCellHeight + gap);

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

  List<_PlacedItem> _placeItems(double cellWidth) {
    // Grid occupancy tracker
    final grid = <int, Set<int>>{}; // row -> occupied columns
    final placed = <_PlacedItem>[];

    for (final item in items) {
      final position = _findPosition(grid, item);
      placed.add(_PlacedItem(item, position.$1, position.$2));

      // Mark cells as occupied
      for (int r = position.$1; r < position.$1 + item.rowSpan; r++) {
        grid.putIfAbsent(r, () => <int>{});
        for (int c = position.$2; c < position.$2 + item.columnSpan; c++) {
          grid[r]!.add(c);
        }
      }
    }

    return placed;
  }

  (int row, int col) _findPosition(Map<int, Set<int>> grid, BentoItem item) {
    int row = 0;
    while (true) {
      for (int col = 0; col <= columns - item.columnSpan; col++) {
        if (_canPlace(grid, row, col, item)) {
          return (row, col);
        }
      }
      row++;
      if (row > 100) break; // Safety limit
    }
    return (0, 0);
  }

  bool _canPlace(Map<int, Set<int>> grid, int row, int col, BentoItem item) {
    for (int r = row; r < row + item.rowSpan; r++) {
      for (int c = col; c < col + item.columnSpan; c++) {
        if (c >= columns) return false;
        if (grid[r]?.contains(c) ?? false) return false;
      }
    }
    return true;
  }
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
        (theme.isDark
            ? const Color(0x1AFFFFFF)
            : const Color(0xB3FFFFFF));

    final borderColor = theme.isDark
        ? const Color(0x33FFFFFF)
        : const Color(0x66FFFFFF);

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
                color: Colors.black.withValues(alpha: theme.isDark ? 0.3 : 0.08),
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
