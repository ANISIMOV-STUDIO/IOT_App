/// HVAC Menu - Popup menu and dropdown menu
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

/// Popup menu with custom styling
///
/// Usage:
/// ```dart
/// HvacMenu(
///   items: [
///     HvacMenuItem(value: 'edit', label: 'Edit', icon: Icons.edit),
///     HvacMenuItem(value: 'delete', label: 'Delete', icon: Icons.delete),
///   ],
///   onSelected: (value) => handleAction(value),
///   child: Icon(Icons.more_vert),
/// )
/// ```
class HvacMenu<T> extends StatelessWidget {
  /// Menu items
  final List<HvacMenuItem<T>> items;

  /// Selected callback
  final ValueChanged<T>? onSelected;

  /// Child widget (typically icon button)
  final Widget child;

  /// Menu position
  final PopupMenuPosition position;

  const HvacMenu({
    super.key,
    required this.items,
    this.onSelected,
    required this.child,
    this.position = PopupMenuPosition.under,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSelected,
      position: position,
      color: HvacColors.backgroundCard,
      shape: RoundedRectangleBorder(
        borderRadius: HvacRadius.lgRadius,
        side: const BorderSide(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      itemBuilder: (context) => items
          .map(
            (item) => PopupMenuItem<T>(
              value: item.value,
              enabled: item.enabled,
              child: Row(
                children: [
                  if (item.icon != null) ...[
                    Icon(
                      item.icon,
                      size: 20,
                      color: item.iconColor ?? HvacColors.textSecondary,
                    ),
                    const SizedBox(width: HvacSpacing.sm),
                  ],
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: item.enabled
                          ? HvacColors.textPrimary
                          : HvacColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      child: child,
    );
  }
}

/// Menu item model
class HvacMenuItem<T> {
  final T value;
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool enabled;

  const HvacMenuItem({
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
    this.enabled = true,
  });
}

/// Dropdown menu (Material 3 DropdownMenu)
///
/// Usage:
/// ```dart
/// HvacDropdownMenu<String>(
///   items: [
///     HvacDropdownItem(value: 'option1', label: 'Option 1'),
///     HvacDropdownItem(value: 'option2', label: 'Option 2'),
///   ],
///   onSelected: (value) => handleSelection(value),
///   hintText: 'Select option',
/// )
/// ```
class HvacDropdownMenu<T> extends StatelessWidget {
  /// Dropdown items
  final List<HvacDropdownItem<T>> items;

  /// Selection callback
  final ValueChanged<T?>? onSelected;

  /// Initial value
  final T? initialValue;

  /// Hint text
  final String? hintText;

  /// Label
  final String? label;

  /// Width
  final double? width;

  /// Enable search
  final bool enableSearch;

  const HvacDropdownMenu({
    super.key,
    required this.items,
    this.onSelected,
    this.initialValue,
    this.hintText,
    this.label,
    this.width,
    this.enableSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      initialSelection: initialValue,
      onSelected: onSelected,
      hintText: hintText,
      label: label != null ? Text(label!) : null,
      width: width,
      enableSearch: enableSearch,
      dropdownMenuEntries: items
          .map(
            (item) => DropdownMenuEntry<T>(
              value: item.value,
              label: item.label,
              leadingIcon: item.icon != null ? Icon(item.icon) : null,
              enabled: item.enabled,
            ),
          )
          .toList(),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HvacColors.backgroundCard,
        border: OutlineInputBorder(
          borderRadius: HvacRadius.lgRadius,
          borderSide: const BorderSide(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: HvacRadius.lgRadius,
          borderSide: const BorderSide(
            color: HvacColors.backgroundCardBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: HvacRadius.lgRadius,
          borderSide: const BorderSide(
            color: HvacColors.primary,
            width: 2,
          ),
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(HvacColors.backgroundCard),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: HvacRadius.lgRadius,
            side: const BorderSide(
              color: HvacColors.backgroundCardBorder,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

/// Dropdown item model
class HvacDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;
  final bool enabled;

  const HvacDropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });
}

/// Simple dropdown (classic style)
///
/// Usage:
/// ```dart
/// HvacSimpleDropdown<String>(
///   value: selectedValue,
///   items: ['Option 1', 'Option 2'],
///   onChanged: (value) => setState(() => selectedValue = value),
/// )
/// ```
class HvacSimpleDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final String Function(T)? itemLabel;
  final String? hint;

  const HvacSimpleDropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.itemLabel,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: HvacSpacing.md),
      decoration: BoxDecoration(
        color: HvacColors.backgroundCard,
        borderRadius: HvacRadius.lgRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          onChanged: onChanged,
          hint: hint != null
              ? Text(
                  hint!,
                  style: const TextStyle(
                    color: HvacColors.textTertiary,
                    fontSize: 14,
                  ),
                )
              : null,
          isExpanded: true,
          dropdownColor: HvacColors.backgroundCard,
          style: const TextStyle(
            color: HvacColors.textPrimary,
            fontSize: 14,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemLabel != null ? itemLabel!(item) : item.toString(),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
