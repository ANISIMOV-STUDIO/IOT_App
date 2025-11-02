/// Air Quality Indicator Widget
///
/// Visual indicator for air quality with animation
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

enum AirQualityLevel {
  excellent,
  good,
  moderate,
  poor,
  veryPoor,
}

class AirQualityIndicator extends StatefulWidget {
  final AirQualityLevel level;
  final int? co2Level;
  final double? pm25Level;
  final double? vocLevel;

  const AirQualityIndicator({
    super.key,
    required this.level,
    this.co2Level,
    this.pm25Level,
    this.vocLevel,
  });

  @override
  State<AirQualityIndicator> createState() => _AirQualityIndicatorState();
}

class _AirQualityIndicatorState extends State<AirQualityIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getLevelColor() {
    switch (widget.level) {
      case AirQualityLevel.excellent:
        return const Color(0xFF10B981);
      case AirQualityLevel.good:
        return const Color(0xFF84CC16);
      case AirQualityLevel.moderate:
        return const Color(0xFFFBBF24);
      case AirQualityLevel.poor:
        return const Color(0xFFF97316);
      case AirQualityLevel.veryPoor:
        return const Color(0xFFEF4444);
    }
  }

  String _getLevelText() {
    switch (widget.level) {
      case AirQualityLevel.excellent:
        return 'Отлично';
      case AirQualityLevel.good:
        return 'Хорошо';
      case AirQualityLevel.moderate:
        return 'Умеренно';
      case AirQualityLevel.poor:
        return 'Плохо';
      case AirQualityLevel.veryPoor:
        return 'Очень плохо';
    }
  }

  IconData _getLevelIcon() {
    switch (widget.level) {
      case AirQualityLevel.excellent:
        return Icons.sentiment_very_satisfied;
      case AirQualityLevel.good:
        return Icons.sentiment_satisfied;
      case AirQualityLevel.moderate:
        return Icons.sentiment_neutral;
      case AirQualityLevel.poor:
        return Icons.sentiment_dissatisfied;
      case AirQualityLevel.veryPoor:
        return Icons.sentiment_very_dissatisfied;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getLevelColor();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundCardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.air,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Качество воздуха',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Animated circle indicator
          Center(
            child: SizedBox(
              width: 160,
              height: 160,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer pulsing circle
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.1 * _animation.value),
                        ),
                      ),
                      // Middle circle
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.15),
                        ),
                      ),
                      // Inner circle with icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.2),
                        ),
                        child: Icon(
                          _getLevelIcon(),
                          color: color,
                          size: 40,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Quality level text
          Center(
            child: Text(
              _getLevelText(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Metrics
          if (widget.co2Level != null || widget.pm25Level != null || widget.vocLevel != null) ...[
            const Divider(color: AppTheme.backgroundCardBorder),
            const SizedBox(height: 16),
            if (widget.co2Level != null)
              _buildMetric('CO₂', '${widget.co2Level} ppm', Icons.cloud),
            if (widget.pm25Level != null)
              _buildMetric('PM2.5', '${widget.pm25Level?.toInt()} μg/m³', Icons.grain),
            if (widget.vocLevel != null)
              _buildMetric('VOC', '${widget.vocLevel?.toInt()} ppb', Icons.science),
          ],
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
