/// Fan Speed Control
///
/// Modern segmented control for fan speed with animations
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../generated/l10n/app_localizations.dart';

class FanSpeedControl extends StatelessWidget {
  final String selectedSpeed;
  final ValueChanged<String> onSpeedChanged;
  final bool enabled;
  final String mode;

  const FanSpeedControl({
    super.key,
    required this.selectedSpeed,
    required this.onSpeedChanged,
    this.enabled = true,
    this.mode = 'auto',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final speedIndex = _getSpeedIndex(selectedSpeed);
    final modeColor = AppTheme.getModeColor(mode);

    void handleValueChanged(int? value) {
      if (value != null) {
        onSpeedChanged(_getSpeedName(value));
      }
    }

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.fanSpeed,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      enabled ? l10n.adjustAirflow : l10n.deviceIsOff,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppTheme.darkTextHint
                                : AppTheme.lightTextHint,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (enabled)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        modeColor,
                        modeColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: modeColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getSpeedIcon(selectedSpeed),
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        selectedSpeed.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
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
              absorbing: !enabled,
              child: Opacity(
                opacity: enabled ? 1.0 : 0.5,
                child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: speedIndex,
                  onValueChanged: handleValueChanged,
                  backgroundColor: Colors.transparent,
                  thumbColor: modeColor,
                  children: _buildSegments(context, isDark),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Speed indicator
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
            child: _buildSpeedIndicator(selectedSpeed, isDark, modeColor, context),
          ),
        ],
      ),
    );
  }

  Map<int, Widget> _buildSegments(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return {
      0: _buildSegmentItem(
        l10n.low,
        Icons.air_rounded,
        selectedSpeed == 'low',
        isDark,
        0.3,
      ),
      1: _buildSegmentItem(
        l10n.medium,
        Icons.air_rounded,
        selectedSpeed == 'medium',
        isDark,
        0.6,
      ),
      2: _buildSegmentItem(
        l10n.high,
        Icons.air_rounded,
        selectedSpeed == 'high',
        isDark,
        1.0,
      ),
      3: _buildSegmentItem(
        l10n.auto,
        Icons.autorenew_rounded,
        selectedSpeed == 'auto',
        isDark,
        0.8,
      ),
    };
  }

  Widget _buildSegmentItem(
    String label,
    IconData icon,
    bool isSelected,
    bool isDark,
    double intensity,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isSelected)
                ...List.generate(
                  (intensity * 3).round(),
                  (index) => Positioned(
                    child: Icon(
                      Icons.circle,
                      color: Colors.white.withOpacity(0.2 - index * 0.05),
                      size: 24 + index * 3.0,
                    ),
                  ),
                ),
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.lightTextSecondary),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedIndicator(String speed, bool isDark, Color modeColor, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final descriptions = {
      'low': l10n.gentleAirflow,
      'medium': l10n.balancedAirflow,
      'high': l10n.maximumAirflow,
      'auto': l10n.autoAdjustSpeed,
    };

    final powerLevels = {
      'low': 0.3,
      'medium': 0.6,
      'high': 1.0,
      'auto': 0.75,
    };

    return Container(
      key: ValueKey(speed),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.darkSurface.withOpacity(0.3)
            : AppTheme.lightSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: modeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      modeColor,
                      modeColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getSpeedIcon(speed),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  descriptions[speed] ?? 'Select a speed',
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
          const SizedBox(height: 12),
          // Power level indicator
          Row(
            children: [
              Text(
                l10n.power,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppTheme.darkTextHint
                          : AppTheme.lightTextHint,
                    ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: powerLevels[speed] ?? 0.5,
                    minHeight: 6,
                    backgroundColor: isDark
                        ? AppTheme.darkBorder.withOpacity(0.3)
                        : AppTheme.lightBorder.withOpacity(0.5),
                    valueColor: AlwaysStoppedAnimation<Color>(modeColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${((powerLevels[speed] ?? 0.5) * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: modeColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getSpeedIcon(String speed) {
    switch (speed.toLowerCase()) {
      case 'low':
        return Icons.air_rounded;
      case 'medium':
        return Icons.air_rounded;
      case 'high':
        return Icons.air_rounded;
      case 'auto':
        return Icons.autorenew_rounded;
      default:
        return Icons.air_rounded;
    }
  }

  int _getSpeedIndex(String speed) {
    switch (speed.toLowerCase()) {
      case 'low':
        return 0;
      case 'medium':
        return 1;
      case 'high':
        return 2;
      case 'auto':
        return 3;
      default:
        return 3;
    }
  }

  String _getSpeedName(int index) {
    switch (index) {
      case 0:
        return 'low';
      case 1:
        return 'medium';
      case 2:
        return 'high';
      case 3:
        return 'auto';
      default:
        return 'auto';
    }
  }
}
