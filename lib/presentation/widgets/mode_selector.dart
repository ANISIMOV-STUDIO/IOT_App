/// Mode Selector
///
/// Modern segmented control for HVAC mode with animations
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../generated/l10n/app_localizations.dart';

class ModeSelector extends StatefulWidget {
  final String selectedMode;
  final ValueChanged<String> onModeChanged;
  final bool enabled;

  const ModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
    this.enabled = true,
  });

  @override
  State<ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleValueChanged(int? value) {
    if (value != null) {
      _controller.forward().then((_) => _controller.reverse());
      widget.onModeChanged(_getModeName(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final selectedModeValue = _getModeIndex(widget.selectedMode);

    return Container(
      decoration: AppTheme.glassmorphicCard(
        isDark: isDark,
        borderRadius: 24,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.operatingMode,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.enabled
                        ? l10n.selectHvacMode
                        : l10n.deviceIsOff,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppTheme.darkTextHint
                              : AppTheme.lightTextHint,
                        ),
                  ),
                ],
              ),
              if (widget.enabled)
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.getModeGradient(
                            widget.selectedMode,
                            isDark: isDark,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.getModeColor(widget.selectedMode)
                                  .withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          AppTheme.getModeIcon(widget.selectedMode),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Cupertino Sliding Segmented Control
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.darkSurface.withOpacity(0.5)
                  : AppTheme.lightSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(4),
            child: AbsorbPointer(
              absorbing: !widget.enabled,
              child: Opacity(
                opacity: widget.enabled ? 1.0 : 0.5,
                child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: selectedModeValue,
                  onValueChanged: _handleValueChanged,
                  backgroundColor: Colors.transparent,
                  thumbColor: AppTheme.getModeColor(widget.selectedMode),
                  children: _buildSegments(isDark),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Mode descriptions
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _buildModeDescription(
              widget.selectedMode,
              isDark,
            ),
          ),
        ],
      ),
    );
  }

  Map<int, Widget> _buildSegments(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return {
      0: _buildSegmentItem(
        l10n.cooling,
        Icons.ac_unit_rounded,
        widget.selectedMode == 'cooling',
        isDark,
      ),
      1: _buildSegmentItem(
        l10n.heating,
        Icons.local_fire_department_rounded,
        widget.selectedMode == 'heating',
        isDark,
      ),
      2: _buildSegmentItem(
        l10n.auto,
        Icons.autorenew_rounded,
        widget.selectedMode == 'auto',
        isDark,
      ),
      3: _buildSegmentItem(
        l10n.fan,
        Icons.air_rounded,
        widget.selectedMode == 'fan',
        isDark,
      ),
    };
  }

  Widget _buildSegmentItem(
    String label,
    IconData icon,
    bool isSelected,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? Colors.white
                : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
            size: 18,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeDescription(String mode, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final descriptions = {
      'cooling': l10n.coolDownToTarget,
      'heating': l10n.heatUpToTarget,
      'auto': l10n.autoAdjustTemperature,
      'fan': l10n.circulateAir,
    };

    final icons = {
      'cooling': Icons.ac_unit_rounded,
      'heating': Icons.local_fire_department_rounded,
      'auto': Icons.autorenew_rounded,
      'fan': Icons.air_rounded,
    };

    return Container(
      key: ValueKey(mode),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.darkSurface.withOpacity(0.3)
            : AppTheme.lightSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.getModeColor(mode).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppTheme.getModeGradient(mode, isDark: isDark),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icons[mode] ?? Icons.thermostat_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              descriptions[mode] ?? 'Select a mode',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  int _getModeIndex(String mode) {
    switch (mode.toLowerCase()) {
      case 'cooling':
        return 0;
      case 'heating':
        return 1;
      case 'auto':
        return 2;
      case 'fan':
        return 3;
      default:
        return 2;
    }
  }

  String _getModeName(int index) {
    switch (index) {
      case 0:
        return 'cooling';
      case 1:
        return 'heating';
      case 2:
        return 'auto';
      case 3:
        return 'fan';
      default:
        return 'auto';
    }
  }
}
