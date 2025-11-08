/// HVAC Segmented Button - Material Design 3 segmented control
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// Material Design 3 segmented button
///
/// Features:
/// - Single or multiple selection
/// - Icon support
/// - Material 3 styling
/// - Custom colors
///
/// Usage:
/// ```dart
/// HvacSegmentedButton<String>(
///   segments: [
///     HvacSegment(value: 'day', label: 'Day', icon: Icons.today),
///     HvacSegment(value: 'week', label: 'Week', icon: Icons.date_range),
///   ],
///   selected: {'day'},
///   onSelectionChanged: (value) => print(value),
/// )
/// ```
class HvacSegmentedButton<T> extends StatelessWidget {
  /// Button segments
  final List<HvacSegment<T>> segments;

  /// Selected value (single selection)
  final Set<T> selected;

  /// Selection changed callback
  final ValueChanged<Set<T>>? onSelectionChanged;

  /// Allow multiple selection
  final bool multipleSelection;

  /// Empty selection allowed
  final bool emptySelectionAllowed;

  /// Selected color
  final Color? selectedColor;

  /// Unselected color
  final Color? unselectedColor;

  const HvacSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
    this.multipleSelection = false,
    this.emptySelectionAllowed = false,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments
          .map(
            (segment) => ButtonSegment<T>(
              value: segment.value,
              label: Text(segment.label),
              icon: segment.icon != null ? Icon(segment.icon) : null,
              enabled: segment.enabled,
            ),
          )
          .toList(),
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      multiSelectionEnabled: multipleSelection,
      emptySelectionAllowed: emptySelectionAllowed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return selectedColor ?? HvacColors.primary;
            }
            return unselectedColor;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return HvacColors.textPrimary;
          },
        ),
      ),
    );
  }
}

/// Segment model for HvacSegmentedButton
class HvacSegment<T> {
  /// Segment value
  final T value;

  /// Segment label
  final String label;

  /// Segment icon (optional)
  final IconData? icon;

  /// Whether segment is enabled
  final bool enabled;

  const HvacSegment({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });
}

/// Compact segmented button (icon only)
///
/// Usage:
/// ```dart
/// HvacCompactSegmentedButton<String>(
///   segments: [
///     HvacIconSegment(value: 'grid', icon: Icons.grid_view),
///     HvacIconSegment(value: 'list', icon: Icons.list),
///   ],
///   selected: {'grid'},
///   onSelectionChanged: (value) => print(value),
/// )
/// ```
class HvacCompactSegmentedButton<T> extends StatelessWidget {
  final List<HvacIconSegment<T>> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>>? onSelectionChanged;

  const HvacCompactSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments
          .map(
            (segment) => ButtonSegment<T>(
              value: segment.value,
              icon: Icon(segment.icon),
            ),
          )
          .toList(),
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      showSelectedIcon: false,
    );
  }
}

/// Icon segment model
class HvacIconSegment<T> {
  final T value;
  final IconData icon;

  const HvacIconSegment({
    required this.value,
    required this.icon,
  });
}
