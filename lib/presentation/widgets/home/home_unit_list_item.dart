/// Home Unit List Item
///
/// List item component for sidebar unit selection
library;

import 'package:flutter/material.dart';
import 'package:hvac_ui_kit/hvac_ui_kit.dart';
import '../../../domain/entities/hvac_unit.dart';

/// Unit list item for sidebar
class HomeUnitListItem extends StatelessWidget {
  final HvacUnit unit;
  final bool isSelected;
  final VoidCallback onTap;

  const HomeUnitListItem({
    super.key,
    required this.unit,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: HvacCard(
        variant: HvacCardVariant.outlined,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              StatusIndicator(
                isActive: unit.power,
                size: 8,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit.name,
                      style: HvacTypography.titleMedium.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unit.location ?? '',
                      style: HvacTypography.bodySmall.copyWith(
                        color: HvacColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
