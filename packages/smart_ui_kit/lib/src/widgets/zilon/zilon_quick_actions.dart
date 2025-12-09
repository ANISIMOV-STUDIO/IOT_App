import 'package:flutter/material.dart';
import '../../theme/tokens/app_typography.dart';
import '../smart/smart_card.dart';

class ZilonQuickActions extends StatelessWidget {
  const ZilonQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildActionButton(context, Icons.power_settings_new, 'All Off', isDestructive: true)),
            const SizedBox(width: 12),
            Expanded(child: _buildActionButton(context, Icons.calendar_today, 'Schedule')),
          ],
        ),
        const SizedBox(height: 12),
         Row(
          children: [
            Expanded(child: _buildActionButton(context, Icons.refresh, 'Sync')),
            const SizedBox(width: 12),
            Expanded(child: _buildActionButton(context, Icons.settings, 'Settings')),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, {bool isDestructive = false}) {
    final theme = Theme.of(context);
    final color = isDestructive ? theme.colorScheme.error : theme.colorScheme.primary;
    
    return SmartCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      onTap: () {},
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(label, style: AppTypography.labelSmall.copyWith(color: theme.colorScheme.onSurface)),
        ],
      ),
    );
  }
}
