/// Units List - Scrollable widget to manage HVAC units
library;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Unit item data for the list
class UnitListItem {
  final String id;
  final String name;
  final String location;
  final int temperature;
  final bool isPowered;
  final String mode;

  const UnitListItem({
    required this.id,
    required this.name,
    required this.location,
    required this.temperature,
    this.isPowered = true,
    this.mode = 'auto',
  });
}

/// Scrollable units list widget
class UnitsList extends StatelessWidget {
  final List<UnitListItem> units;
  final String? selectedUnitId;
  final ValueChanged<String>? onUnitSelected;
  final VoidCallback? onAddUnit;

  const UnitsList({
    super.key,
    required this.units,
    this.selectedUnitId,
    this.onUnitSelected,
    this.onAddUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Units list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(0),
            itemCount: units.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final unit = units[index];
              final isSelected = unit.id == selectedUnitId;

              return _UnitCard(
                unit: unit,
                isSelected: isSelected,
                onTap: () => onUnitSelected?.call(unit.id),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Add unit button
        _AddUnitButton(onTap: onAddUnit),
      ],
    );
  }
}

/// Individual unit card in the list
class _UnitCard extends StatefulWidget {
  final UnitListItem unit;
  final bool isSelected;
  final VoidCallback? onTap;

  const _UnitCard({
    required this.unit,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<_UnitCard> createState() => _UnitCardState();
}

class _UnitCardState extends State<_UnitCard> {
  bool _isHovered = false;

  IconData _getModeIcon() {
    switch (widget.unit.mode) {
      case 'cooling':
        return Icons.ac_unit;
      case 'heating':
        return Icons.whatshot;
      case 'ventilation':
        return Icons.air;
      default:
        return Icons.autorenew;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.accent.withValues(alpha: 0.1)
                : _isHovered
                    ? Colors.white.withValues(alpha: 0.03)
                    : AppColors.darkCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : AppColors.darkBorder,
              width: widget.isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.unit.isPowered
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getModeIcon(),
                  size: 22,
                  color: widget.unit.isPowered
                      ? AppColors.accent
                      : AppColors.darkTextMuted,
                ),
              ),

              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.unit.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.unit.location,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.darkTextMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Temperature
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.unit.temperature}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '°',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Add unit button with dashed border
class _AddUnitButton extends StatefulWidget {
  final VoidCallback? onTap;

  const _AddUnitButton({this.onTap});

  @override
  State<_AddUnitButton> createState() => _AddUnitButtonState();
}

class _AddUnitButtonState extends State<_AddUnitButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : AppColors.darkBorder,
              style: BorderStyle.solid,
            ),
          ),
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: AppColors.darkTextMuted,
              strokeWidth: 1,
              dashWidth: 6,
              dashSpace: 4,
              radius: 18,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: AppColors.darkTextMuted,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Добавить установку',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.darkTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dashed border painter
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1,
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.radius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dashed border is handled by the parent container
    // This is a placeholder for more complex dashed implementations
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
