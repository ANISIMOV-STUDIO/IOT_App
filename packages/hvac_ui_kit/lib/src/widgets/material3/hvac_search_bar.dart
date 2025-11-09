/// HVAC Search Bar - Material Design 3 search
library;

import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/radius.dart';

/// Material Design 3 search bar
///
/// Features:
/// - Search input with icon
/// - Suggestions support
/// - Clear button
/// - Custom styling
///
/// Usage:
/// ```dart
/// HvacSearchBar(
///   hintText: 'Search devices...',
///   onChanged: (value) => search(value),
/// )
/// ```
class HvacSearchBar extends StatefulWidget {
  /// Hint text
  final String? hintText;

  /// Initial value
  final String? initialValue;

  /// Change callback
  final ValueChanged<String>? onChanged;

  /// Submit callback
  final ValueChanged<String>? onSubmitted;

  /// Leading icon
  final Widget? leading;

  /// Trailing widgets
  final List<Widget>? trailing;

  /// Background color
  final Color? backgroundColor;

  /// Text color
  final Color? textColor;

  /// Hint color
  final Color? hintColor;

  /// Enable auto focus
  final bool autofocus;

  /// Text controller
  final TextEditingController? controller;

  const HvacSearchBar({
    super.key,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.textColor,
    this.hintColor,
    this.autofocus = false,
    this.controller,
  });

  @override
  State<HvacSearchBar> createState() => _HvacSearchBarState();
}

class _HvacSearchBarState extends State<HvacSearchBar> {
  late TextEditingController _controller;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
      _showClearButton = widget.initialValue!.isNotEmpty;
    }
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChange() {
    setState(() {
      _showClearButton = _controller.text.isNotEmpty;
    });
    widget.onChanged?.call(_controller.text);
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? HvacColors.backgroundCard,
        borderRadius: HvacRadius.lgRadius,
        border: Border.all(
          color: HvacColors.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        onSubmitted: widget.onSubmitted,
        style: TextStyle(
          color: widget.textColor ?? HvacColors.textPrimary,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search...',
          hintStyle: TextStyle(
            color: widget.hintColor ?? HvacColors.textTertiary,
            fontSize: 16,
          ),
          border: InputBorder.none,
          prefixIcon: widget.leading ??
              const Icon(
                Icons.search,
                color: HvacColors.textSecondary,
              ),
          suffixIcon: _showClearButton || widget.trailing != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_showClearButton)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                        color: HvacColors.textSecondary,
                      ),
                    if (widget.trailing != null) ...widget.trailing!,
                  ],
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: HvacSpacing.md,
            vertical: HvacSpacing.sm,
          ),
        ),
      ),
    );
  }
}

/// Compact search bar
///
/// Usage:
/// ```dart
/// HvacCompactSearchBar(
///   onChanged: (value) => search(value),
/// )
/// ```
class HvacCompactSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;

  const HvacCompactSearchBar({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: HvacSearchBar(
        hintText: hintText,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

/// Search bar with suggestions
///
/// Usage:
/// ```dart
/// HvacSearchBarWithSuggestions(
///   hintText: 'Search...',
///   suggestions: ['Device 1', 'Device 2'],
///   onSuggestionSelected: (value) => navigate(value),
/// )
/// ```
class HvacSearchBarWithSuggestions extends StatefulWidget {
  final String? hintText;
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionSelected;
  final ValueChanged<String>? onChanged;

  const HvacSearchBarWithSuggestions({
    super.key,
    this.hintText,
    required this.suggestions,
    this.onSuggestionSelected,
    this.onChanged,
  });

  @override
  State<HvacSearchBarWithSuggestions> createState() =>
      _HvacSearchBarWithSuggestionsState();
}

class _HvacSearchBarWithSuggestionsState
    extends State<HvacSearchBarWithSuggestions> {
  final TextEditingController _controller = TextEditingController();
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_filterSuggestions);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterSuggestions() {
    final query = _controller.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSuggestions = [];
        _showSuggestions = false;
      } else {
        _filteredSuggestions = widget.suggestions
            .where((s) => s.toLowerCase().contains(query))
            .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      }
    });
    widget.onChanged?.call(_controller.text);
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    setState(() {
      _showSuggestions = false;
    });
    widget.onSuggestionSelected?.call(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HvacSearchBar(
          hintText: widget.hintText,
          controller: _controller,
        ),
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: HvacSpacing.xs),
            decoration: BoxDecoration(
              color: HvacColors.backgroundCard,
              borderRadius: HvacRadius.lgRadius,
              border: Border.all(
                color: HvacColors.backgroundCardBorder,
                width: 1,
              ),
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _filteredSuggestions[index];
                return ListTile(
                  title: Text(
                    suggestion,
                    style: const TextStyle(
                      fontSize: 14,
                      color: HvacColors.textPrimary,
                    ),
                  ),
                  onTap: () => _selectSuggestion(suggestion),
                  dense: true,
                );
              },
            ),
          ),
      ],
    );
  }
}
