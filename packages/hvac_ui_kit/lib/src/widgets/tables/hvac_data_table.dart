/// HVAC Data Table - Simple data table component
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

/// Simple data table for displaying tabular data
///
/// Features:
/// - Header row with column titles
/// - Data rows
/// - Sortable columns (optional)
/// - Row selection (optional)
/// - Material 3 styling
///
/// Usage:
/// ```dart
/// HvacDataTable(
///   columns: [
///     HvacDataColumn(label: 'Device'),
///     HvacDataColumn(label: 'Status'),
///     HvacDataColumn(label: 'Temperature'),
///   ],
///   rows: [
///     HvacDataRow(cells: [
///       HvacDataCell(Text('Living Room')),
///       HvacDataCell(Text('Active')),
///       HvacDataCell(Text('24°C')),
///     ]),
///   ],
/// )
/// ```
class HvacDataTable extends StatelessWidget {
  /// Table columns
  final List<HvacDataColumn> columns;

  /// Table rows
  final List<HvacDataRow> rows;

  /// Show header
  final bool showHeader;

  /// Header background color
  final Color? headerColor;

  /// Row background color
  final Color? rowColor;

  /// Alternate row color
  final Color? alternateRowColor;

  /// Border color
  final Color? borderColor;

  /// Show borders
  final bool showBorders;

  /// Column spacing
  final double columnSpacing;

  /// Horizontal margin
  final double horizontalMargin;

  const HvacDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.showHeader = true,
    this.headerColor,
    this.rowColor,
    this.alternateRowColor,
    this.borderColor,
    this.showBorders = true,
    this.columnSpacing = HvacSpacing.md,
    this.horizontalMargin = HvacSpacing.md,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: showBorders
            ? Border.all(
                color: borderColor ?? HvacColors.backgroundCardBorder,
                width: 1,
              )
            : null,
        borderRadius: HvacRadius.lgRadius,
      ),
      child: ClipRRect(
        borderRadius: HvacRadius.lgRadius,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: columns
                .map(
                  (col) => DataColumn(
                    label: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: HvacColors.textPrimary,
                      ),
                      child: col.label,
                    ),
                    numeric: col.numeric,
                    onSort: col.onSort,
                  ),
                )
                .toList(),
            rows: rows
                .asMap()
                .entries
                .map(
                  (entry) => DataRow(
                    cells: entry.value.cells
                        .map(
                          (cell) => DataCell(
                            DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 14,
                                color: HvacColors.textPrimary,
                              ),
                              child: cell.child,
                            ),
                            onTap: cell.onTap,
                          ),
                        )
                        .toList(),
                    selected: entry.value.selected,
                    onSelectChanged: entry.value.onSelectChanged,
                    color: WidgetStateProperty.resolveWith<Color?>(
                      (states) {
                        if (states.contains(WidgetState.selected)) {
                          return HvacColors.primary.withValues(alpha: 0.1);
                        }
                        if (alternateRowColor != null && entry.key.isOdd) {
                          return alternateRowColor;
                        }
                        return rowColor;
                      },
                    ),
                  ),
                )
                .toList(),
            headingRowColor: WidgetStateProperty.all(
              headerColor ?? HvacColors.backgroundCard,
            ),
            columnSpacing: columnSpacing,
            horizontalMargin: horizontalMargin,
            showCheckboxColumn: rows.any((row) => row.onSelectChanged != null),
            border: showBorders
                ? TableBorder.all(
                    color: borderColor ?? HvacColors.backgroundCardBorder,
                    width: 1,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

/// Data table column definition
class HvacDataColumn {
  /// Column header label
  final Widget label;

  /// Whether column contains numeric data
  final bool numeric;

  /// Sort callback
  final void Function(int columnIndex, bool ascending)? onSort;

  const HvacDataColumn({
    required this.label,
    this.numeric = false,
    this.onSort,
  });
}

/// Data table row definition
class HvacDataRow {
  /// Row cells
  final List<HvacDataCell> cells;

  /// Whether row is selected
  final bool selected;

  /// Selection callback
  final ValueChanged<bool?>? onSelectChanged;

  const HvacDataRow({
    required this.cells,
    this.selected = false,
    this.onSelectChanged,
  });
}

/// Data table cell definition
class HvacDataCell {
  /// Cell content
  final Widget child;

  /// Tap callback
  final VoidCallback? onTap;

  const HvacDataCell(
    this.child, {
    this.onTap,
  });
}

/// Simple key-value table
///
/// Usage:
/// ```dart
/// HvacKeyValueTable(
///   data: {
///     'Device': 'Living Room HVAC',
///     'Status': 'Active',
///     'Temperature': '24°C',
///     'Humidity': '45%',
///   },
/// )
/// ```
class HvacKeyValueTable extends StatelessWidget {
  /// Key-value data
  final Map<String, String> data;

  /// Key text style
  final TextStyle? keyStyle;

  /// Value text style
  final TextStyle? valueStyle;

  /// Row padding
  final EdgeInsets? rowPadding;

  /// Show dividers
  final bool showDividers;

  const HvacKeyValueTable({
    super.key,
    required this.data,
    this.keyStyle,
    this.valueStyle,
    this.rowPadding,
    this.showDividers = true,
  });

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
        borderRadius: HvacRadius.lgRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          entries.length,
          (index) {
            final entry = entries[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: rowPadding ??
                      const EdgeInsets.symmetric(
                        horizontal: HvacSpacing.md,
                        vertical: HvacSpacing.sm,
                      ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: keyStyle ??
                              const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: HvacColors.textSecondary,
                              ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          entry.value,
                          style: valueStyle ??
                              const TextStyle(
                                fontSize: 14,
                                color: HvacColors.textPrimary,
                              ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showDividers && index < entries.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: HvacColors.backgroundCardBorder,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
