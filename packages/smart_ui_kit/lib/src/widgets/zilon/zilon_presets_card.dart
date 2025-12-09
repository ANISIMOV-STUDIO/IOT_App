import 'package:flutter/material.dart';
import '../../theme/tokens/app_typography.dart';
import '../smart/smart_card.dart';

class ZilonPresetsCard extends StatelessWidget {
  const ZilonPresetsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text('Quick Presets', style: AppTypography.displayMedium.copyWith(fontSize: 18, color: theme.colorScheme.onSurface)),
               Icon(Icons.tune, color: theme.colorScheme.primary),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildPresetChip(context, 'Auto Mode', Icons.hdr_auto, true),
              _buildPresetChip(context, 'Night Mode', Icons.nights_stay, false),
              _buildPresetChip(context, 'Turbo', Icons.rocket_launch, false),
              _buildPresetChip(context, 'Eco', Icons.eco, false),
              _buildPresetChip(context, 'Away', Icons.sensor_door, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(BuildContext context, String label, IconData icon, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? colorScheme.primary : colorScheme.outline,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon, 
                size: 16, 
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
