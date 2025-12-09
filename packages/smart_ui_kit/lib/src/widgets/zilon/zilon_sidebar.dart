import 'package:flutter/material.dart';
import '../../theme/tokens/app_typography.dart';
import '../../theme/tokens/app_spacing.dart';

class ZilonSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const ZilonSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 240, // Fixed width for sidebar
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: theme.scaffoldBackgroundColor, // Blend with background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.air, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'ZILON',
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 22,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // Menu Items
          _buildNavItem(context, 0, Icons.dashboard_rounded, 'Dashboard'),
          _buildNavItem(context, 1, Icons.tune_rounded, 'Controls'),
          _buildNavItem(context, 2, Icons.calendar_today_rounded, 'Schedule'),
          _buildNavItem(context, 3, Icons.show_chart_rounded, 'Statistics'),
          
          const Spacer(),
          
          // Bottom Actions
          _buildNavItem(context, 4, Icons.settings_rounded, 'Settings'),
          const SizedBox(height: 12),
          // User Profile Stub
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: colorScheme.primary.withOpacity(0.2),
                  child: Text('U', style: TextStyle(color: colorScheme.primary)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User', style: AppTypography.labelSmall.copyWith(color: colorScheme.onSurface)),
                    Text('Admin', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onItemSelected(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
