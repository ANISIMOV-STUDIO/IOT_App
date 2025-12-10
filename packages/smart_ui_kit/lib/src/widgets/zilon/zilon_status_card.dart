import 'package:flutter/material.dart';
import '../../theme/tokens/app_typography.dart';
import '../smart/smart_card.dart';

class ZilonStatusCard extends StatelessWidget {
  final String roomName;
  final bool isPowerOn;
  final VoidCallback onToggle;
  
  const ZilonStatusCard({
    super.key,
    required this.roomName,
    required this.isPowerOn,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Switch Icon
              Icon(
                Icons.power_settings_new,
                color: isPowerOn ? colorScheme.primary : colorScheme.onSurface.withAlpha(128),
              ),
              Switch(
                value: isPowerOn, 
                onChanged: (_) => onToggle(),
                activeThumbColor: colorScheme.primary,
              ),
            ],
          ),
          const Spacer(),
          Text(
            roomName,
            style: AppTypography.displayMedium.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            isPowerOn ? 'Active' : 'Standby',
            style: AppTypography.bodyMedium.copyWith(
              color: isPowerOn ? colorScheme.primary : colorScheme.onSurface.withAlpha(128),
            ),
          ),
        ],
      ),
    );
  }
}
