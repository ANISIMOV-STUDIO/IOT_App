/// Lazy List Item Component
/// Individual list item with visibility detection using HVAC UI Kit
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../../domain/entities/hvac_unit.dart';
import '../optimized_hvac_card.dart';

/// Lazy list item with automatic visibility detection
class LazyListItem extends StatefulWidget {
  final HvacUnit unit;
  final bool isSelected;
  final int index;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onPowerChanged;

  const LazyListItem({
    super.key,
    required this.unit,
    required this.isSelected,
    required this.index,
    this.onTap,
    this.onPowerChanged,
  });

  @override
  State<LazyListItem> createState() => _LazyListItemState();
}

class _LazyListItemState extends State<LazyListItem>
    with AutomaticKeepAliveClientMixin {
  bool _isVisible = false;

  @override
  bool get wantKeepAlive => widget.isSelected || _isVisible;

  @override
  void initState() {
    super.initState();
    // Stagger the appearance animation using UI Kit stagger delay
    Future.delayed(AnimationDurations.staggerMedium * widget.index, () {
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

    // Use HVAC UI Kit animations for smooth entrance
    return AnimatedOpacity(
      duration: AnimationDurations.medium,
      opacity: _isVisible ? 1.0 : 0.0,
      curve: SmoothCurves.emphasized,
      child: AnimatedSlide(
        duration: AnimationDurations.medium,
        curve: SmoothCurves.emphasized,
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
